-- ─── PROCEDURE→FUNCTION: notice_savenoticesetup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_savenoticesetup(integer, character varying, integer, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_savenoticesetup(
    IN userno integer,
    IN usepopup character varying,
    IN pagesize integer,
    IN endnoticeview character varying,
    IN noticetreesub character varying,
    IN p_i integer,
    IN p_t integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	UPDATE NoticeSetup 
	UsePopup := notice_savenoticesetup.usepopup,;
	PageSize=notice_savenoticesetup.pagesize,
	EndNoticeView = notice_savenoticesetup.endnoticeview,
	NoticeTreeSub = notice_savenoticesetup.noticetreesub,
	RegUserNo = notice_savenoticesetup.userno, 
	ModDate=NOW(),
	IsImportant = notice_savenoticesetup.p_i,
	popupType = notice_savenoticesetup.p_t;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
