-- ─── FUNCTION: edmssplittable ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmssplittable();
CREATE OR REPLACE FUNCTION public.edmssplittable(
) RETURNS TABLE(
    id integer,
    contents character varying,
    orgflag character varying
)
-- TODO: LEN was not fully converted; use length()
AS $function$
#variable_conflict use_column
DECLARE
    content character varying;
    splitcontent character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
 
/* test
--SELECT * FROM EDMSSplitTable('(EG)0001;(EG)0002;(EG)0003;(EG)0004;(EG)0005;',';','123456789','(EG)')

,	Flag		varchar(10)			--분기할 문자열
,	Key		varchar(7999)		--쪼인시 키로 사용할 값
,	REPLACE		VARCHAR(255)		--여분으로 붙은 문자열

SELECT	Content	=	'(EG)0001;(EG)0002;(EG)0003;(EG)0004;(EG)0005;(EG)0006;(EG)0012;(EG)0013;(EG)0014;(EG)0089;(EG)0090;(EG)0091;(EG)0092;(EG)0093;(EG)0094;(EG)0095;(EG)0096;(EG)0097;(EG)0098;(EG)0099;(EG)0100;(EG)0101;(EG)0102;(EG)0103;(EG)0104;(EG)0105;(EG)0106;(EG)0107;(EG)0108;(EG)0109;(EG)0110;(EG)0111;(EG)0112;(EG)0150;(EG)0151;(EG)0015;(EG)0016;(EG)0017;(EG)0019;(EG)0113;(EG)0018;(EG)0020;(EG)0021;(EG)0007;(EG)0022;(EG)0025;(EG)0026;(EG)0023;(EG)0027;(EG)0028;(EG)0024;(EG)0029;(EG)0008;(EG)0030;(EG)0031;(EG)0032;(EG)0009;(EG)0034;(EG)0035;(EG)0036;(EG)0114;(EG)0115;(EG)0120;(EG)0116;(EG)0117;(EG)0119;(EG)0118;(EG)0010;(EG)0037;(EG)0038;(EG)0039;(EG)0040;(EG)0011;(EG)0041;(EG)0042;(EG)0043;(EG)0044;(EG)0045;(EG)0046'
,		Flag		=	';'
,		REPLACE	=	'(EG)'
--*/	
	


	,		SUBLEN			INT				--FALG로 찾아낸 문자의 길이
	,		ORGCODE		CHAR(1)			--SPLITCONTENT 가 부서일지 유저일지를 판단한다. '1' : 부서 , '0' : 유져
	,		IDENTITY		INT				--리턴테이블에 키가되어줄 필드.

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

		INSERT INTO ChildOrgan
		RETURN QUERY
		SELECT	IDENTITY		
		,		REPLACE(REPLACE(SPLITCONTENT,'(EG)',''),'(UG)','')
		,		ORGCODE

	END

	DELETE FROM ChildOrgan
	WHERE	LEN(Contents) = 0 
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
