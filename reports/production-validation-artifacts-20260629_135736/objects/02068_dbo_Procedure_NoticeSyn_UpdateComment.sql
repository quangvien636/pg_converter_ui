-- ─── PROCEDURE→FUNCTION: noticesyn_updatecomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_updatecomment(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updatecomment(
    IN commentno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeSyn_Comments 
	Content := Content, ModDate = NOW();
	WHERE CommentNo = noticesyn_updatecomment.commentno
	
END;
----------------------------------/////////////
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
