-- ─── PROCEDURE→FUNCTION: edmsdocupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.edmsdocupdate();
CREATE OR REPLACE FUNCTION public.edmsdocupdate(
) RETURNS SETOF record
AS $function$
DECLARE
    title character varying;
    edmsdocid integer;
    wgroupcode integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test
RETURN QUERY
SELECT * FROM EDMSSplitTable('8703001;0008018;0209008;9906001;0503007;0208014;',';')
RETURN QUERY
SELECT * FROM EDMSDOCUMENT

		,	KEYWORD		NVARCHAR(200)		--키워드	
		,	SUMMARY		varchar(8000)				--문서요약	
		,	CONTECT		varchar(8000)		--문서내용
		,	Classflag		VARCHAR(1000)		--분류		EX)1,2,3,4
		,	SUCURITY		VARCHAR(7000)		--권한		EX)(EG)0001;일반 그룹' , (UG)0003;사용자 지정 그룹' ,0209008 사용자 아이디. : ;로구분
		,	SUCURITYLEVEL	VARCHAR(10)			--보안등급	
		,	STOREPERIOD	VARCHAR(10)			--보존년한	
		,	ORGID			VARCHAR(7000)		--부서		
		,	Receive		VARCHAR(7000)		--수신처	
		,	USERID			NVARCHAR(50)		--작성자
		,	EADOCID		int					--EDMS이관여부
		,	VERSION		VARCHAR(20)			--버젼
		,	ATTACHPATH		VARCHAR(255)		--첨부파일의 경로 가상경로 EX) /AA/AA.AA
		,	ATTACHNAME		VARCHAR(7000)		--첨부파일명
		,	ATTACHFLAG		VARCHAR(7000)		--확장자
		,	VERSIONFLAG	VARCHAR(1)			--버젼을 업시켜서 등록할 것인지 현재 버전에서 업데이트 시킬지 판단. Y : 업등록 N : 현재버젼업데이트
		,	DOCID			INT					--문서번호
		,	IsPDF			VARCHAR(7000)		--머지 PDF 여부
		,	CONTENTTEXT	VARCHAR(7000)				--FULLTEXT
		,	GroupCode		VARCHAR(4)			--계열사
		,	GradeID		VARCHAR(4)			--직책코드
		,	PositionID		VARCHAR(4)			--직급코드


	TITLE := ('test'		--제목);
		,	KEYWORD		= 'test'		--키워드	
		,	SUMMARY		= ''				--문서요약	
		,	CONTECT		= 'test'		--문서내용
		,	Classflag		= '40;31;36'		--분류		EX)1,2,3,4
		,	SUCURITY		= ''		--권한		EX)(EG)0001;일반 그룹' , (UG)0003;사용자 지정 그룹' ,0209008 사용자 아이디. : ;로구분
		,	SUCURITYLEVEL	= '0'			--보안등급	
		,	STOREPERIOD	= '12'			--보존년한	
		,	ORGID			= '004'		--부서		
		,	Receive		= ''		--수신처	
		,	USERID			= 'admin'		--작성자
		,	EADOCID		= 0					--EDMS이관여부
		,	VERSION		= '1.5'			--버젼
		,	ATTACHPATH		=''		--첨부파일의 경로 가상경로 EX) /AA/AA.AA
		,	ATTACHNAME		=''		--첨부파일명
		,	ATTACHFLAG		=''		--확장자
		,	VERSIONFLAG	='Y'			--버젼을 업시켜서 등록할 것인지 현재 버전에서 업데이트 시킬지 판단. Y : 업등록 N : 현재버젼업데이트
		,	DOCID			= '88'					--문서번호
		,	IsPDF			=''		--머지 PDF 여부
		,	CONTENTTEXT	= 'test'				--FULLTEXT
		,	GroupCode		= 'G001'			--계열사
		,	GradeID		= '190'			--직책코드
		,	PositionID		= '220'			--직급코드
	--*/
	/*
		로직
		VERSIONFLAG 가 Y를 리턴하면 새로운 버젼으로 신규 등록이 된다. id는 따로 돌아가지만 그룹값이 이전 버젼의 그룹값으로 등록이 된다.
						n을 리턴할경우 현재 문서 내용을 그대로 업데이트 하면 된다.
						n일경우에는 이미 등록되어있는 권한,분류,수신처,파일 등을 삭제한후에 등록한다.
	*/
	/***************************************************************************
	-- 필요변수 셋팅
	***************************************************************************/


	valdate := (case when STOREPERIOD > 0  and STOREPERIOD <> '' then dateadd(month,convert(int,STOREPERIOD),NOW()));
							else dateadd(year,1000,NOW())
								END;


	SELECT MAX(EADOCFLAG) INTO eadocid FROM EDMSDOCUMENT WHERE ID = WGROUPCODE --재설정

	IF EADOCID is null THEN
		EADOCID := 0;
	END IF;
	----------------------------- 필요변수 셋팅 끝 -----------------------------	
	
	IF VERSIONFLAG = 'Y' THEN
			/***************************************************************************
			-- EDMSDOCUMENT INSERT
			***************************************************************************/			

			INSERT INTO EDMSDOCUMENT
			(	
						 TITLE
			,            CONTENT
			,            WRITERID
			,            WGROUP
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
			,			DocState
			,			VERSIONSTATE
			,			ContentText
			,			GroupCode
			,			GradeID
			,			PositionID
			,			valdate
			,			DocLevel
			)
			SELECT 
					   TITLE										
			,           CONTECT
			,           USERID
			,			WGROUPCODE		--그룹코드
			,			SUCURITYLEVEL
			,           ORGID
			,			NOW()		--등록일
			,			''				--삭제플레그
			,			0				--체크인
			,           STOREPERIOD
			,           SUMMARY
			,           VERSION
			,           KEYWORD
			,           EADOCID	--재설정했음 위에서.
			,			'0'
			,			'Y'	
			,			CONTENTTEXT	
			,			GroupCode	
			,			GradeID	
			,			PositionID	
			,			valdate
			,			DocLevel

			EDMSDOCID := (@IDENTITY);
			--최신버전 셋팅.;
			UPDATE	EDMSDOCUMENT
			VERSIONSTATE := '';
			WHERE	WGROUP = (SELECT WGROUP FROM EDMSDOCUMENT WHERE ID = DOCID)
			AND		ID	<>	EDMSDOCID

			/***************************************************************************
			-- 시리얼 인서트.
			***************************************************************************/
			IF (select COALESCE(valuedata,'') from EDMSConfiguration where KeyCode='VersionUpSerialKeep') = '1' THEN;
				update	edmsdocument
				Serial := (select Serial from EDMSDocument where ID=WGROUPCODE);
				where	id = EDMSDOCID 
			  END IF;
			ELSE
				PERFORM edmsserialsetting(EDMSDOCID
				
				update	edmsdocument);
				Serial := public."EDMSRETURNSerial"(EDMSDOCID,(SELECT VALUEDATA FROM EDMSConfiguration WHERE KEYCODE = 'DocSerial'),WriterID,RegDate);
				where	id = EDMSDOCID 
			  END IF;
			----------------------------- EDMSDOCUMENT INSERT INTO 끝 -----------------------------	
	END IF;
	ELSE

			/***************************************************************************
			-- EDMSDOCUMENT UPDATE
			***************************************************************************/
			EDMSDOCID := (DOCID);;
			UPDATE  EDMSDOCUMENT
			TITLE := TITLE;
			,       CONTENT			=	CONTECT						
			,       AUTHORITYLEVEL	=	SUCURITYLEVEL			
			,       MODIFIER		=	USERID
			,       MODDATE			=	NOW()		--등록일
			,       ISDELETE		=	''				--삭제플레그
			,       STATE			=	0				--체크인
			,       STOREPERIOD		=	STOREPERIOD
			,       SUMMARY			=	SUMMARY
			,       VERSION			=	VERSION
			,       KEYWORD			=	KEYWORD			
			,		ContentText		=	CONTENTTEXT 
			,		valdate			=	valdate
			,		DocLevel		=	DocLevel
			WHERE	ID				=	DOCID

			/***************************************************************************
			-- 분류,권한,수신처 내역을 삭제한후 하단에서 재등록한다.
			***************************************************************************/
			--키워드;
			DELETE FROM EDMSKeyWord
			WHERE	DOCID				=	DOCID

			--분류;
			DELETE FROM EDMSDocFolder
			WHERE	DOCID				=	DOCID

			--권한 부서;
			DELETE FROM EDMSAUTHDEPART
			WHERE	DOCID				=	DOCID

			--권한 유져;
			DELETE FROM EDMSAUTHUSER 
			WHERE	DOCID				=	DOCID 

			--수신처 부서;
			DELETE FROM EDMSReceiveORG
			WHERE	DOCID				=	DOCID 

			--수신처 유져;
			DELETE FROM EDMSReceiveUSER
			WHERE	DOCID				=	DOCID 
			

			--첨부파일;
			DELETE FROM EDMSFile	
			WHERE	DOCID				=	DOCID
			and IsPDF<>'F'
			------------------ 분류,권한,수신처 테이블 삭제 끝 -------------------------	
			
	END IF;

	/***************************************************************************
	-- 키워드 인서트
	***************************************************************************/           	;
	INSERT INTO EDMSKeyWord
	SELECT	EDMSDOCID
	,		CONTENTS
	FROM	EDMSSplitTable(KEYWORD,',')
	----------------------------- 키워드 인서트 끝 -----------------------------	

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
	FROM	EDMSSplitTable(SUCURITY,';')
	WHERE	ORGFLAG = '1'
	
	INSERT INTO EDMSAUTHUSER
	SELECT	EDMSDOCID
	,		CONTENTS 
	FROM	EDMSSplitTable(SUCURITY,';')
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

	if(ATTACHPATH <> '') 
	BEGIN
		/***************************************************************************
		-- 첨부 파일 테이블 인서트
		ATTACHNAME = 
		,		ATTACHFLAG = '.txt;.txt;.sql;'
		***************************************************************************/   	 ;
		INSERT INTO EDMSFILE	
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

	if exists(SELECT ID,EDMSDOCID FROM EDMSFILE WHERE DOCID = EDMSDOCID)
	begin
			SELECT ID,EDMSDOCID FROM EDMSFILE WHERE DOCID = EDMSDOCID order by ID
	END;
	ELSE
			SELECT 0 as ID,EDMSDOCID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
