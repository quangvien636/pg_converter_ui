-- ─── PROCEDURE→FUNCTION: board_deletefilebycontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_deletefilebycontent(bigint);
CREATE OR REPLACE FUNCTION public.board_deletefilebycontent(
    IN contentno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Board_Files WHERE ContentNo = board_deletefilebycontent.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
