-- ─── PROCEDURE→FUNCTION: work_updateworkgroupstate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updateworkgroupstate(integer, integer, timestamp without time zone, integer, date);
CREATE OR REPLACE FUNCTION public.work_updateworkgroupstate(
    IN groupno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN state integer,
    IN finaldate date
) RETURNS void
AS $function$
BEGIN


	IF State = 1 OR State = 4 THEN

		UPDATE WorkGroups SET
			ModUserNo = work_updateworkgroupstate.moduserno,
			ModDate = work_updateworkgroupstate.moddate,
			State = work_updateworkgroupstate.state,
			FinalDate = work_updateworkgroupstate.finaldate
		WHERE GroupNo = work_updateworkgroupstate.groupno
	
	END IF;
	
	ELSE BEGIN
	
		UPDATE WorkGroups SET
			ModUserNo = work_updateworkgroupstate.moduserno,
			ModDate = work_updateworkgroupstate.moddate,
			State = work_updateworkgroupstate.state
		WHERE GroupNo = work_updateworkgroupstate.groupno
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
