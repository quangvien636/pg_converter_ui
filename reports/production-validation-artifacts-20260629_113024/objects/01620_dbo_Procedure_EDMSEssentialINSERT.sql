-- ─── PROCEDURE→FUNCTION: edmsessentialinsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.edmsessentialinsert(character varying, integer, character varying, character varying, character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmsessentialinsert(
    IN userid character varying,
    IN docid integer,
    IN doclevel character varying,
    IN title character varying DEFAULT '',
    IN keyword character varying DEFAULT '',
    IN summary text DEFAULT '',
    IN version character varying DEFAULT '',
    IN classflag character varying DEFAULT '',
    IN auth character varying DEFAULT '',
    IN authoritylevel character varying DEFAULT '',
    IN keepdate character varying DEFAULT '',
    IN orgcd character varying DEFAULT '',
    IN receive character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
DECLARE
    title character varying;
    valdate timestamp without time zone;
    edmsdocid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*

,                SUMMARY			VARCHAR(8000)
,                VERSION			NVARCHAR(50)
,                CLASSFLAG			VARCHAR(2000)
,                SUCURITY			VARCHAR(2000)
,                SUCURITYLEVEL     VARCHAR(5)
,                KEEPDATE			VARCHAR(5)
,                ORGCD				VARCHAR(2000)
,                Receive				VARCHAR(2000)
,				 USERID			VARCHAR(400)

TITLE := (''		--제목);
,                KEYWORD			=	''		--키워드
,                SUMMARY			=	''		--내용요약 : 사용안함.
,                VERSION			=	''		--버젼
,                CLASSFLAG			=	''		--분류
,                SUCURITY			=	''		--권한
,                SUCURITYLEVEL     =	''		--권한등급
,                KEEPDATE			=	''		--조본년한
,                ORGCD				=	''		--부서
,                Receive				=	''		--수신처
,				 USERID			=   ''		--등록자
--*/

									else dateadd(year,convert(int,1000),NOW())
									END;

	INSERT INTO  EDMSDocument
	(
				 TITLE
	,            KEYWORD
	,            SUMMARY
	,            VERSION
	,            AUTHORITYLEVEL
	,            StorePeriod
	,            DepartID	
	,			 REGDATE
	,			 WRITERID
	,			 EADOCFLAG
	,			 ISDELETE
	,			 STATE
	,			 DocState
	,			 VERSIONSTATE
	,			 valdate
	,			 DocLevel
	)
	SELECT 
				 TITLE			--제목
	,            KEYWORD		--키워드
	,            SUMMARY		--내용요약 : 사용안함.
	,            VERSION		--버젼
	,            AUTHORITYLEVEL--권한등급
	,            KEEPDATE		--조본년한
	,            ORGCD			--부서
	,			NOW()
	,			USERID			--등록자
	,			'1'				-- 이관 되는 문서라는뜻이다.
	,			''				--삭제여부
	,			0				--체크인 여부
	,			'1'				--사용여부 : 기본등록시에는 사용안함이지만 문서가 이관완료가 되면 현재 플레그를 0으로 바꿔준다.
	,			'Y'
	,			valdate
	,			DocLevel



	/***************************************************************************
	-- 그룹 값 인서트.
	***************************************************************************/;
	update	edmsdocument
	wgroup := EDMSDOCID;
	where	id = EDMSDOCID 

	/***************************************************************************
	-- 시리얼 인서트. (등록시 미사용이어서 문서번호 채번안함. 이관시 채번(2014.2.13)
	***************************************************************************/
	--exec EDMSSerialSetting EDMSDOCID
	
	--update	edmsdocument
	--set		Serial = public."EDMSRETURNSerial"(EDMSDOCID,(SELECT VALUEDATA FROM EDMSConfiguration WHERE KEYCODE = 'DocSerial'),USERID,NOW())
	--where	id = EDMSDOCID 


	----------------------------- EDMSDOCUMENT INSERT INTO 끝 -----------------------------	

	/***************************************************************************
	-- 분류 테이블 인서트
	***************************************************************************/
	
	INSERT INTO EDMSDocFolder(DocID, FolderID, divid)
	SELECT	EDMSDOCID
	,		CONTENTS
	,		DivID
	FROM	public."EDMSClassSplitTable"(CLASSFLAG,';')

	----------------------------- 분류 테이블 인서트 끝 -----------------------------	

	/***************************************************************************
	-- 권한 테이블 인서트
	***************************************************************************/           	

	INSERT INTO EDMSAUTHDEPART
	SELECT	EDMSDOCID
	,		CONTENTS
	FROM	EDMSSplitTable(AUTH,';')
	WHERE	ORGFLAG = '1'
	
	INSERT INTO EDMSAUTHUSER
	SELECT	EDMSDOCID
	,		CONTENTS 
	FROM	EDMSSplitTable(AUTH,';')
	WHERE	ORGFLAG = '0'

	----------------------------- 권한 테이블 인서트 끝 -----------------------------	

	/***************************************************************************
	-- 수신 테이블 인서트
	***************************************************************************/  

	INSERT INTO EDMSReceiveORG
	SELECT	EDMSDOCID
	,		CONTENTS 
	FROM	EDMSSplitTable(Receive,';')
	WHERE	ORGFLAG = '1'
	
	INSERT INTO EDMSReceiveUSER
	SELECT	EDMSDOCID
	,		CONTENTS 
	FROM	EDMSSplitTable(Receive,';')
	WHERE	ORGFLAG = '0'

	----------------------------- 수신 테이블 인서트 끝 -----------------------------	

	SELECT EDMSDOCID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
