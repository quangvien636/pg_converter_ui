-- ─── PROCEDURE→FUNCTION: organization_insertcommongroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertcommongroup(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_insertcommongroup(
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    groupno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	UPDATE Organization_CommonGroups SET SortNo = SortNo + 1

	INSERT INTO Organization_CommonGroups (ModUserNo, ModDate, Name, SortNo, ListOfUsers)
	VALUES (ModUserNo, ModDate, Name, 1, '')


	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
