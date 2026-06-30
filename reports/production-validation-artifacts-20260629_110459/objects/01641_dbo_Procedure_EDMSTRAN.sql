-- ─── PROCEDURE→FUNCTION: edmstran ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.edmstran(integer);
CREATE OR REPLACE FUNCTION public.edmstran(
    IN eadocid integer
) RETURNS SETOF record
AS $function$
DECLARE
    eddocumentid integer;
    keyword character varying;
    usesaup character varying;
    saupname character varying;
    edmsauthlowdepart_cursor cursor;
    updepart character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*
RETURN QUERY
SELECT * FROM EAPPDOCUMENT WHERE EDMSID <> 0

--*/;
	UPDATE	A					--조회조건에서 검색하기위한 내용 업데이트.
	SET		A.ContentText = B.ContentText
	,		A.Content	=	b.Summary
	,		A.groupCode = b.groupCode
	,		A.Title = b.Title
	,		A.RegDate = B.RegDate
	FROM	EDMSDOCUMENT A
			INNER JOIN
			EAPPDOCUMENT B
			ON A.ID = B.EDMSID
			WHERE	A.ID = EDDOCUMENTID

	if exists(select valuedata from EDMSConfiguration where KeyCode='TranEADocSerial' and ValueData='1')
	  begin 

		UPDATE	EDMSDocument	
		DocState := '0'				--사용안함으로 등록된 내역을 사용함으로 수정.;
		,		EADocFlag=edmstran.eadocid	
		,		Serial = (select Serial from EAPPDocument where ID=edmstran.eadocid) --결재시리얼번호 사용
		WHERE	ID = EDDOCUMENTID		

	  END;
	ELSE
		
		IF (select docstate from EDMSDocument where ID=EDDOCUMENTID) = '1' THEN
			PERFORM edmsserialsetting(EDDOCUMENTID
		  
			UPDATE	EDMSDocument);
			Serial := public."EDMSRETURNSerial"(EDDOCUMENTID,(SELECT VALUEDATA FROM EDMSConfiguration WHERE KEYCODE = 'DocSerial'),WriterID,RegDate) --시리얼번호 리턴;
			WHERE	ID = EDDOCUMENTID	
		END IF;
		
		UPDATE	EDMSDocument	
		DocState := '0'				--사용안함으로 등록된 내역을 사용함으로 수정.;
		,		EADocFlag=edmstran.eadocid	
		WHERE	ID = EDDOCUMENTID	
			
	  END IF;

	-- 공개일경우 전계열사에 열람되므로 기안서이관시 비공개일 경우 공개는 강제적으로 기안자의 열람등급 또는 최상위 보안등급으로 변경;
	UPDATE	d 	
	SET		d.AuthorityLevel = (case when AuthorityLevel=0 and (select AuthorityLevel from EAPPDocument where ID=edmstran.eadocid) = 100 then COALESCE((select AuthorityLevel from EDMSUserEnv where UserID=d.WriterID),(select /* TOP 1 */ SUBSTRING(code,1,1) from public."EDMSGetCodeToTable"((select ValueData from EDMSConfiguration where KeyCode='AultAuthorityLevel'),','))) else d.AuthorityLevel end)
	FROM EDMSDocument d WHERE	ID = EDDOCUMENTID		
		
	UPDATE	EAPPDocument	
	EDMSState := '200'			--이관 성공 상태로 변경;
	WHERE	ID = edmstran.eadocid

	/***************************************************************************
	-- 키워드 인서트
	***************************************************************************/           	


	INSERT INTO EDMSKeyWord
	RETURN QUERY
	SELECT	EDDOCUMENTID
	,		CONTENTS
	FROM	EDMSSplitTable(	keyWord,',')
	----------------------------- 키워드 인서트 끝 -----------------------------	
	
	--사업장 등록--

	
	IF useSaup = '1' THEN

		SELECT SaupjangName, SaupjangCode INTO saupname, saupcode from EAPPDocUserSerial where DocId = edmstran.eadocid
		
		if(SaupName is not null and SaupCode is not null)
		begin
			if exists (select docid from EDMS_Saupjang where DocID=EDDOCUMENTID)
			begin;
				update EDMS_Saupjang set SaupName=SaupName, SaupCode=SaupCode where DocID=EDDOCUMENTID
			END;
			ELSE;
				insert into EDMS_Saupjang(DocID,SaupName,SaupCode)
				values(EDDOCUMENTID,SaupName,SaupCode)
			END IF;
		END;
	END IF;

	--결재자 열람권한 자동적용
	if exists(select * from EDMSConfiguration where KeyCode='UseManagerAuth' and ValueData='1')
	begin
		--결재자 열람권한;
		insert into EDMSAuthUser(DOCID, UserID)
		RETURN QUERY
		select a.EDDocID,a.ManagerID from (select EDDOCUMENTID EDDocID,EADocID EADocID,ManagerID from EAPPProgress where DocumentID=edmstran.eadocid and STRPOS(ManagerID, '#')=0) a left join
		EDMSAuthUser b on a.EDDocID=b.DOCID and a.ManagerID=b.UserID where b.UserID is null
		group by a.EDDocID, a.ManagerID
		
		--기안부서 열람권한;
		insert into EDMSAuthDepart(DOCID, ORGCD)
		RETURN QUERY
		select EDDocID, DepartID from
		(select EDDOCUMENTID EDDocID, DepartID from EAPPDocument where ID=edmstran.eadocid and AuthorityLevel=200) a left join EDMSAuthDepart b on a.EDDocID=b.DOCID and a.DepartID=b.ORGCD where b.ORGCD is null
		
		--부서 열람권한;
		insert into EDMSAuthDepart(DOCID, ORGCD)
		RETURN QUERY
		select a.EDDocID,a.OrgCd from (select EDDOCUMENTID EDDocID,EADocID EADocID, Replace(Replace(Replace(Replace(Replace(ManagerID,'DR#',''),'DA#',''),'DL#',''),'DS#',''),'GR#','') OrgCd from EAPPProgress where DocumentID=edmstran.eadocid and STRPOS(ManagerID, '#')>0 and ManagerID not ILIKE 'DL#%') a left join
		EDMSAuthDepart b on a.EDDocID=b.DOCID and a.OrgCd=b.ORGCD where b.ORGCD is null
	
		--하위부서 열람권한

		RETURN QUERY
		select Replace(ManagerID,'DL#','') OrgCd from EAPPProgress where DocumentID=edmstran.eadocid and STRPOS(ManagerID, '#')>0 and ManagerID ILIKE 'DL#%'



		fetch next from EDMSAuthLowDepart_Cursor into updepart

		while @FETCH_STATUS = 0
		begin;
				insert into EDMSAuthDepart(DOCID, ORGCD)
				RETURN QUERY
				select a.eddocid, a.OrgCd 
				from (select EDDOCUMENTID EDDocID, ORGCD from public."COMNGetOrganChild"(updepart)) a 
				left join EDMSAuthDepart b on a.EDDocID=b.DOCID and a.OrgCd=b.ORGCD where b.ORGCD is null

		fetch next from EDMSAuthLowDepart_Cursor into updepart
		END;

		close EDMSAuthLowDepart_Cursor
		deallocate EDMSAuthLowDepart_Cursor

	END;
	
	--이관시 결재문서 양식명 추가입력
	if not exists (select id from EDMSDocSubInfo where edmsid=EDDOCUMENTID)
	begin ;
		insert into EDMSDocSubInfo(edmsid, FormName1, FormName2, FormName3, FormName4)
		RETURN QUERY
		select ed.ID, public."EAPPGetFormNm"(ea.FormID,'1') nm1
		,public."EAPPGetFormNm"(ea.FormID,'2') nm2
		,public."EAPPGetFormNm"(ea.FormID,'3') nm3
		,public."EAPPGetFormNm"(ea.FormID,'4') nm4
		 from EDMSDocument ed
		inner join EAPPDocument ea on ed.EADocFlag=ea.ID 
		where ed.ID=EDDOCUMENTID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
