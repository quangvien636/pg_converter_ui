-- ─── PROCEDURE→FUNCTION: edms_getdoclistforwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_getdoclistforwidget(character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.edms_getdoclistforwidget(
    IN userid character varying,
    IN top integer,
    IN isdelete character varying
) RETURNS SETOF record
AS $function$
DECLARE
    valuedata character varying;
    authorlevel integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
 



Authorlevel := (convert(int, AuthorityLevel) from EDMSUserEnv where Userid=edms_getdoclistforwidget.userid);
SELECT ValueData INTO valuedata from EDMSConfiguration where KeyCode='AultAuthorityLevel'

RETURN QUERY
select top (Top)  ED.ID ,ED.Title,ED.WriterID,ED.DepartID,ED.Hit,ED.RegDate,ED.AuthorityLevel from EDMSDocument ED
where ED.IsDelete=edms_getdoclistforwidget.isdelete AND VersionState=VersionState
AND ED.AuthorityLevel IN (select * from public."EDMS_GetAultAuthorityLevelByString"(ValueData,',',':') where Authorlevel >= Authorlevel)
order by RegDate DESC,ID DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
