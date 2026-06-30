-- ─── PROCEDURE→FUNCTION: board_updateboardcontent_viewed ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateboardcontent_viewed(bigint);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_viewed(
    IN contentno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ViewedCount = ViewedCount + 1
	WHERE ContentNo = board_updateboardcontent_viewed.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
