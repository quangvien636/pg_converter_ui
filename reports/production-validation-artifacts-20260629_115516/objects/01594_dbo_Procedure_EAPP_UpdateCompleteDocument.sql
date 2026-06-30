-- ─── PROCEDURE→FUNCTION: eapp_updatecompletedocument ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.eapp_updatecompletedocument();
CREATE OR REPLACE FUNCTION public.eapp_updatecompletedocument(
) RETURNS void
AS $function$
DECLARE
    num integer;
BEGIN

 
 CREATE TEMP TABLE temp AS SELECT identity(int,1,1) as idx ,number FROM eapptempapprovalreadydoc
 

 WHILE exists(select * from temp) LOOP
   SELECT number INTO num from temp) ;
   update eappdocument set state='400' where id=num;
   update eappprogress set arrivestate='300', arrivedate=NOW(),managestate='200',managedate=NOW() 
   where documentid=num and accesstype in ('1','2');
   update eappdocument set progid=(select max(id) from eappprogress where documentid=num and accesstype in (1,2));
   DELETE FROM temp where idx = (select min(idx) from temp)	
 END LOOP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
