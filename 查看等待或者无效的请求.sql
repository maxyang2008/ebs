SELECT R.REQUEST_ID                     ����ID,
       FCP.User_Concurrent_Program_Name ����������,
       R.REQUESTED_BY                   ������ID,
       U.USER_NAME                      ������,
       R.REQUEST_DATE                   ����ʱ��,
       Q.USER_CONCURRENT_QUEUE_NAME     �Ŷ���
  FROM FND_CONCURRENT_REQUESTS    R,
       FND_CONCURRENT_QUEUES_TL   Q,
       FND_CONCURRENT_PROCESSES   P,
       FND_CONCURRENT_PROGRAMS_TL FCP,
       FND_USER                   U
 WHERE 1 = 1
   AND R.CONTROLLING_MANAGER = P.CONCURRENT_PROCESS_ID
   AND P.CONCURRENT_QUEUE_ID = Q.CONCURRENT_QUEUE_ID
   AND R.CONCURRENT_PROGRAM_ID = FCP.CONCURRENT_PROGRAM_ID
   AND R.REQUESTED_BY = U.USER_ID
   AND R.PHASE_CODE NOT IN ('C', 'R')
   AND Q.LANGUAGE = 'ZHS'
   AND FCP.LANGUAGE = 'ZHS'
