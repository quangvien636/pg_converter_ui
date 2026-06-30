-- ─── FUNCTION: center_getquickfunctions ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getquickfunctions(integer);
CREATE OR REPLACE FUNCTION public.center_getquickfunctions(
    userno integer
) RETURNS TABLE(
    functionno text,
    userno text,
    applicationno text,
    functionid text,
    iconurl text,
    name text,
    description text,
    url text,
    ispopup text,
    popupwidth text,
    popupheight text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FunctionNo, UserNo, ApplicationNo, FunctionId, IconUrl, Name, Description, Url, IsPopup, PopupWidth, PopupHeight
	FROM Center_QuickFunctions
	WHERE UserNo = center_getquickfunctions.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
