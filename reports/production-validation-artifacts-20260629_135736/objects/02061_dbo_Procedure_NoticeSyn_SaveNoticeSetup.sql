-- ─── PROCEDURE→FUNCTION: noticesyn_savenoticesetup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_savenoticesetup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_savenoticesetup(
    IN userno integer,
    IN usepopup character varying,
    IN pagesize integer
) RETURNS void
AS $function$
BEGIN

	UPDATE NoticeSyn_Setup 
	UsePopup := noticesyn_savenoticesetup.usepopup,;
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
