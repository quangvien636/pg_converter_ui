-- ─── PROCEDURE→FUNCTION: board_updateboardcontent_content ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateboardcontent_content(bigint);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_content(
    IN contentno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		Content = Content
	WHERE ContentNo = board_updateboardcontent_content.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
