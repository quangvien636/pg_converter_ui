-- ─── FUNCTION: work_updateworkgroupstate ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateworkgroupstate(integer, integer, timestamp without time zone, integer, date);
CREATE OR REPLACE FUNCTION public.work_updateworkgroupstate(
    groupno integer,
    moduserno integer,
    moddate timestamp without time zone,
    state integer,
    finaldate date
) RETURNS void
AS $function$
BEGIN


	IF State = 1 OR State = 4 BEGIN

		UPDATE WorkGroups SET
			ModUserNo = work_updateworkgroupstate.moduserno,
			ModDate = work_updateworkgroupstate.moddate,
			State = work_updateworkgroupstate.state,
			FinalDate = work_updateworkgroupstate.finaldate
		WHERE GroupNo = work_updateworkgroupstate.groupno
	
	END
	
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
