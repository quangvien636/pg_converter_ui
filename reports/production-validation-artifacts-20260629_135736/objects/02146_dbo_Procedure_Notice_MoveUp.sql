-- ─── PROCEDURE→FUNCTION: notice_moveup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_moveup(integer);
CREATE OR REPLACE FUNCTION public.notice_moveup(
    IN p_fno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	With cte As
	(
		SELECT AttachNo,Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, AttachNo ASC) AS RN
		FROM NoticeAttachments where NoticeNo = parentid 
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE NoticeAttachments set Sort = Sort - 1.01 Where AttachNo =  notice_moveup.p_fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
