-- ─── PROCEDURE→FUNCTION: contacts_saveaddressinfo_web ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: OUTPUT parameter treated as input because PostgreSQL SETOF functions cannot also use INOUT parameters
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_saveaddressinfo_web(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_saveaddressinfo_web(
    IN seq integer DEFAULT 7961,
    IN firstname character varying DEFAULT 'RM',
    IN lastname character varying DEFAULT 'Mr',
    IN callname character varying DEFAULT 'A',
    IN telinfo character varying DEFAULT '0,0,Cellular Phone,010-3654-0000$0,3,Fax,',
    IN emailinfo character varying DEFAULT '0,Mr kim@naver.com',
    IN companyinfo character varying DEFAULT '0,,,3333333',
    IN addressinfo character varying DEFAULT '$0#1#Home####null#null#',
    IN homepageinfo character varying DEFAULT '',
    IN snsinfo character varying DEFAULT '',
    IN groupinfo character varying DEFAULT '644',
    IN memo character varying DEFAULT '',
    IN share character varying DEFAULT '100',
    IN important integer DEFAULT 1,
    IN photo character varying DEFAULT '',
    IN userno integer DEFAULT 70,
    IN listgroup integer DEFAULT 847
) RETURNS SETOF record
AS $function$
DECLARE
    chktelinfo character varying;
    temptel character varying;
    telisdefault integer;
    teltype smallint;
    teltypename character varying;
    telvalue character varying;
    telcnt integer;
    chkemailinfo character varying;
    tempemail character varying;
    emailisdefault integer;
    emailvalue character varying;
    emailcnt integer;
    chkcompanyinfo character varying;
    tempcompany character varying;
    companyisdefault integer;
    companyname character varying;
    depart character varying;
    position character varying;
    companycnt integer;
    chkaddrinfo character varying;
    tempaddr character varying;
    addrisdefault integer;
    addrtype smallint;
    addrtypename character varying;
    addrzipcode1 character varying;
    addrzipcode2 character varying;
    address character varying;
    addrcnt integer;
    latitude1 double precision;
    longitude1 double precision;
    chkhomeinfo character varying;
    temphome character varying;
    homeisdefault integer;
    hometype smallint;
    hometypename character varying;
    homevalue character varying;
    homecnt integer;
    chksnsinfo character varying;
    tempsns character varying;
    snsisdefault integer;
    snstype smallint;
    snstypename character varying;
    snsvalue character varying;
    snscnt integer;
    chkgroupinfo character varying;
    groupcnt integer;
    groupno integer;
    chktelinfoup character varying;
    temptelup character varying;
    telisdefaultup integer;
    teltypeup smallint;
    teltypenameup character varying;
    telvalueup character varying;
    telcntup integer;
    chkemailinfoup character varying;
    tempemailup character varying;
    emailisdefaultup integer;
    emailvalueup character varying;
    emailcntup integer;
    chkcompanyinfoup character varying;
    tempcompanyup character varying;
    companyisdefaultup integer;
    companynameup character varying;
    departup character varying;
    positionup character varying;
    companycntup integer;
    chkaddrinfoup character varying;
    tempaddrup character varying;
    addrisdefaultup integer;
    addrtypeup smallint;
    addrtypenameup character varying;
    addrzipcode1up character varying;
    addrzipcode2up character varying;
    addressup character varying;
    addrcntup integer;
    latitude2 double precision;
    longitude2 double precision;
    chkhomeinfoup character varying;
    temphomeup character varying;
    homeisdefaultup integer;
    hometypeup smallint;
    hometypenameup character varying;
    homevalueup character varying;
    homecntup integer;
    chksnsinfoup character varying;
    tempsnsup character varying;
    snsisdefaultup integer;
    snstypeup smallint;
    snstypenameup character varying;
    snsvalueup character varying;
    snscntup integer;
    chkgroupinfoup character varying;
    groupcntup integer;
    groupnoup integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Seq = 0 THEN

		-- ============================================
		-- 주소록 기본 저장
		-- ============================================;
		INSERT INTO ContactsUser
		(
			FirstName,
			LastName,
			CallName,
			Memo,
			Share,
			Important,
			Photo,
			UseYn,
			RegUserNo,
			RegDate,
			ModDate
		)
		VALUES
		(
			FirstName,
			LastName,
			CallName,
			Memo,
			Share,
			Important,
			Photo,
			'Y',
			UserNo,
			NOW(),
			NOW()
		);
		Seq := lastval();
		-- ===========================================
		PERFORM contacts_insertlistgroupcontact(Seq,Listgroup);

		-- ============================================
		-- 전화번호
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabnumber (IsDefault CHAR(1), Type integer, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkTelInfo := REPLACE(TelInfo,',','');
		IF LEN(ChkTelInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 전화정보가 존재하면 끝에 $ 추가;
			TelInfo := contacts_saveaddressinfo_web.telinfo || '$';
			-- Row 분리
			WHILE STRPOS(TelInfo, '$') > 0 LOOP

				TempTel := SUBSTRING(TelInfo,0,STRPOS(TelInfo, '$'));
				--SELECT TempTel AS TempTel






				-- Column 분리
				WHILE STRPOS(',TempTel, ') > 0 LOOP

					IF TelCnt = 0 THEN
						--SET TelIsDefault = SUBSTRING(TempTel,0,STRPOS(',TempTel, '));
						TelIsDefault := 1;
					ELSIF TelCnt = 1 THEN
						TelType := SUBSTRING(TempTel,0,STRPOS(',TempTel, '));
					ELSIF TelCnt = 2 THEN
						TelTypeName := SUBSTRING(TempTel,0,STRPOS(',TempTel, '));
					TelCnt := TelCnt + 1;
					TempTel := SUBSTRING(TempTel,STRPOS(',TempTel, ')+1,LEN(TempTel));
				END LOOP;
				TelValue := TempTel;
				-- 임시테이블에 저장;
				INSERT INTO tabNumber
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					TelIsDefault,
					TelType,
					TelTypeName,
					TelValue
				);
				TelInfo := SUBSTRING(TelInfo,STRPOS(TelInfo, '$')+1,LEN(TelInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabNumber;
		ELSE
		BEGIN -- 정보가 없으면 기존 정보 삭제;
			DELETE FROM ContactsNumber WHERE RegUserNo = contacts_saveaddressinfo_web.userno AND UserSeq = contacts_saveaddressinfo_web.seq;
		END IF;
		-- ============================================
		-- 이메일
		-- ============================================
		CREATE TEMP TABLE tabemail (IsDefault CHAR(1), Value varchar(50)) ON COMMIT DROP;



		ChkEmailInfo := REPLACE(EmailInfo,',','');
		IF LEN(ChkEmailInfo) > 0 THEN
			EmailInfo := contacts_saveaddressinfo_web.emailinfo || '$';
			-- Row 분리
			WHILE STRPOS(EmailInfo, '$') > 0 LOOP

				TempEmail := SUBSTRING(EmailInfo,0,STRPOS(EmailInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempEmail, ') > 0 LOOP
					IF EmailCnt = 0 THEN
						EmailIsDefault := SUBSTRING(TempEmail,0,STRPOS(',TempEmail, '));
					EmailCnt := EmailCnt + 1;
					TempEmail := SUBSTRING(TempEmail,STRPOS(',TempEmail, ')+1,LEN(TempEmail));
				END LOOP;
				EmailValue := TempEmail;
				INSERT INTO tabEmail
				(
					IsDefault,
					Value
				)
				VALUES
				(
					EmailIsDefault,
					EmailValue
				);
				EmailInfo := SUBSTRING(EmailInfo,STRPOS(EmailInfo, '$')+1,LEN(EmailInfo));
			END LOOP;
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				UserSeq,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Value, IsDefault, NOW(), NOW() FROM tabEmail;
		ELSE
			DELETE FROM ContactsEmail WHERE RegUserNo = contacts_saveaddressinfo_web.userno And UserSeq = contacts_saveaddressinfo_web.seq;
		END IF;
		-- ============================================
		-- 회사
		-- ============================================
		CREATE TEMP TABLE tabcompany (IsDefault CHAR(1), Company varchar(50), Depart varchar(50), Position varchar(50)) ON COMMIT DROP;



		ChkCompanyInfo := REPLACE(CompanyInfo,',','');
		IF LEN(ChkCompanyInfo) > 0 THEN
			CompanyInfo := contacts_saveaddressinfo_web.companyinfo || '$';
			-- Row 분리
			WHILE STRPOS(CompanyInfo, '$') > 0 LOOP

				TempCompany := SUBSTRING(CompanyInfo,0,STRPOS(CompanyInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempCompany, ') > 0 LOOP
					IF CompanyCnt = 0 THEN
						CompanyIsDefault := SUBSTRING(TempCompany,0,STRPOS(',TempCompany, '));
					ELSIF CompanyCnt = 1 THEN
						CompanyName := SUBSTRING(TempCompany,0,STRPOS(',TempCompany, '));
					ELSIF CompanyCnt = 2 THEN
						Depart := SUBSTRING(TempCompany,0,STRPOS(',TempCompany, '));
					CompanyCnt := CompanyCnt + 1;
					TempCompany := SUBSTRING(TempCompany,STRPOS(',TempCompany, ')+1,LEN(TempCompany));
				END LOOP;
				Position := TempCompany;
				INSERT INTO tabCompany
				(
					IsDefault,
					Company,
					Depart,
					Position
				)
				VALUES
				(
					CompanyIsDefault,
					CompanyName,
					Depart,
					Position
				);
				CompanyInfo := SUBSTRING(CompanyInfo,STRPOS(CompanyInfo, '$')+1,LEN(CompanyInfo));
			END LOOP;
			INSERT INTO ContactsCompany
			(
				RegUserNo,
				UserSeq,
				Company,
				Depart,
				Position,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Company, Depart, Position, IsDefault, NOW(), NOW() FROM tabCompany;
		ELSE
			DELETE FROM ContactsCompany WHERE RegUserNo = contacts_saveaddressinfo_web.userno And UserSeq = contacts_saveaddressinfo_web.seq;
		END IF;
		-- ============================================
		-- 주소
		-- ============================================
		CREATE TEMP TABLE tabaddr (IsDefault CHAR(1), Type integer, TypeName varchar(50), ZipCode1 varchar(5), ZipCode2 varchar(5), Address varchar(500),Latitude float,Longitude float) ON COMMIT DROP;



		ChkAddrInfo := REPLACE(AddressInfo,'#','');
		IF LEN(ChkAddrInfo) > 0 THEN
			AddressInfo := contacts_saveaddressinfo_web.addressinfo || '$';
			-- Row 분리
			WHILE STRPOS(AddressInfo, '$') > 0 LOOP

				TempAddr := SUBSTRING(AddressInfo,0,STRPOS(AddressInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempAddr, '#') > 0 LOOP

					IF AddrCnt = 0 THEN
						AddrIsDefault := SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'));
					ELSIF AddrCnt = 1 THEN
						AddrType := SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'));
					ELSIF AddrCnt = 2 THEN
						AddrTypeName := SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'));
					ELSIF AddrCnt = 3 THEN
						AddrZipCode1 := SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'));
					ELSIF AddrCnt = 4 THEN
						AddrZipCode2 := SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'));
					ELSIF AddrCnt = 5 THEN
						Address := SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'));
					ELSIF AddrCnt = 6 THEN
						Latitude1 := SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'));
					ELSIF AddrCnt = 7 THEN
						Longitude1 := SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'));
					AddrCnt := AddrCnt + 1;
					TempAddr := SUBSTRING(TempAddr,STRPOS(TempAddr, '#')+1,LEN(TempAddr));
				END LOOP;
				--SET Address = TempAddr;

				INSERT INTO tabAddr
				(
					IsDefault,
					Type,
					TypeName,
					ZipCode1,
					ZipCode2,
					Address,
					Latitude,
					Longitude
				)
				VALUES
				(
					AddrIsDefault,
					AddrType,
					AddrTypeName,
					AddrZipCode1,
					AddrZipCode2,
					Address,
					Latitude1,
					Longitude1
				);
				AddressInfo := SUBSTRING(AddressInfo,STRPOS(AddressInfo, '$')+1,LEN(AddressInfo));
			END LOOP;
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault,
				RegDate,
				ModDate,
				Latitude,
				Longitude
			)
			SELECT UserNo, Seq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, NOW(), NOW(),Latitude,Longitude FROM tabAddr;

		ELSE
			DELETE FROM ContactsAddress WHERE RegUserNo = contacts_saveaddressinfo_web.userno And UserSeq = contacts_saveaddressinfo_web.seq;
		END IF;
		-- ============================================
		-- 홈페이지
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabhome (IsDefault CHAR(1), Type integer, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkHomeInfo := REPLACE(HomepageInfo,',','');
		IF LEN(ChkHomeInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			HomepageInfo := contacts_saveaddressinfo_web.homepageinfo || '$';
			-- Row 분리
			WHILE STRPOS(HomepageInfo, '$') > 0 LOOP

				TempHome := SUBSTRING(HomepageInfo,0,STRPOS(HomepageInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempHome, ') > 0 LOOP

					IF HomeCnt = 0 THEN
						HomeIsDefault := SUBSTRING(TempHome,0,STRPOS(',TempHome, '));
					ELSIF HomeCnt = 1 THEN
						HomeType := SUBSTRING(TempHome,0,STRPOS(',TempHome, '));
					ELSIF HomeCnt = 2 THEN
						HomeTypeName := SUBSTRING(TempHome,0,STRPOS(',TempHome, '));
					HomeCnt := HomeCnt + 1;
					TempHome := SUBSTRING(TempHome,STRPOS(',TempHome, ')+1,LEN(TempHome));
				END LOOP;
				HomeValue := TempHome;
				-- 임시테이블에 저장;
				INSERT INTO tabHome
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					HomeIsDefault,
					HomeType,
					HomeTypeName,
					HomeValue
				);
				HomepageInfo := SUBSTRING(HomepageInfo,STRPOS(HomepageInfo, '$')+1,LEN(HomepageInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabHome;
		ELSE
		BEGIN -- 정보가 없으면 기존 정보 삭제;
			DELETE FROM ContactsHomepage WHERE RegUserNo = contacts_saveaddressinfo_web.userno AND UserSeq = contacts_saveaddressinfo_web.seq;
		END IF;
		-- ============================================
		-- 메신저 SNS
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabsns (IsDefault CHAR(1), Type integer, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkSnsInfo := REPLACE(SnsInfo,',','');
		IF LEN(ChkSnsInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			SnsInfo := contacts_saveaddressinfo_web.snsinfo || '$';
			-- Row 분리
			WHILE STRPOS(SnsInfo, '$') > 0 LOOP

				TempSns := SUBSTRING(SnsInfo,0,STRPOS(SnsInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempSns, ') > 0 LOOP

					IF SnsCnt = 0 THEN
						SnsIsDefault := SUBSTRING(TempSns,0,STRPOS(',TempSns, '));
					ELSIF SnsCnt = 1 THEN
						SnsType := SUBSTRING(TempSns,0,STRPOS(',TempSns, '));
					ELSIF SnsCnt = 2 THEN
						SnsTypeName := SUBSTRING(TempSns,0,STRPOS(',TempSns, '));
					SnsCnt := SnsCnt + 1;
					TempSns := SUBSTRING(TempSns,STRPOS(',TempSns, ')+1,LEN(TempSns));
				END LOOP;
				SnsValue := TempSns;
				-- 임시테이블에 저장;
				INSERT INTO tabSns
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					SnsIsDefault,
					SnsType,
					SnsTypeName,
					SnsValue
				);
				SnsInfo := SUBSTRING(SnsInfo,STRPOS(SnsInfo, '$')+1,LEN(SnsInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsSns
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabSns;
		ELSE
		BEGIN -- 정보가 없으면 기존 정보 삭제;
			DELETE FROM ContactsSns WHERE RegUserNo = contacts_saveaddressinfo_web.userno AND UserSeq = contacts_saveaddressinfo_web.seq;

		-- ============================================
		-- 그룹관련
		-- ============================================
		CREATE TEMP TABLE tabgroup (GroupNo integer, UserSeq integer) ON COMMIT DROP;



		ChkGroupInfo := REPLACE(GroupInfo,',','');
		IF LEN(ChkGroupInfo) > 0 THEN
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo_web.seq;
			-- 정보가 존재하면 끝에 , 추가;
			GroupInfo := contacts_saveaddressinfo_web.groupinfo || ',';
			WHILE STRPOS(',GroupInfo, ') > 0 LOOP
				GroupNo := SUBSTRING(GroupInfo,0,STRPOS(',GroupInfo, '));
				--if((select count(*) from ContactsGroupUser where GroupNo=GroupNo and userSeq=Seq) =0)
				--BEGIN
					INSERT INTO tabGroup
					(
						GroupNo,
						UserSeq
					)
					VALUES
					(
						GroupNo,
						Seq
					);
				--END;

				GroupCnt := GroupCnt + 1;
				GroupInfo := SUBSTRING(GroupInfo,STRPOS(',GroupInfo, ')+1,LEN(GroupInfo));
			END LOOP;

			INSERT INTO ContactsGroupUser
			(
				GroupNo,
				UserSeq,
				RegUserNo,
				RegDate,
				ModDate
			)
			SELECT GroupNo, UserSeq, UserNo, NOW(), NOW() FROM tabGroup;
		ELSE
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo_web.seq;
		END IF;

		IF @ERROR <> 0 THEN

		END IF;

	ELSE

		-- ============================================
		-- 수정전에 히스토리 저장 처리
		-- ============================================
		EXEC public."Contacts_SaveContactsHistory" UserNo, Seq, 'UPD';
		-- ============================================
		-- 주소록 기본 저장
		-- ============================================;
		UPDATE ContactsUser
		SET
			FirstName = contacts_saveaddressinfo_web.firstname,
			LastName = contacts_saveaddressinfo_web.lastname,
			CallName = contacts_saveaddressinfo_web.callname,
			Memo = contacts_saveaddressinfo_web.memo,
			Share = contacts_saveaddressinfo_web.share,
			Photo = contacts_saveaddressinfo_web.photo,
			Important = contacts_saveaddressinfo_web.important,
			ModDate = NOW()
		WHERE Seq = contacts_saveaddressinfo_web.seq;


		CREATE TEMP TABLE tabnumberup (IsDefault CHAR(1), Type integer, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkTelInfoUp := REPLACE(TelInfo,',','');
		DELETE FROM ContactsNumber WHERE  UserSeq = contacts_saveaddressinfo_web.seq; -- and RegUserNo = UserNo

		IF LEN(ChkTelInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 전화정보가 존재하면 끝에 $ 추가;
			TelInfo := contacts_saveaddressinfo_web.telinfo || '$';
			-- Row 분리
			WHILE STRPOS(TelInfo, '$') > 0 LOOP

				TempTelUp := SUBSTRING(TelInfo,0,STRPOS(TelInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempTelUp, ') > 0 LOOP

					IF TelCntUp = 0 THEN
						TelIsDefaultUp := SUBSTRING(TempTelUp,0,STRPOS(',TempTelUp, '));
					ELSIF TelCntUp = 1 THEN
						TelTypeUp := SUBSTRING(TempTelUp,0,STRPOS(',TempTelUp, '));
					ELSIF TelCntUp = 2 THEN
						TelTypeNameUp := SUBSTRING(TempTelUp,0,STRPOS(',TempTelUp, '));
					TelCntUp := TelCntUp + 1;
					TempTelUp := SUBSTRING(TempTelUp,STRPOS(',TempTelUp, ')+1,LEN(TempTelUp));
				END LOOP;
				TelValueUp := TempTelUp;
				-- 임시테이블에 저장;
				INSERT INTO tabNumberUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					TelIsDefaultUp,
					TelTypeUp,
					TelTypeNameUp,
					TelValueUp
				);
				TelInfo := SUBSTRING(TelInfo,STRPOS(TelInfo, '$')+1,LEN(TelInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabNumberUp;
		END IF;

		-- ============================================
		-- 이메일
		-- ============================================
		CREATE TEMP TABLE tabemailup (IsDefault CHAR(1), Value varchar(50)) ON COMMIT DROP;



		ChkEmailInfoUp := REPLACE(EmailInfo,',','');
		DELETE FROM ContactsEmail WHERE  UserSeq = contacts_saveaddressinfo_web.seq; -- and RegUserNo = UserNo

		IF LEN(ChkEmailInfoUp) > 0 THEN
			EmailInfo := contacts_saveaddressinfo_web.emailinfo || '$';
			-- Row 분리
			WHILE STRPOS(EmailInfo, '$') > 0 LOOP

				TempEmailUp := SUBSTRING(EmailInfo,0,STRPOS(EmailInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempEmailUp, ') > 0 LOOP
					IF EmailCntUp = 0 THEN
						EmailIsDefaultUp := SUBSTRING(TempEmailUp,0,STRPOS(',TempEmailUp, '));
					EmailCntUp := EmailCntUp + 1;
					TempEmailUp := SUBSTRING(TempEmailUp,STRPOS(',TempEmailUp, ')+1,LEN(TempEmailUp));
				END LOOP;
				EmailValueUp := TempEmailUp;
				INSERT INTO tabEmailUp
				(
					IsDefault,
					Value
				)
				VALUES
				(
					EmailIsDefaultUp,
					EmailValueUp
				);
				EmailInfo := SUBSTRING(EmailInfo,STRPOS(EmailInfo, '$')+1,LEN(EmailInfo));
			END LOOP;
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				UserSeq,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Value, IsDefault, NOW(), NOW() FROM tabEmailUp;
		END IF;

		-- ============================================
		-- 회사
		-- ============================================
		CREATE TEMP TABLE tabcompanyup (IsDefault CHAR(1), Company varchar(50), Depart varchar(50), Position varchar(50)) ON COMMIT DROP;



		ChkCompanyInfoUp := REPLACE(CompanyInfo,',','');
		DELETE FROM ContactsCompany WHERE  UserSeq = contacts_saveaddressinfo_web.seq; -- and RegUserNo = UserNo

		IF LEN(ChkCompanyInfoUp) > 0 THEN
			CompanyInfo := contacts_saveaddressinfo_web.companyinfo || '$';
			-- Row 분리
			WHILE STRPOS(CompanyInfo, '$') > 0 LOOP

				TempCompanyUp := SUBSTRING(CompanyInfo,0,STRPOS(CompanyInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempCompanyUp, ') > 0 LOOP
					IF CompanyCntUp = 0 THEN
						CompanyIsDefaultUp := SUBSTRING(TempCompanyUp,0,STRPOS(',TempCompanyUp, '));
					ELSIF CompanyCntUp = 1 THEN
						CompanyNameUp := SUBSTRING(TempCompanyUp,0,STRPOS(',TempCompanyUp, '));
					ELSIF CompanyCntUp = 2 THEN
						DepartUp := SUBSTRING(TempCompanyUp,0,STRPOS(',TempCompanyUp, '));
					CompanyCntUp := CompanyCntUp + 1;
					TempCompanyUp := SUBSTRING(TempCompanyUp,STRPOS(',TempCompanyUp, ')+1,LEN(TempCompanyUp));
				END LOOP;
				PositionUp := TempCompanyUp;
				INSERT INTO tabCompanyUp
				(
					IsDefault,
					Company,
					Depart,
					Position
				)
				VALUES
				(
					CompanyIsDefaultUp,
					CompanyNameUp,
					DepartUp,
					PositionUp
				);
				CompanyInfo := SUBSTRING(CompanyInfo,STRPOS(CompanyInfo, '$')+1,LEN(CompanyInfo));
			END LOOP;
			INSERT INTO ContactsCompany
			(
				RegUserNo,
				UserSeq,
				Company,
				Depart,
				Position,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Company, Depart, Position, IsDefault, NOW(), NOW() FROM tabCompanyUp;
		END IF;
		-- ============================================
		-- 주소
		-- ============================================
		CREATE TEMP TABLE tabaddrup (IsDefault CHAR(1), Type integer, TypeName varchar(50), ZipCode1 varchar(5), ZipCode2 varchar(5), Address varchar(500),Latitude float,Longitude float) ON COMMIT DROP;



		ChkAddrInfoUp := REPLACE(AddressInfo,'#','');
		DELETE FROM ContactsAddress WHERE  UserSeq = contacts_saveaddressinfo_web.seq; -- and RegUserNo = UserNo

		IF LEN(ChkAddrInfoUp) > 0 THEN
			AddressInfo := contacts_saveaddressinfo_web.addressinfo || '$';
			-- Row 분리
			WHILE STRPOS(AddressInfo, '$') > 0 LOOP

				TempAddrUp := SUBSTRING(AddressInfo,0,STRPOS(AddressInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempAddrUp, '#') > 0 LOOP
					IF AddrCntUp = 0 THEN
						AddrIsDefaultUp := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'));
					ELSIF AddrCntUp = 1 THEN
						AddrTypeUp := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'));
					ELSIF AddrCntUp = 2 THEN
						AddrTypeNameUp := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'));
					ELSIF AddrCntUp = 3 THEN
						AddrZipCode1Up := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'));
					ELSIF AddrCntUp = 4 THEN
						AddrZipCode2Up := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'));
					ELSIF AddrCntUp = 5 THEN
						AddressUp := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'));
					ELSIF AddrCntUp = 6 THEN
						Latitude2 := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'));
					ELSIF AddrCntUp = 7 THEN
						Longitude2 := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'));
					AddrCntUp := AddrCntUp + 1;
					TempAddrUp := SUBSTRING(TempAddrUp,STRPOS(TempAddrUp, '#')+1,LEN(TempAddrUp));
				END LOOP;
				--SET AddressUp = TempAddrUp;

				INSERT INTO tabAddrUp
				(
					IsDefault,
					Type,
					TypeName,
					ZipCode1,
					ZipCode2,
					Address,
					Latitude,
					Longitude
				)
				VALUES
				(
					AddrIsDefaultUp,
					AddrTypeUp,
					AddrTypeNameUp,
					AddrZipCode1Up,
					AddrZipCode2Up,
					AddressUp,
					Latitude2,
					Longitude2
				);
				AddressInfo := SUBSTRING(AddressInfo,STRPOS(AddressInfo, '$')+1,LEN(AddressInfo));
			END LOOP;
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault,
				RegDate,
				ModDate,
				Latitude,
				Longitude
			)
			SELECT UserNo, Seq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, NOW(), NOW(),Latitude,Longitude FROM tabAddrUp;
		END IF;

		-- ============================================
		-- 홈페이지
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabhomeup (IsDefault CHAR(1), Type integer, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkHomeInfoUp := REPLACE(HomepageInfo,',','');
		DELETE FROM ContactsHomepage WHERE UserSeq = contacts_saveaddressinfo_web.seq; -- and RegUserNo = UserNo

		IF LEN(ChkHomeInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			HomepageInfo := contacts_saveaddressinfo_web.homepageinfo || '$';
			-- Row 분리
			WHILE STRPOS(HomepageInfo, '$') > 0 LOOP

				TempHomeUp := SUBSTRING(HomepageInfo,0,STRPOS(HomepageInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempHomeUp, ') > 0 LOOP

					IF HomeCntUp = 0 THEN
						HomeIsDefaultUp := SUBSTRING(TempHomeUp,0,STRPOS(',TempHomeUp, '));
					ELSIF HomeCntUp = 1 THEN
						HomeTypeUp := SUBSTRING(TempHomeUp,0,STRPOS(',TempHomeUp, '));
					ELSIF HomeCntUp = 2 THEN
						HomeTypeNameUp := SUBSTRING(TempHomeUp,0,STRPOS(',TempHomeUp, '));
					HomeCntUp := HomeCntUp + 1;
					TempHomeUp := SUBSTRING(TempHomeUp,STRPOS(',TempHomeUp, ')+1,LEN(TempHomeUp));
				END LOOP;
				HomeValueUp := TempHomeUp;
				-- 임시테이블에 저장;
				INSERT INTO tabHomeUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					HomeIsDefaultUp,
					HomeTypeUp,
					HomeTypeNameUp,
					HomeValueUp
				);
				HomepageInfo := SUBSTRING(HomepageInfo,STRPOS(HomepageInfo, '$')+1,LEN(HomepageInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabHomeUp;
		END IF;
		-- ============================================
		-- 메신저 SNS
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabsnsup (IsDefault CHAR(1), Type integer, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkSnsInfoUp := REPLACE(SnsInfo,',','');
		DELETE FROM ContactsSns WHERE UserSeq = contacts_saveaddressinfo_web.seq; -- and RegUserNo = UserNo

		IF LEN(ChkSnsInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			SnsInfo := contacts_saveaddressinfo_web.snsinfo || '$';
			-- Row 분리
			WHILE STRPOS(SnsInfo, '$') > 0 LOOP

				TempSnsUp := SUBSTRING(SnsInfo,0,STRPOS(SnsInfo, '$'));
				-- Column 분리
				WHILE STRPOS(',TempSnsUp, ') > 0 LOOP

					IF SnsCntUp = 0 THEN
						SnsIsDefaultUp := SUBSTRING(TempSnsUp,0,STRPOS(',TempSnsUp, '));
					ELSIF SnsCntUp = 1 THEN
						SnsTypeUp := SUBSTRING(TempSnsUp,0,STRPOS(',TempSnsUp, '));
					ELSIF SnsCntUp = 2 THEN
						SnsTypeNameUp := SUBSTRING(TempSnsUp,0,STRPOS(',TempSnsUp, '));
					SnsCntUp := SnsCntUp + 1;
					TempSnsUp := SUBSTRING(TempSnsUp,STRPOS(',TempSnsUp, ')+1,LEN(TempSnsUp));
				END LOOP;
				SnsValueUp := TempSnsUp;
				-- 임시테이블에 저장;
				INSERT INTO tabSnsUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					SnsIsDefaultUp,
					SnsTypeUp,
					SnsTypeNameUp,
					SnsValueUp
				);
				SnsInfo := SUBSTRING(SnsInfo,STRPOS(SnsInfo, '$')+1,LEN(SnsInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsSns
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabSnsUp;
		END IF;

		-- ============================================
		-- 그룹관련
		-- ============================================
		CREATE TEMP TABLE tabgroupup (GroupNo integer, UserSeq integer) ON COMMIT DROP;



		ChkGroupInfoUp := REPLACE(GroupInfo,',','');
		IF LEN(ChkGroupInfoUp) > 0 THEN
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo_web.seq;
			-- 정보가 존재하면 끝에 , 추가;
			GroupInfo := contacts_saveaddressinfo_web.groupinfo || ',';
			WHILE STRPOS(',GroupInfo, ') > 0 LOOP
				GroupNoUp := SUBSTRING(GroupInfo,0,STRPOS(',GroupInfo, '));
				-- if((SELECT COUNT(*) FROM ContactsGroupUser	WHERE RegUserNo=UserNo AND UserSeq=Seq AND GroupNo=GroupNoUp) >0 )

				IF (select count(*) from ContactsGroupUser where GroupNo=GroupNo and userSeq=contacts_saveaddressinfo_web.seq)=0 THEN
					INSERT INTO tabGroup
					(
						GroupNo,
						UserSeq
					)
					VALUES
					(
						GroupNoUp,
						Seq
					);
				END IF;

				GroupCntUp := GroupCntUp + 1;
				GroupInfo := SUBSTRING(GroupInfo,STRPOS(',GroupInfo, ')+1,LEN(GroupInfo));
			END LOOP;

			INSERT INTO ContactsGroupUser
			(
				GroupNo,
				UserSeq,
				RegUserNo,
				RegDate,
				ModDate
			)
			SELECT GroupNo, UserSeq, UserNo, NOW(), NOW() FROM tabGroup;
		ELSE
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo_web.seq;
		END IF;
		IF @ERROR <> 0 THEN

		END IF;


		RETURN QUERY
		select Seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.