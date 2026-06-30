-- ─── FUNCTION: edmsdocinsertfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsdocinsertfile();
CREATE OR REPLACE FUNCTION public.edmsdocinsertfile(
) RETURNS TABLE(
    col1 text,
    col2 text,
    contents text,
    contents text,
    contents text,
    contents text,
    null text,
    null text
)
AS $function$
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
