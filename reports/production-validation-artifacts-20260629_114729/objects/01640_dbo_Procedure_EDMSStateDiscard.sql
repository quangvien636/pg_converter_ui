-- ─── PROCEDURE→FUNCTION: edmsstatediscard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.edmsstatediscard(character varying);
CREATE OR REPLACE FUNCTION public.edmsstatediscard(
    IN userid character varying
) RETURNS SETOF record
AS $function$
DECLARE
    docid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*

,	USERID		nvarchar(50)
DOCID := (45);
,		USERID		=	'ADMIN'
--*/
		--폐기상태로;
		UPDATE	EDMSDOCUMENT
		ISDELETE := '';
		,		MODDATE		= NOW()
		,		Modifier	= edmsstatediscard.userid
		,		valdate		= dateadd(day,-1,NOW())		
		WHERE	ID = DOCID	

		RETURN QUERY
		SELECT DOCID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
