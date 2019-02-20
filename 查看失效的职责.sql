select RESPONSIBILITY_NAME
  from FND_RESPONSIBILITY_TL T
 where (T.application_id, T.responsibility_id) in
       (select APPLICATION_ID, RESPONSIBILITY_ID
          from FND_RESPONSIBILITY R
         where (R.application_id, R.responsibility_id) in
               (select RESPONSIBILITY_APPLICATION_ID, RESPONSIBILITY_ID
                  from fnd_concurrent_requests fcr
                 where fcr.PHASE_CODE <> 'C')
           AND (R.END_DATE is NULL OR R.END_DATE > sysdate)
           AND (R.START_DATE < sysdate));
