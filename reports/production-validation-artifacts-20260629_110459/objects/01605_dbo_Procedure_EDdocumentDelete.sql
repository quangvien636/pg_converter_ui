-- ─── PROCEDURE→FUNCTION: eddocumentdelete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.eddocumentdelete();
CREATE OR REPLACE FUNCTION public.eddocumentdelete(
) RETURNS SETOF record
AS $function$
DECLARE
    docid integer;
    versiongroup integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test

,	USERID			NVARCHAR(50)		--작성자
DocID := (44);
,	USERID			= 'Duck'
	--*/

	--문서 상태 변경.;
	UPDATE	EDMSDOCUMENT
	ISDELETE := 'Y';
	,		Modifier	= USERID
	,		ModDate		= NOW()
	WHERE	ID	=	DOCID

	--버젼그룹 중에 삭제 내역이후로 가장 최근데이터를 최상위버젼으로 등록한다.
	IF EXISTS(SELECT * FROM EDMSDOCUMENT WHERE ID = DOCID AND	VERSIONSTATE = 'Y')
	BEGIN
		--변경될 문서그룹번호 , 번호

 
		SELECT  INTO  FROM	EDMSDOCUMENT
		WHERE	ID = DOCID

		SELECT  INTO  FROM	EDMSDOCUMENT
		WHERE	WGROUP  = VERSIONGROUP
		AND		ISDELETE = ''
		AND		VERSIONSTATE = ''
		AND		DOCSTATE = 0
		ORDER BY REGDATE
	
		UPDATE	EDMSDOCUMENT
		VERSIONSTATE := 'Y';
		WHERE	ID	= VERSIONID	
	END;


RETURN QUERY
select 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
