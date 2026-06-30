-- ─── PROCEDURE→FUNCTION: contacts_insertgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_insertgroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertgroup(
    IN userno integer,
    IN grpname character varying,
    IN parentno integer
) RETURNS SETOF record
AS $function$
DECLARE
    sort integer;
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort = Sort FROM ContactsGroup LIMIT 1
	WHERE RegUserNo = contacts_insertgroup.userno AND ParentGNo = contacts_insertgroup.parentno
	ORDER BY Sort DESC;

	INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn)
	VALUES (GrpName, ParentNo, UserNo, Sort+1,NOW(),'0','Y');

	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo AS GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.