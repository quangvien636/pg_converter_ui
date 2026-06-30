-- ─── PROCEDURE→FUNCTION: board_updaterecommendpublic ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_updaterecommendpublic(bigint, boolean);
CREATE OR REPLACE FUNCTION public.board_updaterecommendpublic(
    IN contentno bigint,
    IN isrecommendpublic boolean
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	
	UPDATE Board_Contents SET IsRecommendPublic = board_updaterecommendpublic.isrecommendpublic  WHERE ContentNo = board_updaterecommendpublic.contentno
	SELECT ContentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.