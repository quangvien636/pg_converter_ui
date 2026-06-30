-- ─── FUNCTION: edmsdocumentdiscard ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsdocumentdiscard(character varying);
CREATE OR REPLACE FUNCTION public.edmsdocumentdiscard(
    docids character varying
) RETURNS TABLE(
    docid text
)
AS $function$
DECLARE
    docids character varying;
BEGIN
	/*	test


		SELECT 			 DocIds				= '16;14;51;'--문서번호
	
		drop table #Deletelist
	--*/
	
	/***************************************************************************
	-- 필요변수 셋팅
	***************************************************************************/	
	RETURN QUERY
	select	Contents as Docid
	into	#Deletelist
	from	EDMSSplitTable(DocIds,';')	

	/***************************************************************************
	-- 반환데이터 
	***************************************************************************/	
	RETURN QUERY
	select ATTACHPATH + ATTACHNAME + ATTACHFlag as filepath from  EDMSFile	
	WHERE	DOCID in (select Docid from #Deletelist)	

	RETURN QUERY
	select COUNT(*) from #Deletelist


	/***************************************************************************
	-- EDMSDOCUMENT delete
	***************************************************************************/
	
	DELETE FROM edmsdocument
	where	id in (select Docid from #Deletelist)

	/***************************************************************************
	-- 분류,권한,수신처 내역을 삭제한후 하단에서 재등록한다.
	***************************************************************************/
	--분류;
	DELETE FROM EDMSDocFolder
	WHERE	DOCID				in            (select Docid from #Deletelist)

	--권한 부서;
	DELETE FROM EDMSAUTHDEPART 
	WHERE	DOCID				in            (select Docid from #Deletelist)

	--권한 유져;
	DELETE FROM EDMSAUTHUSER
	WHERE	DOCID				in            (select Docid from #Deletelist) 

	--수신처 부서;
	DELETE FROM EDMSReceiveORG
	WHERE	DOCID				in            (select Docid from #Deletelist) 

	--수신처 유져;
	DELETE FROM EDMSReceiveUSER
	WHERE	DOCID				in            (select Docid from #Deletelist) 

	--첨부파일;
	DELETE FROM EDMSFile	
	WHERE	DOCID				in            (select Docid from #Deletelist);
	------------------ 분류,권한,수신처 테이블 삭제 끝 -------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
