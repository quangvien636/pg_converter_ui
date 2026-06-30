-- ─── PROCEDURE→FUNCTION: contacts_insertsharegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_insertsharegroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertsharegroup(
    IN userno integer DEFAULT 70,
    IN sharegroupname character varying DEFAULT '{\"KO\":\"Share 001\",\"EN\":\"Share 001\",\"VN\":\"Share 001\",\"CH\":\"Share 001\",\"JP\":\"Share 001\"}',
    IN parentno integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    sort integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort = Sort FROM Contact_ShareGroup LIMIT 1
	WHERE ParentNo = contacts_insertsharegroup.parentno
	ORDER BY Sort DESC;
	INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo,ModUserNo, Sort)
	VALUES (ShareGroupName, ParentNo, UserNo,UserNo, Sort+1);
	RETURN QUERY
	SELECT CAST(lastval() AS INT) ShareGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.