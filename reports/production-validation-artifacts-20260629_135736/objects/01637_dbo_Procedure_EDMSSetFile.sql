-- ─── PROCEDURE→FUNCTION: edmssetfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmssetfile(character varying);
CREATE OR REPLACE FUNCTION public.edmssetfile(
    IN fileid character varying
) RETURNS void
AS $function$
BEGIN
		--이디엠에스테이블에 등록.;
		UPDATE	EDMSFILE
		ContentId := @IDENTITY;
		,		Length		=	Length
		WHERE	ID			=	edmssetfile.fileid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
