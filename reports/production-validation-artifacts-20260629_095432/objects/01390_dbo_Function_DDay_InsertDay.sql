-- ─── FUNCTION: dday_insertday ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertday(integer, integer, timestamp without time zone, bigint, integer, character varying, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.dday_insertday(
    reguserno integer,
    moduserno integer,
    moddate timestamp without time zone,
    groupno bigint,
    typeno integer,
    repeatoptions character varying,
    title character varying,
    content character varying,
    canhide boolean
) RETURNS TABLE(
    dayno text
)
AS $function$
DECLARE
    dayno bigint;
BEGIN


	INSERT INTO DDay_Days (RegUserNo, ModUserNo, ModDate, GroupNo, TypeNo,
		RepeatOptions, Title, Content, CanHide)
	VALUES (RegUserNo, ModUserNo, ModDate, GroupNo, TypeNo,
		RepeatOptions, Title, Content, CanHide)


	SET DayNo = COALESCE(lastval(), 0)

	RETURN QUERY
	SELECT DayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
