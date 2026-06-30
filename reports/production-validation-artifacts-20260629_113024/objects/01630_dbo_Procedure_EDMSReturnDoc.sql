-- ─── PROCEDURE→FUNCTION: edmsreturndoc ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmsreturndoc(character varying);
CREATE OR REPLACE FUNCTION public.edmsreturndoc(
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
		
		--최신버전으로 셋팅하기위한 액숀.		;
		UPDATE	EDMSDOCUMENT
		VERSIONSTATE := '';
		WHERE	WGROUP =(
							SELECT WGROUP  FROM EDMSDOCUMENT WHERE	ID = DOCID
						)

		--복원;
		UPDATE	EDMSDOCUMENT
		ISDELETE := '';
		,		MODDATE = NOW()
		,		Modifier = edmsreturndoc.userid
		,		VersionState = 'Y'
		WHERE	ID = DOCID	

		RETURN QUERY
		SELECT DOCID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
