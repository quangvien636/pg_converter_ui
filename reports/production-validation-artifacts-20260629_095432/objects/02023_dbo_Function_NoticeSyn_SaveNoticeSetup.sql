-- ─── FUNCTION: noticesyn_savenoticesetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_savenoticesetup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_savenoticesetup(
    userno integer,
    usepopup character varying,
    pagesize integer
) RETURNS void
AS $function$
BEGIN

	UPDATE NoticeSyn_Setup 
	SET 
	UsePopup=noticesyn_savenoticesetup.usepopup,
	PageSize=noticesyn_savenoticesetup.pagesize,
	EndNoticeView = EndNoticeView,
	RegUserNo=noticesyn_savenoticesetup.userno, 
	ModDate=NOW()
END;
---------------------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
