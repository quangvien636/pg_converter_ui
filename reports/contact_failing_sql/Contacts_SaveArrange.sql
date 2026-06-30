-- ─── PROCEDURE→FUNCTION: contacts_savearrange ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_savearrange(integer, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_savearrange(
    IN userno integer,
    IN mainseqlist character varying,
    IN namelist character varying,
    IN emaillist character varying,
    IN numberlist character varying
) RETURNS SETOF record
AS $function$
DECLARE
    tempmainseqlist character varying;
    tempmainseqno integer;
    checkmainseqlist character varying;
    tempdeluserseqlist character varying;
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
    tempemailcnt integer;
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
    tempnumbercnt integer;
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
BEGIN






	TempMainSeqList := contacts_savearrange.mainseqlist || ',';
	CheckMainSeqList := REPLACE(TempMainSeqList,',','');
	-- 정리할 주소록이 있는지 검사
	IF LEN(CheckMainSeqList) > 0 THEN

		-- 정리할 주소록 분할 처리
		WHILE STRPOS(',TempMainSeqList, ') > 0 LOOP
			-- 정리 기준 주소록 번호;
			TempMainSeqNo := SUBSTRING(TempMainSeqList,0,STRPOS(',TempMainSeqList, '));
			-- 성명;







			TempNameList := contacts_savearrange.namelist || '$';
			CheckNameList := REPLACE(REPLACE(TempNameList,',',''),'$',',');
			IF LEN(CheckNameList) > 0 THEN
				WHILE STRPOS(TempNameList, '$') > 0 LOOP

					TempNameOneList := SUBSTRING(TempNameList,0,STRPOS(TempNameList, '$'));
					TempNameOneList := TempNameOneList || ',';
					TempNameCnt := 0;
					WHILE STRPOS(',TempNameOneList, ') > 0 LOOP
						TempNameOne := SUBSTRING(TempNameOneList,0,STRPOS(',TempNameOneList, '));
						IF TempNameCnt = 0 THEN
							TempNameMainSeq := TempNameOne;
						ELSIF TempNameCnt = 1 THEN
							TempNameUserSeq := TempNameOne;
						TempNameCnt := TempNameCnt + 1;
						TempNameOneList := SUBSTRING(TempNameOneList,STRPOS(',TempNameOneList, ')+1,LEN(TempNameOneList));
					END LOOP;

					IF TempMainSeqNo = TempNameMainSeq THEN

						UPDATE U
						SET LastName = S.LastName,
							FirstName = S.FirstName
						FROM ContactsUser U, ContactsUser S
						WHERE U.Seq = TempMainSeqNo
						AND S.Seq = TempNameUserSeq;

					END IF;

					TempNameList := SUBSTRING(TempNameList,STRPOS(TempNameList, '$')+1,LEN(TempNameList));
				END LOOP;
			END IF;
			-- 이메일;









			TempEmailList := contacts_savearrange.emaillist || '$';
			CheckEmailList := REPLACE(REPLACE(TempEmailList,',',''),'$','');
			-- // ========================
			-- // 이메일 데이터 체크
			-- // ========================
			IF LEN(CheckEmailList) > 0 THEN
				WHILE STRPOS(TempEmailList, '$') > 0 LOOP
					PRINT('이메일 루프');
					TempEmailOneList := SUBSTRING(TempEmailList,0,STRPOS(TempEmailList, '$'));
					TempEmailOneList := TempEmailOneList || ',';
					TempEmailCnt := 0;
					WHILE STRPOS(', TempEmailOneList, ') > 0 LOOP
						TempEmailOne := SUBSTRING(TempEmailOneList,0,STRPOS(',TempEmailOneList, '));
						IF TempEmailCnt = 0 THEN
							TempEmailMainSeq := TempEmailOne;
						ELSIF TempEmailCnt = 1 THEN
							TempEmailUserSeq := TempEmailOne;
						ELSIF TempEmailCnt = 2 THEN
							TempEmailSeq := TempEmailOne;
						ELSIF TempEmailCnt = 3 THEN
							TempEmailYN := TempEmailOne;
						TempEmailCnt := TempEmailCnt +1;
						TempEmailOneList := SUBSTRING(TempEmailOneList,STRPOS(',TempEmailOneList, ')+1,LEN(TempEmailOneList));
					END LOOP;
					-- ========================
					-- MainSeq가 같은 것만 처리
					-- ========================
					IF TempMainSeqNo = TempEmailMainSeq THEN
						IF TempMainSeqNo <> TempEmailUserSeq THEN
							tempdeluserseqlist := COALESCE(tempdeluserseqlist, '') || COALESCE((CONVERT(text,TempEmailUserSeq) || ','), '');
						END IF;
						IF TempEmailYN = 'Y' THEN
						BEGIN -- Y인 경우 병합처리



							SELECT Value INTO tempemailvalue FROM ContactsEmail

							WHERE Seq = TempEmailSeq



							SELECT COUNT(Value) INTO tempemailcheck FROM ContactsEmail

							WHERE UserSeq = TempEmailMainSeq
							AND Value = TempEmailValue;
							-- 메인에 존재하지 않으면 업데이트
							IF TempEMailCheck = 0 THEN
								UPDATE ContactsEmail
								SET
									UserSeq = TempMainSeqNo,
									IsDefault = FALSE,
									ModDate = NOW()
								WHERE
									Seq = TempEmailSeq
								AND UserSeq = TempEmailUserSeq;
							ELSIF TempMainSeqNo <> TempEmailMainSeq AND TempEMailCheck > 0 THEN
							BEGIN -- 메인의 데이터가 아니면서 존재하는 경우는 삭제;
								DELETE FROM ContactsEmail
								WHERE Seq = TempEmailSeq
								AND UserSeq = TempEmailUserSeq;
							END IF;
						ELSE
						    -- N인 경우 병합하지 않고 삭제;
						END IF;
						BEGIN
							DELETE FROM ContactsEmail
							WHERE Seq = TempEmailSeq
							AND UserSeq = TempEmailUserSeq
						END;
					END LOOP;

					TempEmailList := SUBSTRING(TempEmailList,STRPOS(TempEmailList, '$')+1,LEN(TempEmailList));
				END IF;
			END LOOP;

			-- 전화번호;









			TempNumberList := contacts_savearrange.numberlist || '$';
			CheckNumberList := REPLACE(REPLACE(TempNumberList,',',''),'$','');
			-- // ========================
			-- // 전화번호 데이터 체크
			-- // ========================
			IF LEN(CheckNumberList) > 0 THEN
				WHILE STRPOS(TempNumberList, '$') > 0 LOOP
					TempNumberOneList := SUBSTRING(TempNumberList,0,STRPOS(TempNumberList, '$'));
					TempNumberOneList := TempNumberOneList || ',';
					TempNumberCnt := 0;
					WHILE STRPOS(', TempNumberOneList, ') > 0 LOOP
						TempNumberOne := SUBSTRING(TempNumberOneList,0,STRPOS(',TempNumberOneList, '));
						IF TempNumberCnt = 0 THEN
							TempNumberMainSeq := TempNumberOne;
						ELSIF TempNumberCnt = 1 THEN
							TempNumberUserSeq := TempNumberOne;
						ELSIF TempNumberCnt = 2 THEN
							TempNumberSeq := TempNumberOne;
						ELSIF TempNumberCnt = 3 THEN
							TempNumberYN := TempNumberOne;
						TempNumberCnt := TempNumberCnt + 1;
						TempNumberOneList := SUBSTRING(TempNumberOneList,STRPOS(',TempNumberOneList, ')+1,LEN(TempNumberOneList));
					END LOOP;
					-- ========================
					-- MainSeq가 같은 것만 처리
					-- ========================
					IF TempMainSeqNo = TempNumberMainSeq THEN
						IF TempMainSeqNo <> TempNumberUserSeq THEN
							PRINT(TempDelUserSeqList);
							tempdeluserseqlist := COALESCE(tempdeluserseqlist, '') || COALESCE((CONVERT(text,TempNumberUserSeq) || ','), '');
						END IF;
						IF TempNumberYN = 'Y' THEN
						BEGIN -- Y인 경우 병합처리



							SELECT Value INTO tempnumbervalue FROM ContactsNumber

							WHERE Seq = TempNumberSeq



							SELECT COUNT(Value) INTO tempnumbercheck FROM ContactsNumber

							WHERE UserSeq = TempNumberMainSeq
							AND Value = TempNumberValue;
							-- 메인에 존재하지 않으면 업데이트
							IF TempNumberCheck = 0 THEN
								UPDATE ContactsNumber
								SET
									UserSeq = TempMainSeqNo,
									IsDefault = FALSE,
									ModDate = NOW()
								WHERE
									Seq = TempNumberSeq
								AND UserSeq = TempNumberUserSeq;
							ELSIF TempMainSeqNo <> TempNumberMainSeq AND TempNumberCheck > 0 THEN
							BEGIN -- 메인의 데이터가 아니면서 존재하는 경우는 삭제;
								DELETE FROM ContactsNumber
								WHERE Seq = TempNumberSeq
								AND UserSeq = TempNumberUserSeq;
							END IF;
						ELSE
						    -- N인 경우 병합하지 않고 삭제;
						END IF;
						BEGIN
							DELETE FROM ContactsNumber
							WHERE Seq = TempNumberSeq
							AND UserSeq = TempNumberUserSeq
						END;
					END LOOP;

					TempNumberList := SUBSTRING(TempNumberList,STRPOS(TempNumberList, '$')+1,LEN(TempNumberList));
				END IF;
			END IF;
			-- 처리되면 전부 삭제
			IF LEN(TempDelUserSeqList) > 0 THEN

				WHILE STRPOS(',TempDelUserSeqList, ') > 0 LOOP
					TempDelUserSeqNo := SUBSTRING(TempDelUserSeqList,0,STRPOS(',TempDelUserSeqList, '));
					DELETE FROM ContactsAddress WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsCompany WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsDays WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsEmail WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsGroupUser WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsHomepage WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsNumber WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsSns WHERE UserSeq = TempDelUserSeqNo;
					DELETE FROM ContactsUser WHERE Seq = TempDelUserSeqNo;

					TempDelUserSeqList := SUBSTRING(TempDelUserSeqList,STRPOS(',TempDelUserSeqList, ')+1,LEN(TempDelUserSeqList));
				END LOOP;
			END IF;
			-- 다음 정리> 기준 주소록번호;
			TempMainSeqList := SUBSTRING(TempMainSeqList,STRPOS(',TempMainSeqList, ')+1,LEN(TempMainSeqList));
		END;



		IF @ERROR <> 0 THEN

		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.