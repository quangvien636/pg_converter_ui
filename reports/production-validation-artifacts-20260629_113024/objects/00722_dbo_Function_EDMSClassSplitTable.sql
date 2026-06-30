-- ─── FUNCTION: edmsclasssplittable ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsclasssplittable();
CREATE OR REPLACE FUNCTION public.edmsclasssplittable(
) RETURNS TABLE(
    id integer,
    contents character varying,
    divid character varying,
    orgflag character varying
)
-- TODO: LEN was not fully converted; use length()
AS $function$
#variable_conflict use_column
DECLARE
    splitcontent character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
-- classflag  select * from public."EDMSClassSplitTable"('1:111;1:222;1:333;2:444;2:555;2:666',';')

BEGIN 


	,		SUBLEN			INT				--FALG로 찾아낸 문자의 길이
	,		ORGCODE		CHAR(1)			--SPLITCONTENT 가 부서일지 유저일지를 판단한다. '1' : 부서 , '0' : 유져
	,		IDENTITY		INT				--리턴테이블에 키가되어줄 필드.
	,		DivID			varchar(10)

	SET	IDENTITY = 0

	IF(SUBSTRING(Content,LEN(Content),1) <> Flag)
	BEGIN
		SELECT Content = Content + Flag
	END		
	
	WHILE STRPOS(Content, Flag) > 0
	BEGIN
	
		SELECT IDENTITY = IDENTITY + 1

		SELECT SUBLEN = STRPOS(Content, Flag)
		SELECT SPLITCONTENT = SUBSTRING(Content,0,SUBLEN)	
		SELECT Content = SUBSTRING(Content,SUBLEN + 1,LEN(Content) + 1)
		
		SELECT ORGCODE = CASE WHEN	LEFT(SPLITCONTENT,1) = '(' 	THEN '1' ELSE '0' END

		if STRPOS(SPLITCONTENT, ':') > 0
		begin
			select DivID = substring(SPLITCONTENT,0,STRPOS(SPLITCONTENT, ':'))
			select SPLITCONTENT = substring(SPLITCONTENT,STRPOS(SPLITCONTENT, ':')+1,LEN(SPLITCONTENT))
		end
		else
		begin
			set DivID='0'
			select DivID=divid from EDMSTreeItem where ID=SPLITCONTENT
		end
		
		
		INSERT INTO ChildOrgan (Id, Contents, ORGFLAG, DivID)
		RETURN QUERY
		SELECT	IDENTITY		
		,		REPLACE(REPLACE(SPLITCONTENT,'(EG)',''),'(UG)','')
		,		ORGCODE
		,		DivID

	END

	DELETE FROM ChildOrgan
	WHERE	LEN(Contents) = 0 
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
