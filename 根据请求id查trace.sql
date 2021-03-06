SELECT 'Request id: ' || Request_Id,
       'Trace id: ' || Oracle_Process_Id,
       'Trace Flag: ' || Req.Enable_Trace,
       'Trace Name:' || Dest.Value || '/' || Lower(Dbnm.Value) || '_ora_' ||
       Oracle_Process_Id || '.trc',
       'Prog. Name: ' || Prog.User_Concurrent_Program_Name,
       'File Name: ' || Execname.Execution_File_Name ||
       Execname.Subroutine_Name,
       'Status : ' || Decode(Phase_Code, 'R', 'Running') || '-' ||
       Decode(Status_Code, 'R', 'Normal'),
       'SID Serial: ' || Ses.Sid || ',' || Ses.Serial#,
       'Module : ' || Ses.Module
  FROM Fnd_Concurrent_Requests    Req,
       V$session                  Ses,
       V$process                  Proc,
       V$parameter                Dest,
       V$parameter                Dbnm,
       Fnd_Concurrent_Programs_Vl Prog,
       Fnd_Executables            Execname
 WHERE Req.Request_Id = 89076411 -- 10373892 --10373057
   AND Req.Oracle_Process_Id = Proc.Spid(+)
   AND Proc.Addr = Ses.Paddr(+)
   AND Dest.Name = 'user_dump_dest'
   AND Dbnm.Name = 'db_name'
   AND Req.Concurrent_Program_Id = Prog.Concurrent_Program_Id
   AND Req.Program_Application_Id = Prog.Application_Id
   AND Prog.Application_Id = Execname.Application_Id
   AND Prog.Executable_Id = Execname.Executable_Id;
