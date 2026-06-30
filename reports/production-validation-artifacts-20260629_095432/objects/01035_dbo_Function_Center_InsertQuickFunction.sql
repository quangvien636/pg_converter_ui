-- ─── FUNCTION: center_insertquickfunction ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertquickfunction(integer, integer, character varying, character varying, character varying, character varying, character varying, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.center_insertquickfunction(
    userno integer,
    applicationno integer,
    functionid character varying,
    iconurl character varying,
    name character varying,
    description character varying,
    url character varying,
    ispopup boolean,
    popupwidth integer,
    popupheight integer
) RETURNS TABLE(
    functionno text
)
AS $function$
DECLARE
    functionno integer;
BEGIN


	INSERT INTO Center_QuickFunctions (UserNo, ApplicationNo, FunctionId, IconUrl, Name, Description, Url, IsPopup, PopupWidth, PopupHeight)
	VALUES (UserNo, ApplicationNo, FunctionId, IconUrl, Name, Description, Url, IsPopup, PopupWidth, PopupHeight)


	SET FunctionNo = lastval()
	
	RETURN QUERY
	SELECT FunctionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
