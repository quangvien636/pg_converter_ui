-- ─── FUNCTION: schedule_insertddaygroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertddaygroup(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_insertddaygroup(
    reguserno integer,
    regdate timestamp without time zone
) RETURNS TABLE(
    groupno text
)
AS $function$
DECLARE
    groupno integer;
BEGIN


	INSERT INTO ScheduleDdayGroups(RegUserNo, RegDate, ModUserNo, ModDate, Name)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate, Name)
		

	SET GroupNo = lastval()
	
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
