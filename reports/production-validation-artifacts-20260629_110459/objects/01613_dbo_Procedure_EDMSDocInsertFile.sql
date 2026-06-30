-- ─── PROCEDURE→FUNCTION: edmsdocinsertfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmsdocinsertfile();
CREATE OR REPLACE FUNCTION public.edmsdocinsertfile(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    /***************************************************************************
	-- 첨부 파일 테이블 인서트
	ATTACHNAME = 
	,		ATTACHFLAG = '.txt;.txt;.sql;'
	***************************************************************************/   	 
	IF(ATTACHPATH <> '')
	BEGIN;
		INSERT INTO EDMSFILE	
		RETURN QUERY
		SELECT	EDMSDOCID
		,		case when D.CONTENTS IS null then ATTACHPATH else D.CONTENTS end as CONTENTS
		,		A.CONTENTS
		,		B.CONTENTS
		,		C.ConTenTs
		,		null
		,		null
		FROM
		EDMSSplitTable(ATTACHNAME,';') A
		INNER JOIN		
		EDMSSplitTable(ATTACHFLAG,';') B
		ON A.ID = B.ID	
		INNER JOIN		
		EDMSSplitTable(IsPDF,';') C
		ON A.ID = C.ID	
		left outer join 
		EDMSSplitTable(ATTACHPATH,';') D
		ON A.ID = D.ID	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
