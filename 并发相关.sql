-- 工作流后台进程，是不是数据库长连接
-- 通过logon_time换算
-- 结论是：并发进程的数据库连接是长连接
select *
  from gv$session s
 where s.USERNAME = 'APPS'
   and s.PROCESS =
       (select p.os_process_id
          from fnd_concurrent_processes p, fnd_concurrent_queues q
         where p.concurrent_queue_id = q.concurrent_queue_id
           and q.concurrent_queue_name = 'WFALSNRSVC'
           and p.process_status_code = 'A')
