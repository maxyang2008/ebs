-- 查看并发管理器状态
SELECT t.user_concurrent_queue_name AS "MANAGER_NAME",
       b.max_processes              AS "MAX_PROCESS",
       b.running_processes          AS "RUNNING_PROCESS",
       b.concurrent_queue_name      AS "QUEUE_NAME",
       b.cache_size                 AS "CACHE_SIZE",
       b.min_processes,
       b.target_processes,
       b.target_node,
       b.sleep_seconds
  FROM fnd_concurrent_queues_tl t, fnd_concurrent_queues b
 WHERE b.application_id = t.application_id
   AND b.concurrent_queue_id = t.concurrent_queue_id
   AND b.enabled_flag = 'Y'
   AND t.LANGUAGE = 'ZHS'
   ORDER BY b.max_processes DESC;



