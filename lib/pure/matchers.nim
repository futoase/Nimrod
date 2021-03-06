#
#
#            Nimrod's Runtime Library
#        (c) Copyright 2011 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

## This module contains various string matchers for email addresses, etc.
{.deadCodeElim: on.}

{.push debugger:off .} # the user does not want to trace a part
                       # of the standard library!

include "system/inclrtl"

import strutils

proc validEmailAddress*(s: string): bool {.noSideEffect,
  rtl, extern: "nsuValidEmailAddress".} = 
  ## returns true if `s` seems to be a valid e-mail address. 
  ## The checking also uses a domain list.
  const
    chars = Letters + Digits + {'!','#','$','%','&',
      '\'','*','+','/','=','?','^','_','`','{','}','|','~','-','.'}
  var i = 0
  if s[i] notin chars or s[i] == '.': return false
  while s[i] in chars: 
    if s[i] == '.' and s[i+1] == '.': return false
    inc(i)
  if s[i] != '@': return false
  var j = len(s)-1
  if s[j] notin letters: return false
  while j >= i and s[j] in letters: dec(j)
  inc(i) # skip '@'
  while s[i] in {'0'..'9', 'a'..'z', '-', '.'}: inc(i) 
  if s[i] != '\0': return false
  
  var x = substr(s, j+1)
  if len(x) == 2 and x[0] in Letters and x[1] in Letters: return true
  case toLower(x)
  of "com", "org", "net", "gov", "mil", "biz", "info", "mobi", "name",
     "aero", "jobs", "museum": return true
  return false

when isMainModule:
  assert "wuseldusel@codehome.com".validEmailAddress
  
{.pop.}

