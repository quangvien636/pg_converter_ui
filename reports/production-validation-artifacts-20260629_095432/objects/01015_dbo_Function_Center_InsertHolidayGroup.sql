-- ─── FUNCTION: center_insertholidaygroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertholidaygroup(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_insertholidaygroup(
    moduserno integer,
    moddate timestamp without time zone
) RETURNS TABLE(
    groupno text
)
AS $function$
DECLARE
    groupno integer;
BEGIN


	INSERT INTO Center_HolidayGroups (ModUserNo, ModDate, Title)
	VALUES (ModUserNo, ModDate, Title)
	

	SET GroupNo = lastval()
	
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
