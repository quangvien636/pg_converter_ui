-- ─── PROCEDURE→FUNCTION: contact_insertsharegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contact_insertsharegroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contact_insertsharegroup(
    IN userno integer,
    IN sharename character varying,
    IN parentno integer
) RETURNS SETOF record
AS $function$
DECLARE
    sort integer;
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort = Sort FROM Contact_ShareGroup LIMIT 1
	WHERE  ParentNo = contact_insertsharegroup.parentno
	ORDER BY Sort DESC;

	INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo, Sort,RegDate,IsDelete)
	VALUES (ShareName, ParentNo, UserNo, Sort+1,NOW(),'FALSE');

	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo AS GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.