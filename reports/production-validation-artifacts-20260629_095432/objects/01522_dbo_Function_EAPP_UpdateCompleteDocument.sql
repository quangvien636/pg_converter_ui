-- ─── FUNCTION: eapp_updatecompletedocument ───────────────────────────────
DROP FUNCTION IF EXISTS public.eapp_updatecompletedocument();
CREATE OR REPLACE FUNCTION public.eapp_updatecompletedocument(
) RETURNS void
AS $function$
DECLARE
    num integer;
BEGIN

 
 select identity(int,1,1) as idx ,number
 into #temp
 from eapptempapprovalreadydoc
 

 while exists(select * from #temp)
 begin   
   SELECT num=number FROM #temp WHERE IDX = (select min(idx) from #temp) ;
   update eappdocument set state='400' where id=num;
   update eappprogress set arrivestate='300', arrivedate=NOW(),managestate='200',managedate=NOW() 
   where documentid=num and accesstype in ('1','2');
   update eappdocument set progid=(select max(id) from eappprogress where documentid=num and accesstype in (1,2))
   delete #temp where idx = (select min(idx) from #temp)	
 END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
