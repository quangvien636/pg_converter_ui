-- ─── PROCEDURE→FUNCTION: crewchat_insertattachfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_insertattachfile(character varying, character varying, integer, bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertattachfile(
    IN filename character varying,
    IN fullpath character varying,
    IN type integer,
    IN size bigint,
    IN thumbwidth integer,
    IN thumbheight integer
) RETURNS SETOF record
AS $function$
DECLARE
    attachno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO CrewChat_Attach (FileName, FullPath, Type, Size, ThumbWidth, ThumbHeight)
	VALUES (FileName, FullPath, Type, Size, ThumbWidth, ThumbHeight)
	
	AttachNo := lastval();
	RETURN QUERY
	SELECT AttachNo, FileName, FullPath, Type, Size, ThumbWidth, ThumbHeight  FROM CrewChat_Attach
	WHERE AttachNo = AttachNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
