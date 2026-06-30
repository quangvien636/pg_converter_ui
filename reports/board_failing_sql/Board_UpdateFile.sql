-- ─── PROCEDURE→FUNCTION: board_updatefile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_updatefile(bigint, bigint, character varying, bigint);
CREATE OR REPLACE FUNCTION public.board_updatefile(
    IN fileno bigint,
    IN contentno bigint,
    IN name character varying,
    IN size bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	Update Board_Files 
	SET ContentNo=board_updatefile.contentno,Name=board_updatefile.name,Size=board_updatefile.size,Url=FilePath
	WHERE FileNo=board_updatefile.fileno
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.