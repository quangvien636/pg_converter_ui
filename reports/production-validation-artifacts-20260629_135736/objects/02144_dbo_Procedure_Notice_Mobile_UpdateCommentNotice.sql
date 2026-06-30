-- ─── PROCEDURE→FUNCTION: notice_mobile_updatecommentnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_mobile_updatecommentnotice(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.notice_mobile_updatecommentnotice(
    IN commentno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeComments SET
		ModUserNo = notice_mobile_updatecommentnotice.moduserno,
		ModDate = notice_mobile_updatecommentnotice.moddate,
		Content = Content
	WHERE CommentNo = notice_mobile_updatecommentnotice.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
