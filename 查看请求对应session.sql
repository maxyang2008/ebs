SELECT DISTINCT c.USER_CONCURRENT_PROGRAM_NAME,
                round(((sysdate - a.actual_start_date) * 24 * 60 * 60 / 60),
                      2) AS Process_time,
                a.request_id,
                a.ORACLE_PROCESS_ID,
                e.INST_ID,
                e.SID,
                e.SQL_ID,
                e.SERIAL#,
                e.BLOCKING_INSTANCE,
                e.BLOCKING_SESSION,
                e.EVENT,
                e.STATE,
                a.parent_request_id,
                a.request_date,
                a.actual_start_date,
                a.actual_completion_date,
                (a.actual_completion_date - a.request_date) * 24 * 60 * 60 AS end_to_end,
                (a.actual_start_date - a.request_date) * 24 * 60 * 60 AS lag_time,
                d.user_name,
                a.phase_code,
                a.status_code,
                a.argument_text,
                a.priority
  FROM apps.fnd_concurrent_requests    a,
       apps.fnd_concurrent_programs    b,
       apps.FND_CONCURRENT_PROGRAMS_TL c,
       apps.fnd_user                   d,
       gv$session                      e
 WHERE a.concurrent_program_id = b.concurrent_program_id
   and e.AUDSID = a.ORACLE_SESSION_ID
   AND b.concurrent_program_id = c.concurrent_program_id
   AND a.requested_by = d.user_id
   AND c.language = 'ZHS'
   AND status_code = 'R'
--   AND a.request_id = 90220213
--   and c.USER_CONCURRENT_PROGRAM_NAME like 'CRC_B29_OE_创建销售订单子程序'
order by Process_time desc;
