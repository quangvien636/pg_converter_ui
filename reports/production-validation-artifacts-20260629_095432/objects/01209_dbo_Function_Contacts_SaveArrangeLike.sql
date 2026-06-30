-- ─── FUNCTION: contacts_savearrangelike ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_savearrangelike(character varying);
CREATE OR REPLACE FUNCTION public.contacts_savearrangelike(
    mainseqlist character varying
) RETURNS TABLE(
    col1 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tempmainseqlist character varying;
    checkmainseqlist character varying;
    tempnamelist character varying;
    tempnameonelist character varying;
    tempnameone character varying;
    tempnamecnt integer;
    tempnamemainseq integer;
    tempnameuserseq integer;
    checknamelist character varying;
    tempemaillist character varying;
    tempemailonelist character varying;
    tempemailone character varying;
    tempemailmainseq integer;
    tempemailuserseq integer;
    tempemailseq integer;
    tempemailyn character varying;
    checkemaillist character varying;
    tempemailvalue character varying;
    tempemailcheck integer;
    tempnumberlist character varying;
    tempnumberonelist character varying;
    tempnumberone character varying;
    tempnumbermainseq integer;
    tempnumberuserseq integer;
    tempnumberseq integer;
    tempnumberyn character varying;
    checknumberlist character varying;
    tempnumbervalue character varying;
    tempnumbercheck integer;
    tempdeluserseqno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	




	
	SET TempMainSeqList = contacts_savearrangelike.mainseqlist || ','
	SET CheckMainSeqList = REPLACE(TempMainSeqList,',','')
	-- 정리할 주소록이 있는지 검사
	IF LEN(CheckMainSeqList) > 0
	BEGIN
		BEGIN TRAN
		-- 정리할 주소록 분할 처리
		WHILE STRPOS(',TempMainSeqList, ') > 0
		BEGIN
			-- 정리 기준 주소록 번호
			SET TempMainSeqNo = SUBSTRING(TempMainSeqList,0,STRPOS(',TempMainSeqList, '))
			
			-- 성명 







			SET TempNameList = NameList || '$'
			SET CheckNameList = REPLACE(REPLACE(TempNameList,',',''),'$',',')
			
			IF LEN(CheckNameList) > 0
			BEGIN
				WHILE STRPOS(TempNameList, '$') > 0
				BEGIN

					SET TempNameOneList = SUBSTRING(TempNameList,0,STRPOS(TempNameList, '$'))
					SET TempNameOneList = TempNameOneList || ','
					SET TempNameCnt = 0
					
					WHILE STRPOS(',TempNameOneList, ') > 0
					BEGIN
						SET TempNameOne = SUBSTRING(TempNameOneList,0,STRPOS(',TempNameOneList, '))
						IF TempNameCnt = 0
							SET TempNameMainSeq = TempNameOne
						ELSE IF TempNameCnt = 1
							SET TempNameUserSeq = TempNameOne
						SET TempNameCnt = TempNameCnt + 1
						SET TempNameOneList = SUBSTRING(TempNameOneList,STRPOS(',TempNameOneList, ')+1,LEN(TempNameOneList))
					END
					
					IF TempMainSeqNo = TempNameMainSeq
					BEGIN
					
						UPDATE U
						SET
							U.LastName = S.LastName,
							U.FirstName = S.FirstName
						FROM ContactsUser U, ContactsUser S
						WHERE U.Seq = TempMainSeqNo
						AND S.Seq = TempNameUserSeq
					
					END
					
					SET TempNameList = SUBSTRING(TempNameList,STRPOS(TempNameList, '$')+1,LEN(TempNameList))
				END
			END
			-- 이메일









			SET TempEmailList = EmailList || '$'
			SET CheckEmailList = REPLACE(REPLACE(TempEmailList,',',''),'$','')
			-- // ========================
			-- // 이메일 데이터 체크
			-- // ========================
			IF LEN(CheckEmailList) > 0
			BEGIN
				WHILE STRPOS(TempEmailList, '$') > 0
				BEGIN
					PRINT('이메일 루프')
					SET TempEmailOneList = SUBSTRING(TempEmailList,0,STRPOS(TempEmailList, '$'))
					SET TempEmailOneList = TempEmailOneList || ','
					SET TempEmailCnt = 0
					
					WHILE STRPOS(', TempEmailOneList, ') > 0
					BEGIN
						SET TempEmailOne = SUBSTRING(TempEmailOneList,0,STRPOS(',TempEmailOneList, '))
							
						IF TempEmailCnt = 0
							SET TempEmailMainSeq = TempEmailOne
						ELSE IF TempEmailCnt = 1
							SET TempEmailUserSeq = TempEmailOne
						ELSE IF TempEmailCnt = 2
							SET TempEmailSeq = TempEmailOne
						ELSE IF TempEmailCnt = 3
							SET TempEmailYN = TempEmailOne
							
						SET TempEmailCnt = TempEmailCnt +1
						
						SET TempEmailOneList = SUBSTRING(TempEmailOneList,STRPOS(',TempEmailOneList, ')+1,LEN(TempEmailOneList))
					END
					-- ========================	
					-- MainSeq가 같은 것만 처리
					-- ========================
					IF TempMainSeqNo = TempEmailMainSeq
					BEGIN
						IF TempMainSeqNo <> TempEmailUserSeq
						BEGIN
							SET TempDelUserSeqList += CONVERT(text,TempEmailUserSeq) + ','
						END
						IF TempEmailYN = 'Y'
						BEGIN -- Y인 경우 병합처리
							

							SELECT TempEmailValue = Value 
							FROM ContactsEmail
							WHERE Seq = TempEmailSeq
							

							SELECT TempEMailCheck = COUNT(Value)
							FROM ContactsEmail
							WHERE UserSeq = TempEmailMainSeq
							AND Value = TempEmailValue 
							-- 메인에 존재하지 않으면 업데이트
							IF TempEMailCheck = 0
							BEGIN;
								UPDATE ContactsEmail
								SET
									UserSeq = TempMainSeqNo,
									IsDefault = FALSE,
									ModDate = NOW()
								WHERE 
									Seq = TempEmailSeq
								AND UserSeq = TempEmailUserSeq
							END 
							ELSE IF TempMainSeqNo <> TempEmailMainSeq AND TempEMailCheck > 0
							BEGIN -- 메인의 데이터가 아니면서 존재하는 경우는 삭제;
								DELETE FROM ContactsEmail
								WHERE Seq = TempEmailSeq
								AND UserSeq = TempEmailUserSeq
							END
						END
						ELSE -- N인 경우 병합하지 않고 삭제
						BEGIN;
							DELETE FROM ContactsEmail 
							WHERE Seq = TempEmailSeq
							AND UserSeq = TempEmailUserSeq
						END	
					END
					
					SET TempEmailList = SUBSTRING(TempEmailList,STRPOS(TempEmailList, '$')+1,LEN(TempEmailList))
				END
			END
			
			-- 전화번호









			SET TempNumberList = NumberList || '$'
			SET CheckNumberList = REPLACE(REPLACE(TempNumberList,',',''),'$','')
			-- // ========================
			-- // 전화번호 데이터 체크
			-- // ========================
			IF LEN(CheckNumberList) > 0
			BEGIN
				WHILE STRPOS(TempNumberList, '$') > 0
				BEGIN
					SET TempNumberOneList = SUBSTRING(TempNumberList,0,STRPOS(TempNumberList, '$'))
					SET TempNumberOneList = TempNumberOneList || ','
					SET TempNumberCnt = 0
					
					WHILE STRPOS(', TempNumberOneList, ') > 0
					BEGIN
						SET TempNumberOne = SUBSTRING(TempNumberOneList,0,STRPOS(',TempNumberOneList, '))
							
						IF TempNumberCnt = 0
							SET TempNumberMainSeq = TempNumberOne
						ELSE IF TempNumberCnt = 1
							SET TempNumberUserSeq = TempNumberOne
						ELSE IF TempNumberCnt = 2
							SET TempNumberSeq = TempNumberOne
						ELSE IF TempNumberCnt = 3
							SET TempNumberYN = TempNumberOne
							
						SET TempNumberCnt = TempNumberCnt + 1
						SET TempNumberOneList = SUBSTRING(TempNumberOneList,STRPOS(',TempNumberOneList, ')+1,LEN(TempNumberOneList))
					END
					-- ========================	
					-- MainSeq가 같은 것만 처리
					-- ========================
					IF TempMainSeqNo = TempNumberMainSeq
					BEGIN
						IF TempMainSeqNo <> TempNumberUserSeq
						BEGIN
							PRINT(TempDelUserSeqList)
							SET TempDelUserSeqList += CONVERT(text,TempNumberUserSeq) + ','
						END
						IF TempNumberYN = 'Y'
						BEGIN -- Y인 경우 병합처리
							

							SELECT TempNumberValue = Value 
							FROM ContactsNumber
							WHERE Seq = TempNumberSeq
							

							SELECT TempNumberCheck = COUNT(Value)
							FROM ContactsNumber
							WHERE UserSeq = TempNumberMainSeq
							AND Value = TempNumberValue 
							-- 메인에 존재하지 않으면 업데이트
							IF TempNumberCheck = 0
							BEGIN;
								UPDATE ContactsNumber
								SET
									UserSeq = TempMainSeqNo,
									IsDefault = FALSE,
									ModDate = NOW()
								WHERE 
									Seq = TempNumberSeq
								AND UserSeq = TempNumberUserSeq
							END 
							ELSE IF TempMainSeqNo <> TempNumberMainSeq AND TempNumberCheck > 0
							BEGIN -- 메인의 데이터가 아니면서 존재하는 경우는 삭제;
								DELETE FROM ContactsNumber
								WHERE Seq = TempNumberSeq
								AND UserSeq = TempNumberUserSeq
							END
						END
						ELSE -- N인 경우 병합하지 않고 삭제
						BEGIN;
							DELETE FROM ContactsNumber
							WHERE Seq = TempNumberSeq
							AND UserSeq = TempNumberUserSeq
						END	
					END
					
					SET TempNumberList = SUBSTRING(TempNumberList,STRPOS(TempNumberList, '$')+1,LEN(TempNumberList))
				END	
			END
			-- 처리되면 전부 삭제
			IF LEN(TempDelUserSeqList) > 0
			BEGIN

				WHILE STRPOS(',TempDelUserSeqList, ') > 0
				BEGIN
					SET TempDelUserSeqNo = SUBSTRING(TempDelUserSeqList,0,STRPOS(',TempDelUserSeqList, '));
					DELETE FROM ContactsAddress WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsCompany WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsDays WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsEmail WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsGroupUser WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsHomepage WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsNumber WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsSns WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsUser WHERE Seq = TempDelUserSeqNo 
					
					SET TempDelUserSeqList = SUBSTRING(TempDelUserSeqList,STRPOS(',TempDelUserSeqList, ')+1,LEN(TempDelUserSeqList))
				END
			END
			-- 다음 정리> 기준 주소록번호
			SET TempMainSeqList = SUBSTRING(TempMainSeqList,STRPOS(',TempMainSeqList, ')+1,LEN(TempMainSeqList))
		END
		

	
		IF @ERROR <> 0
		BEGIN
			ROLLBACK TRAN
		END
		
		COMMIT TRAN
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
