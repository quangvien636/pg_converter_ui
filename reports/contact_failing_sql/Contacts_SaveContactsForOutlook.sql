-- ─── PROCEDURE→FUNCTION: contacts_savecontactsforoutlook ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_savecontactsforoutlook(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, "position" character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_savecontactsforoutlook(
    IN userno integer,
    IN outlookentryid character varying,
    IN folderentryid character varying,
    IN firstname character varying,
    IN lastname character varying,
    IN memo character varying,
    IN company character varying,
    IN depart character varying,
    IN "position" character varying,
    IN email1 character varying,
    IN email2 character varying,
    IN email3 character varying,
    IN mobilephone character varying,
    IN homephone character varying,
    IN homefax character varying,
    IN homepost character varying,
    IN homeaddress character varying,
    IN workphone character varying,
    IN workfax character varying,
    IN workpost character varying,
    IN workaddress character varying,
    IN otherphone character varying,
    IN otherfax character varying,
    IN otherpost character varying,
    IN otheraddress character varying,
    IN webpage character varying
) RETURNS SETOF record
AS $function$
DECLARE
    contactno integer;
    contactscount integer;
    companyseq integer;
    companycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT  INTO  FROM ContactsUserOutlook
	WHERE OutlookEntryID = contacts_savecontactsforoutlook.outlookentryid

	IF ContactsCount = 0 THEN
		-- 주소록 추가 작업;
		INSERT INTO ContactsUser
		(
			FirstName,
			LastName,
			RegUserNo,
			RegDate,
			ModDate,
			CheckDate,
			Memo,
			Photo,
			Share,
			UseYn,
			Important,
			CallName,
			ViewCount
		)
		VALUES
		(
			FirstName,
			LastName,
			UserNo,
			NOW(),
			NOW(),
			NOW(),
			Memo,
			'',
			'100',
			'Y',
			0,
			'',
			0
		);
		ContactNo := lastval();
		-- 그룹;
		INSERT INTO ContactsGroupUser
		(
			RegUserNo,
			RegDate,
			ModDate,
			UserSeq,
			GroupNo
		)
		VALUES
		(
			UserNo,
			NOW(),
			NOW(),
			ContactNo,
			COALESCE((SELECT GroupNo FROM ContactsGroupOutlook WHERE OutlookFolderEntryID = contacts_savecontactsforoutlook.folderentryid),0)
		)

		-- 회사정보가 있는 경우만
		IF LEN(Company) > 0 OR LEN(Depart) > 0 OR LEN(Position) > 0 THEN
			INSERT INTO ContactsCompany
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Company,
				Depart,
				Position,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				Company,
				Depart,
				Position,
				'1'
			);
		END IF;
		-- 이메일1
		IF LEN(EMail1) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail1,
				'1'
			);
		END IF;
		-- 이메일2
		IF LEN(EMail2) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail2,
				'0'
			);
		END IF;
		-- 이메일3
		IF LEN(EMail3) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail3,
				'0'
			);
		END IF;
		-- 홈페이지
		IF LEN(WebPage) > 0 THEN
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'홈페이지',
				WebPage,
				1
			);
		END IF;
		-- 메신저
		IF LEN(Massenger) > 0 THEN
			INSERT INTO ContactsSns
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				Massenger,
				1
			);
		END IF;
		-- 휴대폰
		IF LEN(MobilePhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'휴대폰',
				MobilePhone,
				1
			);
		END IF;
		-- 집전화
		IF LEN(HomePhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				1,
				'집',
				HomePhone,
				0
			);
		END IF;
		-- 집팩스
		IF LEN(HomeFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				HomeFax,
				0
			);
		END IF;
		-- 회사전화
		IF LEN(WorkPhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				2,
				'회사',
				WorkPhone,
				0
			);
		END IF;
		-- 회사팩스
		IF LEN(WorkFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				WorkFax,
				0
			);
		END IF;
		-- 기타전화
		IF LEN(OtherPhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				OtherPhone,
				0
			);
		END IF;
		-- 기타팩스
		IF LEN(OtherFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				OtherFax,
				0
			);
		END IF;
		--집주소
		IF LEN(HomePost) > 0 OR LEN(HomeAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				1,
				'집',
				SUBSTRING(HomePost,1,3),
				SUBSTRING(HomePost,4,3),
				HomeAddress,
				0
			);
		END IF;
		--회사주소
		IF LEN(WorkPost) > 0 OR LEN(WorkAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'회사',
				SUBSTRING(WorkPost,1,3),
				SUBSTRING(WorkPost,4,3),
				WorkAddress,
				0
			);
		END IF;
		--기타주소
		IF LEN(OtherPost) > 0 OR LEN(OtherAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				SUBSTRING(OtherPost,1,3),
				SUBSTRING(OtherPost,4,3),
				OtherAddress,
				0
			);
		END IF;
	ELSE
		SELECT  INTO  FROM ContactsUserOutlook
		WHERE UserNo = contacts_savecontactsforoutlook.userno
		AND OutlookEntryID = contacts_savecontactsforoutlook.outlookentryid
		-- 주소록 추가 작업;
		UPDATE ContactsUser
		SET
			FirstName = contacts_savecontactsforoutlook.firstname,
			LastName = contacts_savecontactsforoutlook.lastname,
			ModDate = NOW(),
			Memo = contacts_savecontactsforoutlook.memo
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND Seq = ContactNo

		-- 그룹;
		UPDATE ContactsGroupUser
		SET
			ModDate = NOW(),
			UserSeq = ContactNo,
			GroupNo = COALESCE((SELECT GroupNo FROM ContactsGroupOutlook WHERE OutlookFolderEntryID = contacts_savecontactsforoutlook.folderentryid),0)
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno

		-- 회사정보가 있는 경우만
		IF LEN(Company) > 0 OR LEN(Depart) > 0 OR LEN(Position) > 0 THEN


			SELECT  INTO  FROM ContactsCompany
			WHERE Company = contacts_savecontactsforoutlook.company

			IF CompanyCount = 0 THEN
				INSERT INTO ContactsCompany
				(
					RegUserNo,
					RegDate,
					ModDate,
					UserSeq,
					Company,
					Depart,
					Position,
					IsDefault
				)
				VALUES
				(
					UserNo,
					NOW(),
					NOW(),
					ContactNo,
					Company,
					Depart,
					Position,
					'0'
				);
			END IF;
			BEGIN
				SELECT Seq INTO companyseq FROM ContactsCompany
				WHERE Company = contacts_savecontactsforoutlook.company;

				UPDATE ContactsCompany
				SET
					Company = contacts_savecontactsforoutlook.company,
					Depart = contacts_savecontactsforoutlook.depart,
					Position = Position
				WHERE Seq = CompanySeq
			END;
		END IF;
		-- 기존 메일 삭제후 재입력;
		DELETE FROM ContactsEmail
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo
		-- 이메일1
		IF LEN(EMail1) > 0 THEN

			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail1,
				'1'
			);

		END IF;
		-- 이메일2
		IF LEN(EMail2) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail2,
				'0'
			);
		END IF;
		-- 이메일3
		IF LEN(EMail3) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail3,
				'0'
			);
		END IF;
		-- 기존 홈페이지 삭제;
		DELETE FROM ContactsHomepage
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo
		AND Type = 0
		-- 홈페이지
		IF LEN(WebPage) > 0 THEN
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'홈페이지',
				WebPage,
				1
			);
		END IF;
		-- 기존 메신저정보 삭제;
		DELETE FROM ContactsSns
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo
		AND Type = 8
		-- 메신저
		IF LEN(Massenger) > 0 THEN
			INSERT INTO ContactsSns
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				Massenger,
				1
			);
		END IF;
		-- 기존 전화번호 삭제;
		DELETE FROM ContactsNumber
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo
		-- 휴대폰
		IF LEN(MobilePhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'휴대폰',
				MobilePhone,
				1
			);
		END IF;
		-- 집전화
		IF LEN(HomePhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				1,
				'집',
				HomePhone,
				0
			);
		END IF;
		-- 집팩스
		IF LEN(HomeFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				HomeFax,
				0
			);
		END IF;
		-- 회사전화
		IF LEN(WorkPhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				2,
				'회사',
				WorkPhone,
				0
			);
		END IF;
		-- 회사팩스
		IF LEN(WorkFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				WorkFax,
				0
			);
		END IF;
		-- 기타전화
		IF LEN(OtherPhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				OtherPhone,
				0
			);
		END IF;
		-- 기타팩스
		IF LEN(OtherFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				OtherFax,
				0
			);
		END IF;
		-- 기존주소 삭제;
		DELETE FROM ContactsAddress
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo
		--집주소
		IF LEN(HomePost) > 0 OR LEN(HomeAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				1,
				'집',
				SUBSTRING(HomePost,1,3),
				SUBSTRING(HomePost,4,3),
				HomeAddress,
				0
			);
		END IF;
		--회사주소
		IF LEN(WorkPost) > 0 OR LEN(WorkAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'회사',
				SUBSTRING(WorkPost,1,3),
				SUBSTRING(WorkPost,4,3),
				WorkAddress,
				0
			);
		END IF;
		--기타주소
		IF LEN(OtherPost) > 0 OR LEN(OtherAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				SUBSTRING(OtherPost,1,3),
				SUBSTRING(OtherPost,4,3),
				OtherAddress,
				0
			);
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.