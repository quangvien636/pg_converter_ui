-- ─── FUNCTION: noticesyn_getnoticesetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getnoticesetup();
CREATE OR REPLACE FUNCTION public.noticesyn_getnoticesetup(
) RETURNS TABLE(
    usepopup text,
    pagesize text,
    endnoticeview text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT UsePopup,PageSize,EndNoticeView FROM NoticeSyn_Setup
END;

------------------------------------------------
--- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
