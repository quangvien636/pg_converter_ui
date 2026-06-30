-- ─── PROCEDURE→FUNCTION: dday_insertday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_insertday(integer, integer, timestamp without time zone, bigint, integer, character varying, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.dday_insertday(
    IN reguserno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN groupno bigint,
    IN typeno integer,
    IN repeatoptions character varying,
    IN title character varying,
    IN content character varying,
    IN canhide boolean
) RETURNS SETOF record
AS $function$
DECLARE
    dayno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO DDay_Days (RegUserNo, ModUserNo, ModDate, GroupNo, TypeNo,
		RepeatOptions, Title, Content, CanHide)
	VALUES (RegUserNo, ModUserNo, ModDate, GroupNo, TypeNo,
		RepeatOptions, Title, Content, CanHide)


	DayNo := COALESCE(lastval(), 0);
	RETURN QUERY
	SELECT DayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
