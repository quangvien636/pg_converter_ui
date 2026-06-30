-- ─── PROCEDURE→FUNCTION: dday_insertgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_insertgroup(integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.dday_insertgroup(
    IN userno integer,
    IN moddate timestamp without time zone,
    IN tagno integer
) RETURNS SETOF record
AS $function$
DECLARE
    sortno integer;
    groupno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SortNo := (SELECT COALESCE(MAX(SortNo), 0) + 1 FROM DDay_Groups WHERE UserNo = dday_insertgroup.userno);;
	INSERT INTO DDay_Groups VALUES (UserNo, ModDate, TagNo, Name, SortNo)


	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
