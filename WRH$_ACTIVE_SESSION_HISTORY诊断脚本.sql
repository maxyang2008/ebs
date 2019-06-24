SELECT retention FROM dba_hist_wr_control;

SELECT * FROM V$SYSAUX_OCCUPANTS;

SQL> @$ORACLE_HOME/rdbms/admin/awrinfo.sql 

-- check for orphaned ASH rows
SELECT COUNT(1) ORPHANED_ASH_ROWS
  FROM SYS.WRH$_ACTIVE_SESSION_HISTORY A
 WHERE NOT EXISTS (SELECT 1
          FROM SYS.WRM$_SNAPSHOT
         WHERE SNAP_ID = A.SNAP_ID
           AND DBID = A.DBID
           AND INSTANCE_NUMBER = A.INSTANCE_NUMBER);
