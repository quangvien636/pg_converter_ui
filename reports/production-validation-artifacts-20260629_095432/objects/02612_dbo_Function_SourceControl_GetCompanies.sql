-- ─── FUNCTION: sourcecontrol_getcompanies ───────────────────────────────
DROP FUNCTION IF EXISTS public.sourcecontrol_getcompanies();
CREATE OR REPLACE FUNCTION public.sourcecontrol_getcompanies(
) RETURNS TABLE(
    id text,
    companyname text,
    companycode text,
    website text,
    ipaddress text,
    col6 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH TotalCount AS ( SELECT COUNT(*) AS Total FROM SourceControl_Company WHERE DISABLE=0)
	RETURN QUERY
	SELECT SC.Id,SC.Name AS CompanyName,SC.Code AS CompanyCode,SC.Website,SC.IpAddress,(SELECT /* /* TOP 1 */ */Total FROM TotalCount) AS TotalCount
	FROM SourceControl_Company SC
	 WHERE SC.DISABLE=0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
