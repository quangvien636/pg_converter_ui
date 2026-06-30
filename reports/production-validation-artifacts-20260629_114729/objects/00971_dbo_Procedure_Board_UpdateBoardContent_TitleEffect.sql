-- ─── PROCEDURE→FUNCTION: board_updateboardcontent_titleeffect ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateboardcontent_titleeffect(bigint, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_titleeffect(
    IN contentno bigint,
    IN moddate timestamp without time zone,
    IN titleeffect integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_titleeffect.moddate,
		TitleEffect = board_updateboardcontent_titleeffect.titleeffect
	WHERE ContentNo = board_updateboardcontent_titleeffect.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
