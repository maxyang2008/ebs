SELECT t.program_short_name,
       f.responsibility_name,
       p.user_concurrent_program_name,
       t.REQUESTED_START_DATE,
       t.ARGUMENT_TEXT,
       t.REQUESTED_BY,
       u.user_name
  FROM fnd_conc_req_summary_v     t,
       fnd_responsibility_tl      f,
       fnd_concurrent_programs_tl p,
       fnd_user                   u
 WHERE f.responsibility_id = t.responsibility_id
   and u.user_id = t.REQUESTED_BY
   AND f.language = 'ZHS'
   AND t.phase_code = 'P'
   AND p.concurrent_program_id = t.concurrent_program_id
   AND p.language = 'ZHS'
   AND t.status_code IN ('I',
                       'Q');


SELECT fcp.concurrent_program_name,
       decode(fcre.description,
              NULL,
              fcpt.user_concurrent_program_name,
              fcre.description || ' (' || fcpt.user_concurrent_program_name || ')'),
       fu.user_name,
       conc.request_id,
       conc.root_request_id,
       decode(fcre.status_code,
              'D',
              'Cancelled',
              'U',
              'Disabled',
              'E',
              'Error',
              'M',
              'No Manager',
              'R',
              'Normal',
              'H',
              'On Hold',
              'W',
              'Paused',
              'B',
              'Resuming',
              'I',
              'Scheduled',
              'Q',
              'Standby',
              'S',
              'Suspended',
              'X',
              'Terminated',
              'T',
              'Terminating',
              'A',
              'Waiting',
              'G',
              'Warning') status,
       
       fcre.requested_start_date   last_start_date,
       fcre.actual_start_date      last_actual_start_date,
       fcre.actual_completion_date last_completion_date,
       fcre.argument_text,
       sche.start_date,
       sche.end_date,
       sche.job_class,
       sche.class_info

  FROM apps.fnd_concurrent_programs fcp,
       apps.fnd_concurrent_programs_tl fcpt,
       apps.fnd_concurrent_requests fcre,
       apps.fnd_user fu,
       (SELECT owner_req_id,
               date1 start_date,
               date2 end_date,
               decode(class_type, 'S', 'Specific Days', 'P', 'Periodically') job_class,
               decode(class_type,
                      'P',
                      substr(class_info, 1, instr(class_info, ':') - 1) ||
                      decode(substr(class_info, instr(class_info, ':') + 1, 1),
                             'D',
                             'Days',
                             'H',
                             'Hours',
                             'N',
                             'Minutes',
                             'M',
                             'Months',
                             'W',
                             'Weeks'),
                      'S',
                      class_info) class_info
          FROM apps.fnd_conc_release_classes fcr
        
         WHERE class_type IN ('S', 'P') --Periodically and Specific Concurrent
           AND enabled_flag = 'Y'
           AND (date2 IS NULL OR date2 > SYSDATE)
           AND owner_req_id IS NOT NULL) sche,
       
       (SELECT MAX(request_id) request_id, root_request_id
          FROM apps.fnd_concurrent_requests
         WHERE root_request_id IN
               (SELECT nvl(root_request_id, request_id) request_id
                  FROM apps.fnd_concurrent_requests
                 WHERE request_id IN
                       (SELECT owner_req_id
                          FROM apps.fnd_conc_release_classes fcr
                         WHERE class_type IN ('S', 'P') --Periodically and Specific Concurrent
                           AND enabled_flag = 'Y'
                           AND (date2 IS NULL OR date2 > SYSDATE)
                           AND owner_req_id IS NOT NULL)
                   AND status_code <> 'D')
         GROUP BY root_request_id) conc

 WHERE fcp.concurrent_program_id = fcpt.concurrent_program_id
   AND fcpt.language = 'ZHS'
   AND sche.job_class = 'Periodically'
   AND fcp.concurrent_program_id = fcre.concurrent_program_id
   AND fcre.status_code NOT IN ('D', 'X', 'U') --Cancelled and Terminated and Disabled
   AND fcre.request_id = conc.request_id
   AND conc.request_id = sche.owner_req_id
   AND fcre.requested_by = fu.user_id
;
