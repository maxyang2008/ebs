-- ref: How to Monitor the FNDWFBG Workflow Background Program? (文档 ID 369537.1)	

-- 1. Show what is exactly on the Background Process Deferred Queue ready for processing
select w.user_data.itemtype "Item Type",
       w.user_data.itemkey "Item Key",
       decode(w.state,
              0,
              '0 = Ready',
              1,
              '1 = Delayed',
              2,
              '2 = Retained',
              3,
              '3 = Exception',
              to_char(w.state)) State,
       w.priority,
       w.ENQ_TIME,
       w.DEQ_TIME,
       w.msgid
  from wf_deferred_table_m w
 where w.user_data.itemtype = '&item_type';


-- 2. Monitor the Queue by Item Type ie APPS<itemtype>
select corrid, user_data user_data
  from wf_deferred_table_m
 where state = 0
   and corrid = '&Corrid'
 order by priority, enq_time;



-- 3. Monitor the Deferred Queue to see exactly what's coming off next

SELECT wfdtm.corrid,
       wfdtm.user_data.ITEMTYPE ITEM_TYPE,
       wfdtm.user_data.ITEMKEY ITEM_KEY,
       wfdtm.enq_time,
       DECODE(wfdtm.state,
              0,
              '0 = Ready',
              1,
              '1 = Delayed',
              2,
              '2 = Retained',
              3,
              '3 = Exception',
              TO_CHAR(SUBSTR(wfdtm.state, 1, 12))) State
  FROM wf_deferred_table_m wfdtm
 WHERE wfdtm.state = 0
 ORDER BY wfdtm.priority, wfdtm.enq_time;



-- 4. Show what frequency the FNDWFBG request is going to be resubmitted and its parameters:
select r.REQUEST_ID,
       r.REQUESTED_BY,
       r.PHASE_CODE,
       p.USER_CONCURRENT_PROGRAM_NAME,
       r.ARGUMENT_TEXT "Arguments",
       Nvl(Substr(R.Argument_Text, 0, Instr(R.Argument_Text, ',') - 1),
           'All Items') Item_Type,
       Substr(R.Argument_Text,
              Instr(R.Argument_Text, ',') + 1,
              Instr(R.Argument_Text, ',', 1, 2) -
              Instr(R.Argument_Text, ',') - 1) Min_Threshold,
       Substr(R.Argument_Text,
              Instr(R.Argument_Text, ',', 1, 2) + 1,
              (Instr(R.Argument_Text, ',', 1, 3) - 1) -
              (Instr(R.Argument_Text, ',', 1, 2))) Max_Threshold,
       Substr(R.Argument_Text,
              Instr(R.Argument_Text, ',', 1, 3) + 1,
              (Instr(R.Argument_Text, ',', 1, 4) - 1) -
              (Instr(R.Argument_Text, ',', 1, 3))) Deferred,
       substr(r.ARGUMENT_TEXT,
              instr(r.ARGUMENT_TEXT, ',', 1, 4) + 1,
              (instr(r.ARGUMENT_TEXT, ',', 1, 5) - 1) -
              (instr(r.ARGUMENT_TEXT, ',', 1, 4))) TIMEOUT,
       substr(r.ARGUMENT_TEXT, instr(r.ARGUMENT_TEXT, ',', 1, 5) + 1) STUCK,
       r.RESUBMIT_INTERVAL EVERY,
       r.RESUBMIT_INTERVAL_UNIT_CODE SO_OFTEN,
       r.RESUBMIT_END_DATE
  FROM fnd_concurrent_requests r, FND_CONCURRENT_PROGRAMS_TL p
 WHERE r.CONCURRENT_PROGRAM_ID = p.CONCURRENT_PROGRAM_ID
   and p.USER_CONCURRENT_PROGRAM_NAME LIKE 'Workflow%Background%'
   AND p.LANGUAGE = 'US'
   and r.ACTUAL_COMPLETION_DATE is null
   and r.PHASE_CODE in ('P', 'R');
