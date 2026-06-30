-- ─── PROCEDURE→FUNCTION: noticesyn_mobile_updatecommentnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_mobile_updatecommentnotice(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.noticesyn_mobile_updatecommentnotice(
    IN commentno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeSyn_Comments SET
		ModUserNo = noticesyn_mobile_updatecommentnotice.moduserno,
		ModDate = noticesyn_mobile_updatecommentnotice.moddate,
		Content = Content
	WHERE CommentNo = noticesyn_mobile_updatecommentnotice.commentno

END;
--------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
