-- ─── PROCEDURE→FUNCTION: board_updateboardcontent_isnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateboardcontent_isnotice(bigint, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_isnotice(
    IN contentno bigint,
    IN moddate timestamp without time zone,
    IN isnotice boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_isnotice.moddate,
		IsNotice = board_updateboardcontent_isnotice.isnotice
	WHERE ContentNo = board_updateboardcontent_isnotice.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
