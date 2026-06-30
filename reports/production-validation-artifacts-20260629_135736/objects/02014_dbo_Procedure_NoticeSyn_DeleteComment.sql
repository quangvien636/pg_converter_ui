-- ─── PROCEDURE→FUNCTION: noticesyn_deletecomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_deletecomment(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_deletecomment(
    IN commentno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeSyn_Comments WHERE CommentNo = noticesyn_deletecomment.commentno
END;
-------------------------///////////////////////////---------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
