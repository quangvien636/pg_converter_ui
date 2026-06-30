-- ─── PROCEDURE→FUNCTION: board_updateboardcustorm ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateboardcustorm(integer, integer);
CREATE OR REPLACE FUNCTION public.board_updateboardcustorm(
    IN boardno integer DEFAULT 49,
    IN boardtype integer DEFAULT 23
) RETURNS void
AS $function$
BEGIN

		UPDATE Board_Boards SET ViewMode=board_updateboardcustorm.boardtype WHERE BoardNo=board_updateboardcustorm.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
