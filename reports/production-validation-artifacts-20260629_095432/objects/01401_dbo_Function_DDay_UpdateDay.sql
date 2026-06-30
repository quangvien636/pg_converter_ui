-- ─── FUNCTION: dday_updateday ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_updateday(bigint, integer, timestamp without time zone, bigint, integer, character varying, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.dday_updateday(
    dayno bigint,
    moduserno integer,
    moddate timestamp without time zone,
    groupno bigint,
    typeno integer,
    repeatoptions character varying,
    title character varying,
    content character varying,
    canhide boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_Days SET
		ModUserNo = dday_updateday.moduserno,
		ModDate = dday_updateday.moddate,
		GroupNo = dday_updateday.groupno,
		TypeNo = dday_updateday.typeno,
		RepeatOptions = dday_updateday.repeatoptions,
		Title = dday_updateday.title,
		Content = dday_updateday.content,
		CanHide = dday_updateday.canhide
	WHERE DayNo = dday_updateday.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
