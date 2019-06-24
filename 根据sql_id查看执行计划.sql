-- 3v8dxbtc2nc2x
select * from table(dbms_xplan.display_cursor('9y3pzz466anvn',null,'ADVANCED ALLSTATS LAST PEEKED_BINDS'));
select * from table(dbms_xplan.display_awr('9y3pzz466anvn',null,null,'ADVANCED +PEEKED_BINDS'));


SELECT * FROM GV$SQLAREA S WHERE S.SQL_ID = 'fbq0x235bh21r';
