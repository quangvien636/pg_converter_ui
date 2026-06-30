-- ─── PROCEDURE→FUNCTION: contacts_saverestore ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_saverestore();
CREATE OR REPLACE FUNCTION public.contacts_saverestore(
) RETURNS SETOF record
AS $function$
DECLARE
    temphistoryno integer;
    chkhistoryno character varying;
    tempseq integer;
    datacount integer;
    newseq integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	HistoryNoList := HistoryNoList || ',';
	ChkHistoryNo := REPLACE(HistoryNoList,',','');
	IF LEN(ChkHistoryNo) > 0 THEN
		BEGIN TRAN
		WHILE STRPOS(',HistoryNoList, ') > 0 LOOP
			TempHistoryNo := SUBSTRING(HistoryNoList,0,STRPOS(',HistoryNoList, '));
			SELECT Seq INTO tempseq FROM ContactsUserHistory WHERE HistoryNo = TempHistoryNo
			

			SELECT COUNT(Seq) INTO datacount FROm ContactsUser WHERE Seq = TempSeq
			-- 데이터가 없으면 신규입력
			IF DataCount = 0 THEN

				-- 주소록 기본 정보;
				INSERT INTO ContactsUser
				(
					FirstName, LastName, RegUserNo, Memo, RegDate,
					Photo, ModDate, CheckDate, Share, UseYn,
					DelDate, Important, CallName, ViewCount
				)
				RETURN QUERY
				SELECT FirstName, LastName, RegUserNo, Memo, RegDate,
					Photo, ModDate, CheckDate, Share, UseYn,
					DelDate, Important, CallName, ViewCount
				FROM ContactsUserHistory WHERE HistoryNo = TempHistoryNo			
				
				newSeq := lastval();
				-- 전화번호;
				INSERT INTO ContactsNumber
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)			
				RETURN QUERY
				SELECT
					RegUserNo, newSeq, Type, TypeName, Value,
					IsDefault, RegDate, NOW()
				FROM ContactsNumberHistory WHERE HistoryNo = TempHistoryNo
				-- 이메일;
				INSERT INTO ContactsEmail
				(
					RegUserNo, UserSeq, Value, IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, newSeq, Value, IsDefault, RegDate, NOW()
				FROM ContactsEmailHistory WHERE HistoryNo = TempHistoryNo
				-- 회사;
				INSERT INTO ContactsCompany
				(
					RegUserNo, UserSeq, Company, Depart, Position, 
					IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, newSeq, Company, Depart, Position,
					IsDefault, RegDate, NOW()
				FROM ContactsCompanyHistory WHERE HistoryNo = TempHistoryNo
				-- 주소;
				INSERT INTO ContactsAddress
				(
					RegUserNo, UserSeq, Type, TypeName, ZipCode1,
					ZipCode2, Address, IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, newSeq, Type, TypeName, ZipCode1,
					ZipCode2, Address, IsDefault, RegDate, NOW()
				FROM ContactsAddressHistory WHERE HistoryNo = TempHistoryNo
				
				-- 홈페이지;
				INSERT INTO ContactsHomepage
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, newSeq, Type, TypeName, Value,
					IsDefault, RegDate, NOW()
				FROM ContactsHomepageHistory WHERE HistoryNo = TempHistoryNo
				-- SNS;
				INSERT INTO ContactsSns
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, newSeq, Type, TypeName, Value,
					IsDefault, RegDate, NOW()
				FROM ContactsSnsHistory WHERE HistoryNo = TempHistoryNo
				-- 그룹;
				INSERT INTO ContactsGroupUser
				(
					GroupNo, UserSeq, RegUserNo, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					GroupNo, newSeq, RegUserNo, RegDate, ModDate
				FROM ContactsGroupUserHistory WHERE HistoryNo = TempHistoryNo
			END IF;
			ELSE -- 데이터가 있으면 업데이트
			BEGIN;
				UPDATE U
				SET
					U.FirstName = H.FirstName,
					U.LastName = H.LastName,
					U.RegDate = H.RegDate,
					U.Memo = H.Memo,
					U.RegUserNo = H.RegUserNo,
					U.Photo = H.Photo,
					U.ModDate = NOW(),
					U.CheckDate = H.CheckDate,
					U.Share = H.Share,
					U.UseYn = 'Y',
					U.DelDate = H.DelDate,
					U.Important = H.Important,
					U.CallName = H.CallName,
					U.ViewCount = H.ViewCount
				FROM ContactsUser U, ContactsUserHistory H
				WHERE U.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
				-- #################
				-- 전화번호
				-- #################
					-- Seq랑 일치 하는 않는거 삭제 ;
				DELETE FROM ContactsNumber 
				WHERE Seq NOT IN (SELECT Seq FROM ContactsNumberHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq
					-- Seq랑 일치 하는거 업데이트;
				UPDATE N
				SET
					N.RegUserNo = H.RegUserNo,
					N.UserSeq = H.UserSeq,
					N.Type = H.Type,
					N.TypeName = H.TypeName,
					N.Value = H.Value,
					N.IsDefault = H.IsDefault,
					N.RegDate = H.RegDate,
					N.ModDate = NOW()
				FROM ContactsNumber N, ContactsNumberHistory H
				WHERE N.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
					-- 그외 히스토리에 있는거 인서트;
				INSERT INTO ContactsNumber
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, NOW()
				FROM ContactsNumberHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsNumber WHERE UserSeq = TempSeq)
				-- #################
				-- 이메일
				-- #################;
				DELETE FROM ContactsEmail
				WHERE Seq NOT IN (SELECT Seq FROM ContactsEmailHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq
				
				UPDATE E
				SET
					E.RegUserNo = H.RegUserNo,
					E.UserSeq = H.UserSeq,
					E.Value = H.Value,
					E.IsDefault = H.IsDefault,
					E.RegDate = H.RegDate,
					E.ModDate = NOW()
				FROM ContactsEmail E, ContactsEmailHistory H
				WHERE E.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
				
				INSERT INTO ContactsEmail
				(
					RegUserNo, UserSeq, Value, IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT 
					RegUserNo, UserSeq, Value, IsDefault, RegDate, NOW()
				FROM ContactsEmailHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsEmail WHERE UserSeq = TempSeq)
				-- #################
				-- 회사
				-- #################;
				DELETE FROM ContactsCompany
				WHERE Seq NOT IN (SELECT Seq FROM ContactsCompanyHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq
				
				UPDATE C
				SET
					C.RegUserNo = H.RegUserNo,
					C.UserSeq = H.UserSeq,
					C.Company = H.Company,
					C.Depart = H.Depart,
					C.Position = H.Position,
					C.IsDefault = H.IsDefault,
					C.RegDate = H.RegDate,
					C.ModDate = NOW()
				FROM ContactsCompany C, ContactsCompanyHistory H
				WHERE C.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
				
				INSERT INTO ContactsCompany
				(
					RegUserNo, UserSeq, Company, Depart, Position, 
					IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, UserSeq, Company, Depart, Position, 
					IsDefault, RegDate, ModDate
				FROM ContactsCompanyHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsCompany WHERE UserSeq = TempSeq)
				-- #################
				-- 주소
				-- #################;
				DELETE FROM ContactsAddress
				WHERE Seq NOT IN (SELECT Seq FROM ContactsAddressHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq
				
				UPDATE A
				SET
					A.RegUserNo = H.RegUserNo,
					A.UserSeq = H.UserSeq,
					A.Type = H.Type,
					A.TypeName = H.TypeName,
					A.ZipCode1 = H.ZipCode1,
					A.ZipCode2 = H.ZipCode2,
					A.Address = H.Address,
					A.IsDefault = H.IsDefault,
					A.RegDate = H.RegDate,
					A.ModDate = NOW()
				FROM ContactsAddress A, ContactsAddressHistory H
				WHERE A.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
				
				INSERT INTO ContactsAddress
				(
					RegUserNo, UserSeq, Type, TypeName, ZipCode1,
					ZipCode2, Address, IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, UserSeq, Type, TypeName, ZipCode1,
					ZipCode2, Address, IsDefault, RegDate, ModDate
				FROM ContactsAddressHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsAddress WHERE UserSeq = TempSeq)
				-- #################
				-- 홈페이지
				-- #################;
				DELETE FROM ContactsHomepage
				WHERE Seq NOT IN (SELECT Seq FROM ContactsHomepageHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq
				
				UPDATE P
				SET
					P.RegUserNo = H.RegUserNo,
					P.UserSeq = H.UserSeq,
					P.Type = H.Type,
					P.TypeName = H.TypeName,
					P.Value = H.Value,
					P.IsDefault = H.IsDefault,
					P.RegDate = H.RegDate,
					P.ModDate = NOW()
				FROM ContactsHomepage P, ContactsHomepageHistory H
				WHERE P.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
				
				INSERT INTO ContactsHomepage
				(
					RegUserNo, UserSeq, Type, TypeName, Value, 
					IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, UserSeq, Type, TypeName, Value, 
					IsDefault, RegDate, ModDate
				FROM ContactsHomepageHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsHomepage WHERE UserSeq = TempSeq)
				-- #################
				-- SNS
				-- #################;
				DELETE FROM ContactsSns
				WHERE Seq NOT IN (SELECT Seq FROM ContactsSnsHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq
				
				UPDATE S
				SET
					S.RegUserNo = H.RegUserNo,
					S.UserSeq = H.UserSeq,
					S.Type = H.Type,
					S.TypeName = H.TypeName,
					S.Value = H.Value,
					S.IsDefault = H.IsDefault,
					S.RegDate = H.RegDate,
					S.ModDate = NOW()
				FROM ContactsSns S, ContactsSnsHistory H
				WHERE S.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
				
				INSERT INTO ContactsSns
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				FROM ContactsSnsHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsSns WHERE UserSeq = TempSeq)
				-- #################
				-- 그룹
				-- #################;
				DELETE FROM ContactsGroupUser
				WHERE Seq NOT IN (SELECT Seq FROM ContactsGroupUserHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq
				
				UPDATE G
				SET
					G.GroupNo = H.GroupNo,
					G.UserSeq = H.UserSeq,
					G.RegUserNo = H.RegUserNo,
					G.RegDate = H.RegDate,
					G.ModDate = NOW()
				FROM ContactsGroupUser G, ContactsGroupUserHistory H
				WHERE G.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
				
				INSERT INTO ContactsGroupUser
				(
					GroupNo, UserSeq, RegUserNo, RegDate, ModDate
				)
				RETURN QUERY
				SELECT
					GroupNo, UserSeq, RegUserNo, RegDate, NOW()
				FROM ContactsGroupUserHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsGroupUser WHERE UserSeq = TempSeq)
				
			END;
			
			DELETE FROM ContactsNumberHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsEmailHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsDaysHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsCompanyHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsAddressHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsSnsHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsGroupUserHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsUserHistory WHERE HistoryNo = TempHistoryNo
			
			HistoryNoList := SUBSTRING(HistoryNoList,STRPOS(',HistoryNoList, ')+1,LEN(HistoryNoList));
		END LOOP;
		IF @ERROR <> 0 THEN
			ROLLBACK TRAN
		END IF;
		COMMIT TRAN
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
