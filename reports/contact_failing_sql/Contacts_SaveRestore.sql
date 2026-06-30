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

		WHILE STRPOS(',HistoryNoList, ') > 0 LOOP
			TempHistoryNo := SUBSTRING(HistoryNoList,0,STRPOS(',HistoryNoList, '));
			SELECT Seq INTO tempseq FROM ContactsUserHistory WHERE HistoryNo = TempHistoryNo



			SELECT COUNT(Seq) INTO datacount FROm ContactsUser WHERE Seq = TempSeq
			-- 데이터가 없으면 신규입력
			IF DataCount = 0 THEN

				-- 주소록 기본 정보;
				INSERT INTO ContactsUser
				(
					FirstName, LastName, RegUserNo, Memo, RegDate,
					Photo, ModDate, CheckDate, Share, UseYn,
					DelDate, Important, CallName, ViewCount
				)
				SELECT FirstName, LastName, RegUserNo, Memo, RegDate,
					Photo, ModDate, CheckDate, Share, UseYn,
					DelDate, Important, CallName, ViewCount
				FROM ContactsUserHistory WHERE HistoryNo = TempHistoryNo;

				newSeq := lastval();
				-- 전화번호;
				INSERT INTO ContactsNumber
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, newSeq, Type, TypeName, Value,
					IsDefault, RegDate, NOW()
				FROM ContactsNumberHistory WHERE HistoryNo = TempHistoryNo
				-- 이메일;
				INSERT INTO ContactsEmail
				(
					RegUserNo, UserSeq, Value, IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, newSeq, Value, IsDefault, RegDate, NOW()
				FROM ContactsEmailHistory WHERE HistoryNo = TempHistoryNo
				-- 회사;
				INSERT INTO ContactsCompany
				(
					RegUserNo, UserSeq, Company, Depart, Position,
					IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, newSeq, Company, Depart, Position,
					IsDefault, RegDate, NOW()
				FROM ContactsCompanyHistory WHERE HistoryNo = TempHistoryNo
				-- 주소;
				INSERT INTO ContactsAddress
				(
					RegUserNo, UserSeq, Type, TypeName, ZipCode1,
					ZipCode2, Address, IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, newSeq, Type, TypeName, ZipCode1,
					ZipCode2, Address, IsDefault, RegDate, NOW()
				FROM ContactsAddressHistory WHERE HistoryNo = TempHistoryNo

				-- 홈페이지;
				INSERT INTO ContactsHomepage
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, newSeq, Type, TypeName, Value,
					IsDefault, RegDate, NOW()
				FROM ContactsHomepageHistory WHERE HistoryNo = TempHistoryNo
				-- SNS;
				INSERT INTO ContactsSns
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, newSeq, Type, TypeName, Value,
					IsDefault, RegDate, NOW()
				FROM ContactsSnsHistory WHERE HistoryNo = TempHistoryNo
				-- 그룹;
				INSERT INTO ContactsGroupUser
				(
					GroupNo, UserSeq, RegUserNo, RegDate, ModDate
				)
				SELECT
					GroupNo, newSeq, RegUserNo, RegDate, ModDate
				FROM ContactsGroupUserHistory WHERE HistoryNo = TempHistoryNo
			ELSE
			    -- 데이터가 있으면 업데이트;
			END IF;
			BEGIN
				UPDATE U
				SET FirstName = H.FirstName,
					LastName = H.LastName,
					RegDate = H.RegDate,
					Memo = H.Memo,
					RegUserNo = H.RegUserNo,
					Photo = H.Photo,
					ModDate = NOW(),
					CheckDate = H.CheckDate,
					Share = H.Share,
					UseYn = 'Y',
					DelDate = H.DelDate,
					Important = H.Important,
					CallName = H.CallName,
					ViewCount = H.ViewCount
				FROM ContactsUser U, ContactsUserHistory H
				WHERE U.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
				-- #################
				-- 전화번호
				-- #################
					-- Seq랑 일치 하는 않는거 삭제;
				DELETE FROM ContactsNumber
				WHERE Seq NOT IN (SELECT Seq FROM ContactsNumberHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq
					-- Seq랑 일치 하는거 업데이트;
				UPDATE N
				SET RegUserNo = H.RegUserNo,
					UserSeq = H.UserSeq,
					Type = H.Type,
					TypeName = H.TypeName,
					Value = H.Value,
					IsDefault = H.IsDefault,
					RegDate = H.RegDate,
					ModDate = NOW()
				FROM ContactsNumber N, ContactsNumberHistory H
				WHERE N.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo
					-- 그외 히스토리에 있는거 인서트;
				INSERT INTO ContactsNumber
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, NOW()
				FROM ContactsNumberHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsNumber WHERE UserSeq = TempSeq)
				-- #################
				-- 이메일
				-- #################;
				DELETE FROM ContactsEmail
				WHERE Seq NOT IN (SELECT Seq FROM ContactsEmailHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq;

				UPDATE E
				SET RegUserNo = H.RegUserNo,
					UserSeq = H.UserSeq,
					Value = H.Value,
					IsDefault = H.IsDefault,
					RegDate = H.RegDate,
					ModDate = NOW()
				FROM ContactsEmail E, ContactsEmailHistory H
				WHERE E.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo;

				INSERT INTO ContactsEmail
				(
					RegUserNo, UserSeq, Value, IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, UserSeq, Value, IsDefault, RegDate, NOW()
				FROM ContactsEmailHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsEmail WHERE UserSeq = TempSeq)
				-- #################
				-- 회사
				-- #################;
				DELETE FROM ContactsCompany
				WHERE Seq NOT IN (SELECT Seq FROM ContactsCompanyHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq;

				UPDATE C
				SET RegUserNo = H.RegUserNo,
					UserSeq = H.UserSeq,
					Company = H.Company,
					Depart = H.Depart,
					Position = H.Position,
					IsDefault = H.IsDefault,
					RegDate = H.RegDate,
					ModDate = NOW()
				FROM ContactsCompany C, ContactsCompanyHistory H
				WHERE C.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo;

				INSERT INTO ContactsCompany
				(
					RegUserNo, UserSeq, Company, Depart, Position,
					IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, UserSeq, Company, Depart, Position,
					IsDefault, RegDate, ModDate
				FROM ContactsCompanyHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsCompany WHERE UserSeq = TempSeq)
				-- #################
				-- 주소
				-- #################;
				DELETE FROM ContactsAddress
				WHERE Seq NOT IN (SELECT Seq FROM ContactsAddressHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq;

				UPDATE A
				SET RegUserNo = H.RegUserNo,
					UserSeq = H.UserSeq,
					Type = H.Type,
					TypeName = H.TypeName,
					ZipCode1 = H.ZipCode1,
					ZipCode2 = H.ZipCode2,
					Address = H.Address,
					IsDefault = H.IsDefault,
					RegDate = H.RegDate,
					ModDate = NOW()
				FROM ContactsAddress A, ContactsAddressHistory H
				WHERE A.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo;

				INSERT INTO ContactsAddress
				(
					RegUserNo, UserSeq, Type, TypeName, ZipCode1,
					ZipCode2, Address, IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, UserSeq, Type, TypeName, ZipCode1,
					ZipCode2, Address, IsDefault, RegDate, ModDate
				FROM ContactsAddressHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsAddress WHERE UserSeq = TempSeq)
				-- #################
				-- 홈페이지
				-- #################;
				DELETE FROM ContactsHomepage
				WHERE Seq NOT IN (SELECT Seq FROM ContactsHomepageHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq;

				UPDATE P
				SET RegUserNo = H.RegUserNo,
					UserSeq = H.UserSeq,
					Type = H.Type,
					TypeName = H.TypeName,
					Value = H.Value,
					IsDefault = H.IsDefault,
					RegDate = H.RegDate,
					ModDate = NOW()
				FROM ContactsHomepage P, ContactsHomepageHistory H
				WHERE P.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo;

				INSERT INTO ContactsHomepage
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				FROM ContactsHomepageHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsHomepage WHERE UserSeq = TempSeq)
				-- #################
				-- SNS
				-- #################;
				DELETE FROM ContactsSns
				WHERE Seq NOT IN (SELECT Seq FROM ContactsSnsHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq;

				UPDATE S
				SET RegUserNo = H.RegUserNo,
					UserSeq = H.UserSeq,
					Type = H.Type,
					TypeName = H.TypeName,
					Value = H.Value,
					IsDefault = H.IsDefault,
					RegDate = H.RegDate,
					ModDate = NOW()
				FROM ContactsSns S, ContactsSnsHistory H
				WHERE S.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo;

				INSERT INTO ContactsSns
				(
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				)
				SELECT
					RegUserNo, UserSeq, Type, TypeName, Value,
					IsDefault, RegDate, ModDate
				FROM ContactsSnsHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsSns WHERE UserSeq = TempSeq)
				-- #################
				-- 그룹
				-- #################;
				DELETE FROM ContactsGroupUser
				WHERE Seq NOT IN (SELECT Seq FROM ContactsGroupUserHistory WHERE HistoryNo = TempHistoryNo)
				AND UserSeq = TempSeq;

				UPDATE G
				SET GroupNo = H.GroupNo,
					UserSeq = H.UserSeq,
					RegUserNo = H.RegUserNo,
					RegDate = H.RegDate,
					ModDate = NOW()
				FROM ContactsGroupUser G, ContactsGroupUserHistory H
				WHERE G.Seq = H.Seq
				AND H.HistoryNo = TempHistoryNo;

				INSERT INTO ContactsGroupUser
				(
					GroupNo, UserSeq, RegUserNo, RegDate, ModDate
				)
				SELECT
					GroupNo, UserSeq, RegUserNo, RegDate, NOW()
				FROM ContactsGroupUserHistory
				WHERE HistoryNo = TempHistoryNo
				AND Seq NOT IN (SELECT Seq FROM ContactsGroupUser WHERE UserSeq = TempSeq)

			END;

			DELETE FROM ContactsNumberHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsEmailHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsDaysHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsCompanyHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsAddressHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsSnsHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsGroupUserHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsUserHistory WHERE HistoryNo = TempHistoryNo;

			HistoryNoList := SUBSTRING(HistoryNoList,STRPOS(',HistoryNoList, ')+1,LEN(HistoryNoList));
		END LOOP
		IF @ERROR <> 0 THEN

		END IF;

	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.