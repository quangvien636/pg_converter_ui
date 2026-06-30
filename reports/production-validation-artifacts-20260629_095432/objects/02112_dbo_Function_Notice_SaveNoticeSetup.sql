-- ─── FUNCTION: notice_savenoticesetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_savenoticesetup(integer, character varying, integer, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_savenoticesetup(
    userno integer,
    usepopup character varying,
    pagesize integer,
    endnoticeview character varying,
    noticetreesub character varying,
    p_i integer,
    p_t integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	UPDATE NoticeSetup 
	SET 
	UsePopup=notice_savenoticesetup.usepopup,
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
