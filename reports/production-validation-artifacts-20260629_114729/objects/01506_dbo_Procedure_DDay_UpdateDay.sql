-- ─── PROCEDURE→FUNCTION: dday_updateday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_updateday(bigint, integer, timestamp without time zone, bigint, integer, character varying, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.dday_updateday(
    IN dayno bigint,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN groupno bigint,
    IN typeno integer,
    IN repeatoptions character varying,
    IN title character varying,
    IN content character varying,
    IN canhide boolean
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
