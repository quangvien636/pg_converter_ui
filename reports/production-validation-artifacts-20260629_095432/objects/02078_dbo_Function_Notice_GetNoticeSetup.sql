-- ─── FUNCTION: notice_getnoticesetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getnoticesetup(integer);
CREATE OR REPLACE FUNCTION public.notice_getnoticesetup(
    userno integer
) RETURNS TABLE(
    usepopup text,
    pagesize text,
    endnoticeview text,
    noticetreesub text,
    col5 text,
    col6 text
)
AS $function$
BEGIN

	if((select count(*) from NoticeSetup)>0) begin 
		RETURN QUERY
		SELECT UsePopup,PageSize,EndNoticeView, NoticeTreeSub, COALESCE(IsImportant,0) IsImportant, coalesce(popupType, 1) popupType FROM NoticeSetup
	end
	else begin;
		insert into NoticeSetup(UsePopup,PageSize,EndNoticeView, NoticeTreeSub,RegUserNo,ModDate) values('',20,'Y','',UserNo,NOW())
		RETURN QUERY
		SELECT UsePopup,PageSize,EndNoticeView, NoticeTreeSub, COALESCE(IsImportant,0) IsImportant, coalesce(popupType, 1) popupType FROM NoticeSetup
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
