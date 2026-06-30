-- ─── FUNCTION: wfaxgetfaxboxtopcd ───────────────────────────────
DROP FUNCTION IF EXISTS public.wfaxgetfaxboxtopcd();
CREATE OR REPLACE FUNCTION public.wfaxgetfaxboxtopcd(
) RETURNS character varying
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    topcd character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SET TopCd = COALESCE((SELECT /* TOP 1 */ FaxBoxCd FROM  public."WFAXGetFaxBoxParent"(FaxBoxCd) ORDER BY Level), '')


	RETURN	(TopCd);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
