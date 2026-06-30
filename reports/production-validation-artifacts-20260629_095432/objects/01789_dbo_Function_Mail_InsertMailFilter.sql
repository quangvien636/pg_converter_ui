-- ─── FUNCTION: mail_insertmailfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailfilter(integer, character varying, character varying, character varying, character varying, bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_insertmailfilter(
    userno integer,
    fieldtype character varying,
    conditiontype character varying,
    executetype character varying,
    executevalue character varying,
    mailboxno bigint,
    beforemailboxno bigint
) RETURNS TABLE(
    boxno text
)
AS $function$
DECLARE
    filterno bigint;
BEGIN


	/*
	 * 같은 규칙이 있으면 삭제합니다.
	 */
	 

	SELECT FilterNo = FilterNo FROM Mail_MailFilters
	WHERE UserNo = mail_insertmailfilter.userno AND FieldFg = mail_insertmailfilter.fieldtype AND ConditionType = ConditionFg AND ExecValue = mail_insertmailfilter.executevalue

	IF (FilterNo IS NOT NULL) BEGIN
	
		EXEC Mail_DeleteMailFilter FilterNo
	
	END



	/*
	 * 분류 규칙을 추가힙니다.
	 */
	 
	UPDATE Mail_MailFilters SET SortNo = SortNo + 1 WHERE UserNo = mail_insertmailfilter.userno

	INSERT INTO Mail_MailFilters
	VALUES(UserNo, FieldType, ConditionType, ExecuteType, ExecuteValue, MailBoxNo, 1)
	
	SET FilterNo = lastval()
	RETURN QUERY
	SELECT FilterNo;
	
	
	--/*
	-- * 메일을 이동시킬지 여부를 확인합니다.
	-- */
	 
	--IF BeforeMailBoxNo = 0 AND ExecuteValue = '200' BEGIN
	
	--	RETURN
	
	--END
	
	
	
	
	--/*
	-- * 전체메일함에서 제외된 메일함을 찾습니다.
	-- */
	
	--DECLARE TotalBoxs TABLE (
	--	RowNum		INT,
	--	BoxNo		BIGINT,
	--	ParentNo	BIGINT,
	--	SortNo		INT
	--)

	--DECLARE MissBoxs TABLE (
	--	BoxNo		BIGINT,
	--	ParentNo	BIGINT,
	--	SortNo		INT
	--)

	--INSERT INTO TotalBoxs
	--SELECT ROW_NUMBER() OVER (ORDER BY BoxNo ASC) AS RowNum,
	--	BoxNo, ParentNo, SortNo
	--FROM Mail_MailBoxs WHERE UserNo = UserNo

	--DECLARE CurrentRow INT, TotalRow INT
	--SET CurrentRow = 1
	--SET TotalRow = (SELECT MAX(RowNum) FROM TotalBoxs)

	--DECLARE BoxNo BIGINT, ParentNo BIGINT, SortNo INT

	--WHILE (CurrentRow <= TotalRow) BEGIN

	--	SELECT
	--		BoxNo = BoxNo,
	--		ParentNo = ParentNo,
	--		SortNo = SortNo
	--	FROM TotalBoxs WHERE RowNum = CurrentRow

	--	IF (ParentNo = -1) BEGIN
		
	--		IF (SortNo IN (1, 3, 4, 5, 6)) BEGIN
			
	--			INSERT INTO MissBoxs VALUES(BoxNo, ParentNo, SortNo)
			
	--		END
				
	--	END
		
	--	ELSE IF (ParentNo = 1) BEGIN
		
	--		INSERT INTO MissBoxs VALUES(BoxNo, ParentNo, SortNo)
		
	--	END
		
	--	ELSE IF (ParentNo != 0) BEGIN
		
	--		DECLARE _ParentNo BIGINT
	--		SET _ParentNo = ParentNo
			
	--		WHILE (_ParentNo NOT IN (0, 1)) BEGIN
			
	--			SET _ParentNo = (SELECT ParentNo FROM TotalBoxs WHERE BoxNo = _ParentNo)
			
	--		END
			
	--		IF (_ParentNo = 1) BEGIN
			
	--			INSERT INTO MissBoxs VALUES(BoxNo, ParentNo, SortNo)
			
	--		END
		
	--	END

	--	SET CurrentRow = CurrentRow + 1

	--END
	 
	 
	 
	 
	--/*
	-- * 선택된 메일함이 전제메일함인지 확인합니다.
	-- */
	 
	--SELECT ParentNo = ParentNo, SortNo = SortNo
	--FROM Mail_MailBoxs WHERE BoxNo = BeforeMailBoxNo
	
	--DECLARE IsAllMailBox BIT
	--SET IsAllMailBox = FALSE
	
	--IF ParentNo = -1 AND (SortNo = 1 OR SortNo = 7) BEGIN
	
	--	SET IsAllMailBox = TRUE
	
	--END
	
	
	
	--IF IsAllMailBox = FALSE BEGIN
		
	--	/*
	--	 * 메일을 이동합니다.
	--	 */
		 
	--	IF FieldType = '100' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND Title ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND Title ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND Title = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND Title ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--	ELSE IF FieldType = '200' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND Content ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND Content ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND Content = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND Content ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--	ELSE IF FieldType = '300' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND FromAddr ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND FromAddr ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND FromAddr = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND FromAddr ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--	ELSE IF FieldType = '400' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND FromName ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND FromName ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND FromName = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND FromName ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--	ELSE IF FieldType = '600' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND To ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND To ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND To = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo = BeforeMailBoxNo AND IsDelete = FALSE
	--				AND To ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
	
	--END
	
	--ELSE BEGIN
	
	--	/*
	--	 * 전체메일함에 속한 모든 메일함의 메일을 이동합니다.
	--	 */
		 
	--	IF FieldType = '100' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND Title ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND Title ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND Title = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND Title ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--	ELSE IF FieldType = '200' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND Content ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND Content ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND Content = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND Content ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--	ELSE IF FieldType = '300' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND FromAddr ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND FromAddr ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND FromAddr = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND FromAddr ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--	ELSE IF FieldType = '400' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND FromName ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND FromName ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND FromName = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND FromName ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--	ELSE IF FieldType = '600' BEGIN
		
	--		IF ConditionType = '100' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND To ILIKE '%' || ExecuteValue || '%' ESCAPE '['

	--		END
			
	--		ELSE IF ConditionType = '200' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND To ILIKE ExecuteValue || '%' ESCAPE '['
				
	--		END
			
	--		ELSE IF ConditionType = '300' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND To = ExecuteValue
				
	--		END
		
	--		ELSE IF ConditionType = '500' BEGIN
			
	--			UPDATE Mail_Mails SET BoxNo = MailBoxNo
	--			WHERE UserNo = UserNo AND BoxNo NOT IN (SELECT BoxNo FROM MissBoxs) AND IsDelete = FALSE
	--				AND To ILIKE '%' || ExecuteValue ESCAPE '['
		
	--		END
			
	--	END
		
	--END
	
	--EXEC Mail_CleanupCountOfMailBoxs_UserNo UserNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
