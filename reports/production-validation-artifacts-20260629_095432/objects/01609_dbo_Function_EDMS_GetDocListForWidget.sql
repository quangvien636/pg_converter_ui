-- ─── FUNCTION: edms_getdoclistforwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getdoclistforwidget(character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.edms_getdoclistforwidget(
    userid character varying,
    top integer,
    isdelete character varying
) RETURNS TABLE(
    userid character varying(50),
    applyalllist character(1),
    authoritylevel character varying(3),
    adminflag character(1)
)
AS $function$
DECLARE
    valuedata character varying;
    authorlevel integer;
BEGIN
 



select Authorlevel =convert(int, AuthorityLevel) from EDMSUserEnv where Userid=edms_getdoclistforwidget.userid 
select ValueData= ValueData from EDMSConfiguration where KeyCode='AultAuthorityLevel'

RETURN QUERY
select top (Top)  ED.ID ,ED.Title,ED.WriterID,ED.DepartID,ED.Hit,ED.RegDate,ED.AuthorityLevel from EDMSDocument ED
where ED.IsDelete=edms_getdoclistforwidget.isdelete AND VersionState=VersionState
AND ED.AuthorityLevel IN (select * from public."EDMS_GetAultAuthorityLevelByString"(ValueData,',',':') where Authorlevel >= Authorlevel)
order by RegDate DESC,ID DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
