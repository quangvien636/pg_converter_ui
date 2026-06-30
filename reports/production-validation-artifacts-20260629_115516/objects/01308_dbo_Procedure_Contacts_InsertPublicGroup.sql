-- ─── PROCEDURE→FUNCTION: contacts_insertpublicgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_insertpublicgroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertpublicgroup(
    IN userno integer DEFAULT 70,
    IN groupname character varying DEFAULT '{"KO":"Public 001","EN":"Public 001","VN":"Public 001","CH":"Public 001","JP":"Public 001"}',
    IN parentno integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ Sort = Sort FROM Contact_PublicGroup 
	WHERE ParentNo = contacts_insertpublicgroup.parentno
	ORDER BY Sort DESC;
	INSERT INTO Contact_PublicGroup (PublicGroupName, ParentNo, RegUserNo, Sort,ModUserNo)
	VALUES (GroupName, ParentNo, UserNo, Sort+1,UserNo)
	RETURN QUERY
	SELECT CAST(lastval() AS INT) AS PublicGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
