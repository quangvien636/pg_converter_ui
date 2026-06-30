-- ─── PROCEDURE→FUNCTION: notice_getnoticesetup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getnoticesetup(integer);
CREATE OR REPLACE FUNCTION public.notice_getnoticesetup(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	if((select count(*) from NoticeSetup)>0) begin 
		RETURN QUERY
		SELECT UsePopup,PageSize,EndNoticeView, NoticeTreeSub, COALESCE(IsImportant,0) IsImportant, coalesce(popupType, 1) popupType FROM NoticeSetup
	END;
	else begin;
		insert into NoticeSetup(UsePopup,PageSize,EndNoticeView, NoticeTreeSub,RegUserNo,ModDate) values('',20,'Y','',UserNo,NOW())
		RETURN QUERY
		SELECT UsePopup,PageSize,EndNoticeView, NoticeTreeSub, COALESCE(IsImportant,0) IsImportant, coalesce(popupType, 1) popupType FROM NoticeSetup
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
