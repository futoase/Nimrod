# Nimrod PostgreSQL database wrapper
# (c) 2009 Andreas Rumpf

import strutils, postgres

type
  TDbConn* = PPGconn  ## encapsulates a database connection
  TRow* = seq[string]  ## a row of a dataset
  EDb* = object of EIO ## exception that is raised if a database error occurs
  
  TSqlQuery* = distinct string ## an SQL query string
  
proc sql*(query: string): TSqlQuery {.noSideEffect, inline.} =  
  ## constructs a TSqlQuery from the string `query`: If assertions are turned 
  ## off, it does nothing. If assertions are turned on, the string is checked
  ## for SQL security holes. This is supposed to be used as a 
  ## raw-string-literal modifier: ``sql"update user set counter = counter + 1"``
  result = TSqlQuery(query)
 
proc dbError(db: TDbConn) {.noreturn.} = 
  ## raises an EDb exception.
  var e: ref EDb
  new(e)
  e.msg = PQerrorMessage(db)
  raise e

proc dbError*(msg: string) {.noreturn.} = 
  ## raises an EDb exception with message `msg`.
  var e: ref EDb
  new(e)
  e.msg = msg
  raise e

when false:
  proc dbQueryOpt*(db: TDbConn, query: string, args: openarray[string]) =
    var stmt = mysql_stmt_init(db)
    if stmt == nil: dbError(db)
    if mysql_stmt_prepare(stmt, query, len(query)) != 0: 
      dbError(db)
    var 
      bindings: seq[MYSQL_BIND]
    discard mysql_stmt_close(stmt)

proc dbQuote(s: string): string =
  result = "'"
  for c in items(s):
    if c == '\'': add(result, "''")
    else: add(result, c)
  add(result, '\'')

proc dbFormat(formatstr: TSqlQuery, args: openarray[string]): string =
  result = ""
  var a = 0
  for c in items(string(formatstr)):
    if c == '?':
      add(result, dbQuote(args[a]))
      inc(a)
    else: 
      add(result, c)
  
proc dbTryQuery*(db: TDbConn, query: TSqlQuery, 
                 args: openarray[string]): bool =
  ## tries to execute the query and returns true if successful, false otherwise.
  var q = dbFormat(query, args)
  var res = PQExec(db, q)
  result = PQresultStatus(res) == PGRES_COMMAND_OK
  PQclear(res)

proc dbQuery*(db: TDbConn, query: TSqlQuery, args: openarray[string]) =
  ## executes the query and raises EDB if not successful.
  var q = dbFormat(query, args)
  var res = PQExec(db, q)
  if PQresultStatus(res) != PGRES_COMMAND_OK: dbError(db)
  PQclear(res)
  
proc newRow(L: int): TRow =
  newSeq(result, L)
  for i in 0..L-1: result[i] = ""
  
proc setupQuery(db: TDbConn, query: TSqlQuery, 
                args: openarray[string]): PPGresult = 
  var q = dbFormat(query, args)
  result = PQExec(db, q)
  if PQresultStatus(result) != PGRES_TUPLES_OK: dbError(db)
  
proc setRow(res: PPGresult, r: var TRow, line, cols: int) =
  for col in 0..cols-1:
    setLen(r[col], 0)
    add(r[col], PQgetvalue(res, line, cols))    
  
iterator dbFastRows*(db: TDbConn, query: TSqlQuery,
                     args: openarray[string]): TRow =
  ## executes the query and iterates over the result dataset. This is very 
  ## fast, but potenially dangerous: If the for-loop-body executes another
  ## query, the results can be undefined. For Postgres it is safe though.
  var res = setupQuery(db, query, args)
  var L = int(PQnfields(res))
  var result = newRow(L)
  for i in 0..PQntuples(res)-1:
    setRow(res, result, i, L)
    yield result
  PQclear(res)

proc dbGetAllRows*(db: TDbConn, query: TSqlQuery, 
                   args: openarray[string]): seq[TRow] =
  ## executes the query and returns the whole result dataset.
  result = @[]
  for r in dbFastRows(db, query, args):
    result.add(r)

iterator dbRows*(db: TDbConn, query: TSqlQuery, 
                 args: openarray[string]): TRow =
  ## same as `dbFastRows`, but slower and safe.
  for r in items(dbGetAllRows(db, query, args)): yield r

proc dbGetValue*(db: TDbConn, query: TSqlQuery, 
                 args: openarray[string]): string = 
  ## executes the query and returns the result dataset's the first column 
  ## of the first row. Returns "" if the dataset contains no rows. This uses
  ## `dbFastRows`, so it inherits its fragile behaviour.
  result = ""
  for row in dbFastRows(db, query, args): 
    result = row[0]
    break
  
proc dbTryInsertID*(db: TDbConn, query: TSqlQuery, 
                    args: openarray[string]): int64 =
  ## executes the query (typically "INSERT") and returns the 
  ## generated ID for the row or -1 in case of an error. For Postgre this adds
  ## ``RETURNING id`` to the query, so it only works if your primary key is
  ## named ``id``. 
  var val = dbGetValue(db, TSqlQuery(string(query) & " RETURNING id"), args)
  if val.len > 0:
    result = ParseBiggestInt(val)
  else:
    result = -1
  #if mysqlRealQuery(db, q, q.len) != 0'i32: 
  #  result = -1'i64
  #else:
  #  result = mysql_insert_id(db)
  #LAST_INSERT_ID()

proc dbInsertID*(db: TDbConn, query: TSqlQuery, 
                 args: openArray[string]): int64 = 
  ## executes the query (typically "INSERT") and returns the 
  ## generated ID for the row. For Postgre this adds
  ## ``RETURNING id`` to the query, so it only works if your primary key is
  ## named ``id``. 
  result = dbTryInsertID(db, query, args)
  if result < 0: dbError(db)
  
proc dbQueryAffectedRows*(db: TDbConn, query: TSqlQuery, 
                          args: openArray[string]): int64 = 
  ## executes the query (typically "UPDATE") and returns the
  ## number of affected rows.
  var q = dbFormat(query, args)
  var res = PQExec(db, q)
  if PQresultStatus(res) != PGRES_COMMAND_OK: dbError(db)
  result = parseBiggestInt($PQcmdTuples(res))
  PQclear(res)

proc dbClose*(db: TDbConn) = 
  ## closes the database connection.
  if db != nil: PQfinish(db)

proc dbOpen*(connection, user, password, database: string): TDbConn =
  ## opens a database connection. Returns nil in case of an error.
  result = PQsetdbLogin(nil, nil, nil, nil, database, user, password)
  if PQStatus(result) != CONNECTION_OK: dbError(result) # result = nil
