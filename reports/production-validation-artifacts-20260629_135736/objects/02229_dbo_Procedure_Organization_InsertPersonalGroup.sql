-- ─── PROCEDURE→FUNCTION: organization_insertpersonalgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertpersonalgroup(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_insertpersonalgroup(
    IN userno integer,
    IN moddate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    groupno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	UPDATE Organization_PersonalGroups SET SortNo = SortNo + 1
	WHERE UserNo = organization_insertpersonalgroup.userno

	INSERT INTO Organization_PersonalGroups (UserNo, ModDate, Name, SortNo, ListOfUsers)
	VALUES (UserNo, ModDate, Name, 1, '')


	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
