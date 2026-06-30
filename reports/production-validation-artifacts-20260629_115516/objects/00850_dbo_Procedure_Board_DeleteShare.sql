-- ─── PROCEDURE→FUNCTION: board_deleteshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_deleteshare(integer);
CREATE OR REPLACE FUNCTION public.board_deleteshare(
    IN contentno integer
) RETURNS void
AS $function$
BEGIN

DELETE FROM Board_Sharers WHERE ContentNo = board_deleteshare.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
