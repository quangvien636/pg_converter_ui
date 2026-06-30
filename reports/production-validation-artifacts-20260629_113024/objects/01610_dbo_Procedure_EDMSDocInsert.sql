-- ─── PROCEDURE→FUNCTION: edmsdocinsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.edmsdocinsert();
CREATE OR REPLACE FUNCTION public.edmsdocinsert(
) RETURNS SETOF record
AS $function$
DECLARE
    title character varying;
    edmsdocid integer;
    chkserial character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test
RETURN QUERY
SELECT * FROM EDMSSplitTable('8703001;0008018;0209008;9906001;0503007;0208014;',';')

,	KEYWORD		NVARCHAR(200)		--키워드	
,	SUMMARY		NTEXT				--문서요약	
,	CONTECT		NTEXT				--문서내용
,	Classflag		VARCHAR(1000)		--분류		EX)1,2,3,4
,	SUCURITY		VARCHAR(7000)		--권한		EX)(EG)0001;일반 그룹' , (UG)0003;사용자 지정 그룹' ,0209008 사용자 아이디. : ;로구분
,	SUCURITYLEVEL	VARCHAR(10)			--보안등급	
,	STOREPERIOD	VARCHAR(10)			--보존년한	
,	ORGID			VARCHAR(7000)		--부서		
,	Receive			VARCHAR(7000)	--수신처	
,	USERID			NVARCHAR(50)		--작성자
,	EADOCID		int					--EDMS이관여부
,	VERSION		VARCHAR(20)			--버젼
,	ATTACHPATH		VARCHAR(255)		--첨부파일의 경로 가상경로 EX) /AA/AA.AA
,	ATTACHNAME		VARCHAR(7000)		--첨부파일명
,	ATTACHFLAG		VARCHAR(7000)		--확장자
,	IsPDF			VARCHAR(7000)		--머지 PDF 여부
,	CONTENTTEXT	NTEXT				--FULLTEXT
,	GroupCode		VARCHAR(4)			--계열사
,	GradeID		VARCHAR(4)			--직책코드
,	PositionID		VARCHAR(4)			--직급코드
TITLE := ('ㄴㅇㅎ');
	,	KEYWORD		= 'ㄴㅇㅀ' 
	,	SUMMARY		= '' 
	,	CONTECT		= '235234534'
	,	Classflag		= '31;34' 
	,	SUCURITY		= '8703001;0008018;0209008;9906001;0503007;0208014;' 
	,	SUCURITYLEVEL	= '3' 
	,	STOREPERIOD	= '3' 
	,	ORGID			= '0004' 
	,	Receive		= '8703001;0503007;' 
	,	USERID			= 'admin' 
	,	EADOCID		= '0' 
	,	VERSION		= '1.0'
	,	ATTACHPATH		= '/_WorkCrewUpload/_EDMS/admin/' 
	,	ATTACHNAME		= '크루70EDMS설계방향200802191;aaaaaa;' 
	,	ATTACHFLAG		= '.doc;.doc;'
	,	IsPDF			= 'N;N;'
	




		
	--*/

	/***************************************************************************
	-- 필요변수 셋팅
	***************************************************************************/

	
	valdate := (case when STOREPERIOD > 0 and STOREPERIOD <> '' then dateadd(month,convert(int,STOREPERIOD),NOW()));
							else dateadd(year,1000,NOW())
							END;
	----------------------------- 필요변수 셋팅 끝 -----------------------------	

	/***************************************************************************
	-- EDMSDOCUMENT INSERT
	***************************************************************************/;
	INSERT INTO EDMSDOCUMENT
	(	
		         TITLE
	,            CONTENT
	,            WRITERID	
	,            AUTHORITYLEVEL
	,			 DEPARTID
	,            REGDATE	
	,            ISDELETE
	,            STATE
	,            STOREPERIOD	
	,            SUMMARY
	,            VERSION
	,            KEYWORD
	,            EADOCFLAG
	,			 DocState
	,			 VersionState
	,			 ContentText
	,			 CheckOutId
	,			 Moddate
	,			GroupCode
	,			GradeID
	,			PositionID
	,			valdate
	,			DocLevel
	)
	RETURN QUERY
	SELECT 
	           TITLE										
	,           CONTECT
	,           USERID	
	,			SUCURITYLEVEL
	,           ORGID
	,			NOW()		--등록일
	,			''				--삭제플레그
	,			'0'				--체크인
	,           STOREPERIOD
	,           SUMMARY
	,           VERSION
	,           KEYWORD
	,           EADOCID  
	,			'0'
	,			'Y'
	,			CONTENTTEXT
	,			''
	,			NOW()
	,			GroupCode	
	,			GradeID	
	,			PositionID	
	,			valdate
	,			DOCLEVEL

	--문서번호 
	EDMSDOCID := (@IDENTITY);
    /***************************************************************************
	-- 그룹 값 인서트.
	***************************************************************************/;
	update	edmsdocument
	wgroup := EDMSDOCID;
	where	id = EDMSDOCID 
	
	/***************************************************************************
	-- 분류 테이블 인서트
	***************************************************************************/
	
	INSERT INTO EDMSDocFolder(DocID, FolderID, divid)
	RETURN QUERY
	SELECT	EDMSDOCID
	,		CONTENTS
	,		DivID
	FROM	public."EDMSClassSplitTable"(CLASSFLAG,';')

	----------------------------- 분류 테이블 인서트 끝 -----------------------------
	
	/***************************************************************************
	-- 시리얼 인서트.
	***************************************************************************/

	
	IF chkSerial <> '1' or chkSerial is null THEN
	PERFORM edmsserialsetting(EDMSDOCID
	
	update	edmsdocument);
	Serial := public."EDMSRETURNSerial"(EDMSDOCID,(SELECT VALUEDATA FROM EDMSConfiguration WHERE KEYCODE = 'DocSerial'),WriterID,RegDate);
	,       WGROUP = EDMSDOCID
	where	id = EDMSDOCID
	END IF;
	----------------------------- EDMSDOCUMENT INSERT INTO 끝 -----------------------------
	
	/***************************************************************************
	-- 키워드 인서트
	***************************************************************************/           	;
	INSERT INTO EDMSKeyWord
	RETURN QUERY
	SELECT	EDMSDOCID
	,		CONTENTS
	FROM	EDMSSplitTable(KEYWORD,',')
	----------------------------- 키워드 인서트 끝 -----------------------------	


	/***************************************************************************
	-- 권한 테이블 인서트
	***************************************************************************/           	

	INSERT INTO EDMSAUTHDEPART
	RETURN QUERY
	SELECT	EDMSDOCID
	,		CONTENTS

	FROM	EDMSSplitTable(SUCURITY,';')
	WHERE	ORGFLAG = '1'
	
	INSERT INTO EDMSAUTHUSER
	RETURN QUERY
	SELECT	EDMSDOCID
	,		CONTENTS 
	FROM	EDMSSplitTable(SUCURITY,';')
	WHERE	ORGFLAG = '0'

	----------------------------- 권한 테이블 인서트 끝 -----------------------------	

	/***************************************************************************
	-- 수신 테이블 인서트
	***************************************************************************/  

	INSERT INTO EDMSReceiveORG
	RETURN QUERY
	SELECT	EDMSDOCID
	,		CONTENTS 
	FROM	EDMSSplitTable(Receive,';')
	WHERE	ORGFLAG = '1'
	
	INSERT INTO EDMSReceiveUSER
	RETURN QUERY
	SELECT	EDMSDOCID
	,		CONTENTS 
	FROM	EDMSSplitTable(Receive,';')
	WHERE	ORGFLAG = '0'

	----------------------------- 수신 테이블 인서트 끝 -----------------------------	

	/***************************************************************************
	-- 첨부 파일 테이블 인서트
	ATTACHNAME = 
	,		ATTACHFLAG = '.txt;.txt;.sql;'
	***************************************************************************/   	 
	/*IF(ATTACHPATH <> '')
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
	END*/

	--SELECT ID FROM EDMSFILE WHERE DOCID = EDMSDOCID order by ID
	
	RETURN QUERY
	select EDMSDOCID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
