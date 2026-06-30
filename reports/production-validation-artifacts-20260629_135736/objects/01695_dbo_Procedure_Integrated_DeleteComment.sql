-- ─── PROCEDURE→FUNCTION: integrated_deletecomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.integrated_deletecomment(integer);
CREATE OR REPLACE FUNCTION public.integrated_deletecomment(
    IN commentno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Integrated_Comments WHERE CommentNo = integrated_deletecomment.commentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
