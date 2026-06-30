-- ─── PROCEDURE→FUNCTION: contacts_getnamegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_getnamegroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getnamegroup(
    IN userno integer,
    IN groupid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo
      ,CASE WHEN STRPOS(GroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(GroupName)  WHERE NAME='KO') ELSE GroupName END AS GroupName ,GroupName
       FROM ContactsGroup WHERE GroupNo=contacts_getnamegroup.groupid AND RegUserNo=contacts_getnamegroup.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
