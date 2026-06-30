-- ─── PROCEDURE→FUNCTION: organization_insertduty ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertduty(integer, timestamp without time zone, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.organization_insertduty(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN name_en character varying,
    IN name_ch character varying,
    IN name_jp character varying
) RETURNS SETOF record
AS $function$
DECLARE
    sortno integer;
    dutyno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SortNo := (SELECT MAX(SortNo) FROM Organization_Positions);
	IF SortNo IS NULL THEN
	
		SortNo := 1;
	END IF;
	
	ELSE BEGIN
	
		SortNo := SortNo + 1;
	END;
	
	INSERT INTO Organization_Duties (ModUserNo, ModDate, Name, Name_EN, SortNo, Enabled,Name_CH,Name_JP,Name_VN)
	VALUES (ModUserNo, ModDate, Name, Name_EN, SortNo, 1,Name_CH,Name_JP,Name_VN)
	

	DutyNo := lastval();
	RETURN QUERY
	SELECT DutyNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
