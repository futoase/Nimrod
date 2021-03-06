#
#
#            Nimrod's Runtime Library
#        (c) Copyright 2011 Dominik Picheta
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

## This module implements an asynchronous IRC client.
## 
## Currently this module requires at least some knowledge of the IRC protocol.
## It provides a function for sending raw messages to the IRC server, together
## with some basic functions like sending a message to a channel. 
## It automizes the process of keeping the connection alive, so you don't
## need to reply to PING messages. In fact, the server is also PING'ed to check 
## the amount of lag.
##
## .. code-block:: Nimrod
##   var client = irc("irc.server.net", joinChans = @["#channel"])
##   client.connect()
##   while True:
##     var event: TIRCEvent
##     if client.poll(event):
##       case event.typ
##       of EvDisconnected: break
##       of EvMsg:
##         # Where all the magic happens. 

import sockets, strutils, parseutils, times

type
  TIRC* = object
    address: string
    port: TPort
    nick, user, realname, serverPass: string
    sock: TSocket
    connected: bool
    lastPing: float
    lastPong: float
    lag: float
    channelsToJoin: seq[string]
    msgLimit: bool
    messageBuffer: seq[tuple[timeToSend: float, m: string]]

  TIRCMType* = enum
    MUnknown,
    MNumeric,
    MPrivMsg,
    MJoin,
    MPart,
    MMode,
    MTopic,
    MInvite,
    MKick,
    MQuit,
    MNick,
    MNotice,
    MPing,
    MPong,
    MError
  
  TIRCEventType* = enum
    EvMsg, EvDisconnected
  TIRCEvent* = object
    case typ*: TIRCEventType
    of EvDisconnected: nil
    of EvMsg:
      cmd*: TIRCMType
      nick*, user*, host*, servername*: string
      numeric*: string
      params*: seq[string]
      origin*: string ## The channel/user that this msg originated from
      raw*: string
  
proc send*(irc: var TIRC, message: string, sendImmediately = false) =
  ## Sends ``message`` as a raw command. It adds ``\c\L`` for you.
  var sendMsg = true
  if irc.msgLimit and not sendImmediately:
    var timeToSend = epochTime()
    if irc.messageBuffer.len() >= 3:
      timeToSend = (irc.messageBuffer[irc.messageBuffer.len()-1][0] + 2.0)

    irc.messageBuffer.add((timeToSend, message))
    sendMsg = false

  if sendMsg:
    try:
      irc.sock.send(message & "\c\L")
    except EOS:
      # Assuming disconnection of every EOS could be bad,
      # but I can't exactly check for EBrokenPipe.
      irc.connected = false

proc privmsg*(irc: var TIRC, target, message: string) =
  ## Sends ``message`` to ``target``. ``Target`` can be a channel, or a user.
  irc.send("PRIVMSG $1 :$2" % [target, message])

proc notice*(irc: var TIRC, target, message: string) =
  ## Sends ``notice`` to ``target``. ``Target`` can be a channel, or a user. 
  irc.send("NOTICE $1 :$2" % [target, message])

proc join*(irc: var TIRC, channel: string, key = "") =
  ## Joins ``channel``.
  ## 
  ## If key is not ``""``, then channel is assumed to be key protected and this
  ## function will join the channel using ``key``.
  if key == "":
    irc.send("JOIN " & channel)
  else:
    irc.send("JOIN " & channel & " " & key)

proc part*(irc: var TIRC, channel, message: string) =
  ## Leaves ``channel`` with ``message``.
  irc.send("PART " & channel & " :" & message)

proc isNumber(s: string): bool =
  ## Checks if `s` contains only numbers.
  var i = 0
  while s[i] in {'0'..'9'}: inc(i)
  result = i == s.len and s.len > 0

proc parseMessage(msg: string): TIRCEvent =
  result.typ = EvMsg
  result.cmd = MUnknown
  result.raw = msg
  var i = 0
  # Process the prefix
  if msg[i] == ':':
    inc(i) # Skip `:`
    var nick = ""
    i.inc msg.parseUntil(nick, {'!', ' '}, i)
    if msg[i] == '!':
      result.nick = nick
      inc(i) # Skip `!`
      i.inc msg.parseUntil(result.user, {'@'}, i)
      inc(i) # Skip `@`
      i.inc msg.parseUntil(result.host, {' '}, i)
      inc(i) # Skip ` `
    else:
      result.serverName = nick
      inc(i) # Skip ` `
  
  # Process command
  var cmd = ""
  i.inc msg.parseUntil(cmd, {' '}, i)

  if cmd.isNumber:
    result.cmd = MNumeric
    result.numeric = cmd
  else:
    case cmd
    of "PRIVMSG": result.cmd = MPrivMsg
    of "JOIN": result.cmd = MJoin
    of "PART": result.cmd = MPart
    of "PONG": result.cmd = MPong
    of "PING": result.cmd = MPing
    of "MODE": result.cmd = MMode
    of "TOPIC": result.cmd = MTopic
    of "INVITE": result.cmd = MInvite
    of "KICK": result.cmd = MKick
    of "QUIT": result.cmd = MQuit
    of "NICK": result.cmd = MNick
    of "NOTICE": result.cmd = MNotice
    of "ERROR": result.cmd = MError
    else: result.cmd = MUnknown
  
  # Don't skip space here. It is skipped in the following While loop.
  
  # Params
  result.params = @[]
  var param = ""
  while msg[i] != '\0' and msg[i] != ':':
    inc(i) # Skip ` `.
    i.inc msg.parseUntil(param, {' ', ':', '\0'}, i)
    if param != "":
      result.params.add(param)
      param.setlen(0)
  
  if msg[i] == ':':
    inc(i) # Skip `:`.
    result.params.add(msg[i..msg.len-1])

proc connect*(irc: var TIRC) =
  ## Connects to an IRC server as specified by ``irc``.
  assert(irc.address != "")
  assert(irc.port != TPort(0))
  
  irc.sock = socket()
  irc.sock.connect(irc.address, irc.port)
 
  irc.connected = true
  
  # Greet the server :)
  if irc.serverPass != "": irc.send("PASS " & irc.serverPass, true)
  irc.send("NICK " & irc.nick, true)
  irc.send("USER $1 * 0 :$2" % [irc.user, irc.realname], true)

proc irc*(address: string, port: TPort = 6667.TPort,
         nick = "NimrodBot",
         user = "NimrodBot",
         realname = "NimrodBot", serverPass = "",
         joinChans: seq[string] = @[],
         msgLimit: bool = true): TIRC =
  ## This function calls `connect`, so you don't need to.
  result.address = address
  result.port = port
  result.nick = nick
  result.user = user
  result.realname = realname
  result.serverPass = serverPass
  result.lastPing = epochTime()
  result.lastPong = -1.0
  result.lag = -1.0
  result.channelsToJoin = joinChans
  result.msgLimit = msgLimit
  result.messageBuffer = @[]

  result.connect()
  
proc poll*(irc: var TIRC, ev: var TIRCEvent,
           timeout: int = 500): bool =
  ## This function parses a single message from the IRC server and returns 
  ## a TIRCEvent.
  ##
  ## This function should be called often as it also handles pinging
  ## the server.
  if not irc.connected: ev.typ = EvDisconnected
  var line = TaintedString""
  var socks = @[irc.sock]
  var ret = socks.select(timeout)
  if socks.len() == 0 and ret == 1:
    if irc.sock.recvLine(line):
      if line.string.len == 0:
        ev.typ = EvDisconnected
      else:
        ev = parseMessage(line.string)
        # Get the origin
        ev.origin = ev.params[0]
        if ev.origin == irc.nick: ev.origin = ev.nick

        if ev.cmd == MError:
          ev.typ = EvDisconnected
          return

        if ev.cmd == MPing:
          irc.send("PONG " & ev.params[0])
        if ev.cmd == MPong:
          irc.lag = epochTime() - parseFloat(ev.params[ev.params.high])
          irc.lastPong = epochTime()
        if ev.cmd == MNumeric:
          if ev.numeric == "001":
            for chan in items(irc.channelsToJoin):
              irc.join(chan)
      result = true

  if epochTime() - irc.lastPing >= 20.0:
    irc.lastPing = epochTime()
    irc.send("PING :" & formatFloat(irc.lastPing), true)

  if epochTime() - irc.lastPong >= 120.0 and irc.lastPong != -1.0:
    ev.typ = EvDisconnected # TODO: EvTimeout?
    return true

  
  for i in 0..irc.messageBuffer.len-1:
    if epochTime() >= irc.messageBuffer[0][0]:
      irc.send(irc.messageBuffer[0].m, true)
      irc.messageBuffer.delete(0)
    else:
      break # messageBuffer is guaranteed to be from the quickest to the
            # later-est.

proc getLag*(irc: var TIRC): float =
  ## Returns the latency between this client and the IRC server in seconds.
  ## 
  ## If latency is unknown, returns -1.0.
  return irc.lag

proc isConnected*(irc: var TIRC): bool =
  ## Returns whether this IRC client is connected to an IRC server.
  return irc.connected

when isMainModule:
  #var m = parseMessage("ERROR :Closing Link: dom96.co.cc (Ping timeout: 252 seconds)")
  #echo(repr(m))

  #discard """
  
  var client = irc("amber.tenthbit.net", nick="TestBot1234",
                   joinChans = @["#flood"])
  while True:
    var event: TIRCEvent
    if client.poll(event):
      case event.typ
      of EvDisconnected:
        break
      of EvMsg:
        if event.cmd == MPrivMsg:
          var msg = event.params[event.params.high]
          if msg == "|test": client.privmsg(event.origin, "hello")
          if msg == "|excessFlood":
            for i in 0..10:
              client.privmsg(event.origin, "TEST" & $i)

        #echo( repr(event) )
      #echo("Lag: ", formatFloat(client.getLag()))
  #"""
