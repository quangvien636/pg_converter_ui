-- ─── PROCEDURE→FUNCTION: edmsessentialupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.edmsessentialupdate(character varying, integer, character varying, character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmsessentialupdate(
    IN userid character varying,
    IN docid integer,
    IN title character varying DEFAULT '',
    IN keyword character varying DEFAULT '',
    IN summary text DEFAULT '',
    IN version character varying DEFAULT '',
    IN classflag character varying DEFAULT '',
    IN auth character varying DEFAULT '',
    IN authoritylevel character varying DEFAULT '',
    IN keepdate character varying DEFAULT '',
    IN orgcd character varying DEFAULT '',
    IN receive character varying DEFAULT '',
    IN doclevel character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
DECLARE
    title character varying;
    edmsdocid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test
RETURN QUERY
SELECT * FROM EDMSSplitTable('8703001;0008018;0209008;9906001;0503007;0208014;',';')
RETURN QUERY
SELECT * FROM EDMSDOCUMENT WHERE ID = 16


		,                KEYWORD			VARCHAR(200)	--키워드	
		,                SUMMARY			VARCHAR(7999)			--문서요약	
		,                VERSION			NVARCHAR(50)	--버젼	
		,                CLASSFLAG			VARCHAR(2000)	--분류		EX)1,2,3,4
		,                AUTH				VARCHAR(2000)	--권한		EX)(EG)0001;일반 그룹' , (UG)0003;사용자 지정 그룹' ,0209008 사용자 아이디. : ;로구분
		,                AUTHORITYLEVEL    VARCHAR(5)		--보안등급	
		,                KEEPDATE			VARCHAR(5)		--보존년한	
		,                ORGCD				VARCHAR(2000)	--부서		
		,                Receive			VARCHAR(2000)	--수신처	
		,				 USERID			VARCHAR(400)	--작성자
		,				 DocId				int				--문서번호
			
			
		TITLE := ('김상민 쵝오'--제목);
		,                KEYWORD			='김상민 쵝오'--키워드	
		,                SUMMARY			='김상민 쵝오'--문서요약	
		,                VERSION			='김상민 쵝오'--버젼	
		,                CLASSFLAG			=''--분류		EX)1,2,3,4
		,                AUTH				=''--권한		EX)(EG)0001;일반 그룹' , (UG)0003;사용자 지정 그룹' ,0209008 사용자 아이디. : ;로구분
		,                AUTHORITYLEVEL    ='4'--보안등급	
		,                KEEPDATE			='4'--보존년한	
		,                ORGCD				=''--부서		
		,                Receive			=''--수신처	
		,				 USERID			='ADMIN'--작성자
		,				 DocId				= 16--문서번호
	--*/
	/***************************************************************************
	-- 필요변수 셋팅
	***************************************************************************/



	/***************************************************************************
	-- EDMSDOCUMENT UPDATE
	***************************************************************************/
	EDMSDOCID := (DOCID);
	valdate := (case when KEEPDATE > 0 and KEEPDATE <> '' then dateadd(month,convert(int,KEEPDATE),NOW()));
								else dateadd(year,convert(int,1000),NOW())
								END;


	UPDATE  EDMSDOCUMENT
	TITLE := edmsessentialupdate.title;
	,       AUTHORITYLEVEL	=	edmsessentialupdate.authoritylevel
	,		DEPARTID		=	edmsessentialupdate.orgcd
	,       MODIFIER		=	edmsessentialupdate.userid
	,       MODDATE			=	NOW()		--등록일
	,       ISDELETE		=	''				--삭제플레그
	,       STATE			=	0				--체크인
	,       STOREPERIOD		=	edmsessentialupdate.keepdate
	,       SUMMARY			=	edmsessentialupdate.summary
	,       VERSION			=	edmsessentialupdate.version
	,       KEYWORD			=	edmsessentialupdate.keyword	  
	,		valdate			=	valdate
	,		DocLevel		=	edmsessentialupdate.doclevel
	WHERE	ID				=	edmsessentialupdate.docid

	/***************************************************************************
	-- 분류,권한,수신처 내역을 삭제한후 하단에서 재등록한다.
	***************************************************************************/
	--분류;
	DELETE FROM EDMSDocFolder
	WHERE	DOCID				=	edmsessentialupdate.docid

	--권한 부서;
	DELETE FROM EDMSAUTHDEPART 
	WHERE	DOCID				=	edmsessentialupdate.docid

	--권한 유져;
	DELETE FROM EDMSAUTHUSER
	WHERE	DOCID				=	edmsessentialupdate.docid 

	--수신처 부서;
	DELETE FROM EDMSReceiveORG
	WHERE	DOCID				=	edmsessentialupdate.docid 

	--수신처 유져;
	DELETE FROM EDMSReceiveUSER
	WHERE	DOCID				=	edmsessentialupdate.docid 

	--첨부파일;
	DELETE FROM EDMSFile	
	WHERE	DOCID				=	edmsessentialupdate.docid
	
	------------------ 분류,권한,수신처 테이블 삭제 끝 -------------------------	
	
	/***************************************************************************
	-- 분류 테이블 인서트
	***************************************************************************/;
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

	SELECT DOCID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
