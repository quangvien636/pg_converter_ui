-- ─── PROCEDURE→FUNCTION: board_deletefile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_deletefile(bigint);
CREATE OR REPLACE FUNCTION public.board_deletefile(
    IN fileno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Board_Files WHERE FileNo = board_deletefile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
