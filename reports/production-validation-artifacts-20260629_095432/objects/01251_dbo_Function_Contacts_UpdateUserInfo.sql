-- ─── FUNCTION: contacts_updateuserinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updateuserinfo(character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updateuserinfo(
    firstname character varying DEFAULT '대표',
    photo character varying DEFAULT '',
    userno integer DEFAULT 70,
    listgroup integer DEFAULT 1028
) RETURNS TABLE(
    groupno text,
    userseq text,
    userno text,
    col4 text,
    col5 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    chktelinfo character varying;
    temptel character varying;
    telisdefault integer;
    teltype smallint;
    teltypename character varying;
    telvalue character varying;
    chkemailinfo character varying;
    tempemail character varying;
    emailisdefault integer;
    emailvalue character varying;
    chkcompanyinfo character varying;
    tempcompany character varying;
    companyisdefault integer;
    companyname character varying;
    depart character varying;
    position character varying;
    chkaddrinfo character varying;
    tempaddr character varying;
    addrisdefault integer;
    addrtype smallint;
    addrtypename character varying;
    addrzipcode1 character varying;
    addrzipcode2 character varying;
    address character varying;
    latitude1 double precision;
    longitude1 double precision;
    chkhomeinfo character varying;
    temphome character varying;
    homeisdefault integer;
    hometype smallint;
    hometypename character varying;
    homevalue character varying;
    chksnsinfo character varying;
    tempsns character varying;
    snsisdefault integer;
    snstype smallint;
    snstypename character varying;
    snsvalue character varying;
    chktelinfoup character varying;
    temptelup character varying;
    telisdefaultup integer;
    teltypeup smallint;
    teltypenameup character varying;
    telvalueup character varying;
    chkemailinfoup character varying;
    tempemailup character varying;
    emailisdefaultup integer;
    emailvalueup character varying;
    chkcompanyinfoup character varying;
    tempcompanyup character varying;
    companyisdefaultup integer;
    companynameup character varying;
    departup character varying;
    positionup character varying;
    chkaddrinfoup character varying;
    tempaddrup character varying;
    addrisdefaultup integer;
    addrtypeup smallint;
    addrtypenameup character varying;
    addrzipcode1up character varying;
    addrzipcode2up character varying;
    addressup character varying;
    latitude2 double precision;
    longitude2 double precision;
    chkhomeinfoup character varying;
    temphomeup character varying;
    homeisdefaultup integer;
    hometypeup smallint;
    hometypenameup character varying;
    homevalueup character varying;
    chksnsinfoup character varying;
    tempsnsup character varying;
    snsisdefaultup integer;
    snstypeup smallint;
    snstypenameup character varying;
    snsvalueup character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Seq = 0
	BEGIN
		BEGIN TRAN
		-- ============================================
		-- 주소록 기본 저장
		-- ============================================;
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
		)
		SET Seq = lastval()			
		
		-- ===========================================
		EXEC Contacts_InsertListGroupContact Seq,Listgroup
		
		-- ============================================
		-- 전화번호
		-- ============================================
		-- 임시테이블 생성

		-- 체크데이터 생성

		SET ChkTelInfo = REPLACE(TelInfo,',','')
		
		IF LEN(ChkTelInfo) > 0 -- 값이 존재하는지 체크
		BEGIN
			-- 전화정보가 존재하면 끝에 $ 추가
			SET TelInfo = TelInfo || '$'
			-- Row 분리 
			WHILE STRPOS(TelInfo, '$') > 0
			BEGIN

				SET TempTel = SUBSTRING(TelInfo,0,STRPOS(TelInfo, '$'))
				
				--SELECT TempTel AS TempTel
				





				-- Column 분리
				WHILE STRPOS(',TempTel, ') > 0
				BEGIN
					
					IF TelCnt = 0
						--SET TelIsDefault = SUBSTRING(TempTel,0,STRPOS(',TempTel, '))
						SET TelIsDefault = 1
					ELSE IF TelCnt = 1
						SET TelType = SUBSTRING(TempTel,0,STRPOS(',TempTel, '))
					ELSE IF TelCnt = 2
						SET TelTypeName = SUBSTRING(TempTel,0,STRPOS(',TempTel, '))
						
					SET TelCnt = TelCnt + 1
					SET TempTel = SUBSTRING(TempTel,STRPOS(',TempTel, ')+1,LEN(TempTel))
				END
				SET TelValue = TempTel
				
				-- 임시테이블에 저장;
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
				)
				SET TelInfo = SUBSTRING(TelInfo,STRPOS(TelInfo, '$')+1,LEN(TelInfo))
			END
			-- 최종 저장;
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
			RETURN QUERY
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabNumber
		END
		ELSE
		BEGIN -- 정보가 없으면 기존 정보 삭제;
			DELETE FROM ContactsNumber WHERE RegUserNo = contacts_updateuserinfo.userno AND UserSeq = Seq
		END
		-- ============================================
		-- 이메일
		-- ============================================

		

		SET ChkEmailInfo = REPLACE(EmailInfo,',','')
		
		IF LEN(ChkEmailInfo) > 0
		BEGIN
			SET EmailInfo = EmailInfo || '$'
			-- Row 분리
			WHILE STRPOS(EmailInfo, '$') > 0
			BEGIN

				SET TempEmail = SUBSTRING(EmailInfo,0,STRPOS(EmailInfo, '$'))
				



				
				-- Column 분리
				WHILE STRPOS(',TempEmail, ') > 0
				BEGIN
					IF EmailCnt = 0
						SET EmailIsDefault = SUBSTRING(TempEmail,0,STRPOS(',TempEmail, '))
						
					SET EmailCnt = EmailCnt + 1;
					SET TempEmail = SUBSTRING(TempEmail,STRPOS(',TempEmail, ')+1,LEN(TempEmail))
				END
				SET EmailValue = TempEmail
				
				INSERT INTO tabEmail
				(
					IsDefault,
					Value
				)
				VALUES
				(
					EmailIsDefault,
					EmailValue
				)
				SET EmailInfo = SUBSTRING(EmailInfo,STRPOS(EmailInfo, '$')+1,LEN(EmailInfo))
			END;
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				UserSeq,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			RETURN QUERY
			SELECT UserNo, Seq, Value, IsDefault, NOW(), NOW() FROM tabEmail
		END
		ELSE
		BEGIN;
			DELETE FROM ContactsEmail WHERE RegUserNo = contacts_updateuserinfo.userno And UserSeq = Seq
		END
		-- ============================================
		-- 회사
		-- ============================================

		

		SET ChkCompanyInfo = REPLACE(CompanyInfo,',','')
		
		IF LEN(ChkCompanyInfo) > 0
		BEGIN
			SET CompanyInfo = CompanyInfo || '$'
			-- Row 분리
			WHILE STRPOS(CompanyInfo, '$') > 0
			BEGIN

				SET TempCompany = SUBSTRING(CompanyInfo,0,STRPOS(CompanyInfo, '$'))
				





				
				-- Column 분리
				WHILE STRPOS(',TempCompany, ') > 0
				BEGIN
					IF CompanyCnt = 0
						SET CompanyIsDefault = SUBSTRING(TempCompany,0,STRPOS(',TempCompany, '))
					ELSE IF CompanyCnt = 1
						SET CompanyName = SUBSTRING(TempCompany,0,STRPOS(',TempCompany, '))
					ELSE IF CompanyCnt = 2
						SET Depart = SUBSTRING(TempCompany,0,STRPOS(',TempCompany, '))
						
					SET CompanyCnt = CompanyCnt + 1;
					SET TempCompany = SUBSTRING(TempCompany,STRPOS(',TempCompany, ')+1,LEN(TempCompany))
				END
				SET Position = TempCompany;
				
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
				)
				SET CompanyInfo = SUBSTRING(CompanyInfo,STRPOS(CompanyInfo, '$')+1,LEN(CompanyInfo))
			END;
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
			RETURN QUERY
			SELECT UserNo, Seq, Company, Depart, Position, IsDefault, NOW(), NOW() FROM tabCompany
		END
		ELSE
		BEGIN;
			DELETE FROM ContactsCompany WHERE RegUserNo = contacts_updateuserinfo.userno And UserSeq = Seq
		END
		-- ============================================
		-- 주소
		-- ============================================

		

		SET ChkAddrInfo = REPLACE(AddressInfo,'#','')
		
		IF LEN(ChkAddrInfo) > 0
		BEGIN
			SET AddressInfo = AddressInfo || '$'
			-- Row 분리
			WHILE STRPOS(AddressInfo, '$') > 0
			BEGIN

				SET TempAddr = SUBSTRING(AddressInfo,0,STRPOS(AddressInfo, '$'))
				









				-- Column 분리
				WHILE STRPOS(TempAddr, '#') > 0
				BEGIN
				
					IF AddrCnt = 0
						SET AddrIsDefault = SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'))
					ELSE IF AddrCnt = 1
						SET AddrType = SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'))
					ELSE IF AddrCnt = 2
						SET AddrTypeName = SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'))
					ELSE IF AddrCnt = 3
						SET AddrZipCode1 = SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'))
					ELSE IF AddrCnt = 4
						SET AddrZipCode2 = SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'))
					ELSE IF AddrCnt = 5
						SET  Address = SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'))
					ELSE IF AddrCnt = 6
						SET  Latitude1 = SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'))
					ELSE IF AddrCnt = 7
						SET  Longitude1 = SUBSTRING(TempAddr,0,STRPOS(TempAddr, '#'))					
							
					SET AddrCnt = AddrCnt + 1;
					SET TempAddr = SUBSTRING(TempAddr,STRPOS(TempAddr, '#')+1,LEN(TempAddr)) 
					
				END
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
				)
				SET AddressInfo = SUBSTRING(AddressInfo,STRPOS(AddressInfo, '$')+1,LEN(AddressInfo))
		
			END;
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
			RETURN QUERY
			SELECT UserNo, Seq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, NOW(), NOW(),Latitude,Longitude FROM tabAddr

		END
		ELSE
		BEGIN;
			DELETE FROM ContactsAddress WHERE RegUserNo = contacts_updateuserinfo.userno And UserSeq = Seq
		END
		-- ============================================
		-- 홈페이지
		-- ============================================
		-- 임시테이블 생성

		-- 체크데이터 생성

		SET ChkHomeInfo = REPLACE(HomepageInfo,',','')
		
		IF LEN(ChkHomeInfo) > 0 -- 값이 존재하는지 체크
		BEGIN
			-- 정보가 존재하면 끝에 $ 추가
			SET HomepageInfo = HomepageInfo || '$'
			-- Row 분리 
			WHILE STRPOS(HomepageInfo, '$') > 0
			BEGIN

				SET TempHome = SUBSTRING(HomepageInfo,0,STRPOS(HomepageInfo, '$'))
			
				





				-- Column 분리
				WHILE STRPOS(',TempHome, ') > 0
				BEGIN
					
					IF HomeCnt = 0
						SET HomeIsDefault = SUBSTRING(TempHome,0,STRPOS(',TempHome, '))
					ELSE IF HomeCnt = 1
						SET HomeType = SUBSTRING(TempHome,0,STRPOS(',TempHome, '))
					ELSE IF HomeCnt = 2
						SET HomeTypeName = SUBSTRING(TempHome,0,STRPOS(',TempHome, '))
						
					SET HomeCnt = HomeCnt + 1
					SET TempHome = SUBSTRING(TempHome,STRPOS(',TempHome, ')+1,LEN(TempHome))
				END
				SET HomeValue = TempHome
				
				-- 임시테이블에 저장;
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
				)
				SET HomepageInfo = SUBSTRING(HomepageInfo,STRPOS(HomepageInfo, '$')+1,LEN(HomepageInfo))
			END
			-- 최종 저장;
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
			RETURN QUERY
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabHome
		END
		ELSE
		BEGIN -- 정보가 없으면 기존 정보 삭제;
			DELETE FROM ContactsHomepage WHERE RegUserNo = contacts_updateuserinfo.userno AND UserSeq = Seq
		END
		-- ============================================
		-- 메신저 SNS
		-- ============================================
		-- 임시테이블 생성

		-- 체크데이터 생성

		SET ChkSnsInfo = REPLACE(SnsInfo,',','')
		
		IF LEN(ChkSnsInfo) > 0 -- 값이 존재하는지 체크
		BEGIN
			-- 정보가 존재하면 끝에 $ 추가
			SET SnsInfo = SnsInfo || '$'
			-- Row 분리 
			WHILE STRPOS(SnsInfo, '$') > 0
			BEGIN

				SET TempSns = SUBSTRING(SnsInfo,0,STRPOS(SnsInfo, '$'))
			
				





				-- Column 분리
				WHILE STRPOS(',TempSns, ') > 0
				BEGIN
					
					IF SnsCnt = 0
						SET SnsIsDefault = SUBSTRING(TempSns,0,STRPOS(',TempSns, '))
					ELSE IF SnsCnt = 1
						SET SnsType = SUBSTRING(TempSns,0,STRPOS(',TempSns, '))
					ELSE IF SnsCnt = 2
						SET SnsTypeName = SUBSTRING(TempSns,0,STRPOS(',TempSns, '))
						
					SET SnsCnt = SnsCnt + 1
					SET TempSns = SUBSTRING(TempSns,STRPOS(',TempSns, ')+1,LEN(TempSns))
				END
				SET SnsValue = TempSns
				
				-- 임시테이블에 저장;
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
				)
				SET SnsInfo = SUBSTRING(SnsInfo,STRPOS(SnsInfo, '$')+1,LEN(SnsInfo))
			END
			-- 최종 저장;
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
			RETURN QUERY
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabSns
		END
		ELSE
		BEGIN -- 정보가 없으면 기존 정보 삭제;
			DELETE FROM ContactsSns WHERE RegUserNo = contacts_updateuserinfo.userno AND UserSeq = Seq
		END
		---- ============================================
		---- 그룹관련
		---- ============================================
		--DECLARE tabGroup TABLE(GroupNo INT, UserSeq INT)
		
		--DECLARE ChkGroupInfo text
		
		--SET ChkGroupInfo = REPLACE(GroupInfo,',','')
		
		--IF LEN(ChkGroupInfo) > 0
		--BEGIN
		--	DELETE FROM ContactsGroupUser WHERE UserSeq = Seq
		--	-- 정보가 존재하면 끝에 , 추가
		--	SET GroupInfo = GroupInfo || ','
			
		--	DECLARE GroupCnt INT = 0
		--	DECLARE GroupNo INT;
		--	WHILE STRPOS(',GroupInfo, ') > 0
		--	BEGIN
		--		SET GroupNo = SUBSTRING(GroupInfo,0,STRPOS(',GroupInfo, '))
				
		--		--if((select count(*) from ContactsGroupUser where GroupNo=GroupNo and userSeq=Seq) =0)
		--		--BEGIN
		--			INSERT INTO tabGroup
		--			(
		--				GroupNo,
		--				UserSeq
		--			)
		--			VALUES
		--			(
		--				GroupNo,
		--				Seq
		--			)
		--		--END
					
		--		SET GroupCnt = GroupCnt + 1
		--		SET GroupInfo = SUBSTRING(GroupInfo,STRPOS(',GroupInfo, ')+1,LEN(GroupInfo))
		--	END
			
		--	INSERT INTO ContactsGroupUser
		--	(
		--		GroupNo,
		--		UserSeq,
		--		RegUserNo,
		--		RegDate,
		--		ModDate
		--	)
		--	SELECT GroupNo, UserSeq, UserNo, NOW(), NOW() FROM tabGroup
		--END
		--ELSE
		--BEGIN
		--	DELETE FROM ContactsGroupUser WHERE UserSeq = Seq
		--END
		
		IF @ERROR <> 0
		BEGIN
			ROLLBACK TRAN
		END
		COMMIT TRAN
	END
	ELSE
	BEGIN
		BEGIN TRAN
		-- ============================================
		-- 수정전에 히스토리 저장 처리
		-- ============================================
		EXEC public."Contacts_SaveContactsHistory" UserNo, Seq, 'UPD'
		-- ============================================
		-- 주소록 기본 저장
		-- ============================================;
		UPDATE ContactsUser
		SET
			FirstName = contacts_updateuserinfo.firstname,
			LastName = LastName,
			CallName = CallName,
			Memo = Memo,
			Share = Share,
			Photo = contacts_updateuserinfo.photo,
			Important = Important,
			ModDate = NOW()
		WHERE Seq = Seq
	
 

		-- 체크데이터 생성

		SET ChkTelInfoUp = REPLACE(TelInfo,',','')
		
		DELETE FROM ContactsNumber WHERE  UserSeq = Seq  -- and RegUserNo = UserNo
		
		IF LEN(ChkTelInfoUp) > 0 -- 값이 존재하는지 체크
		BEGIN
			-- 전화정보가 존재하면 끝에 $ 추가
			SET TelInfo = TelInfo || '$'
			-- Row 분리 
			WHILE STRPOS(TelInfo, '$') > 0
			BEGIN

				SET TempTelUp = SUBSTRING(TelInfo,0,STRPOS(TelInfo, '$'))
				
				





				-- Column 분리
				WHILE STRPOS(',TempTelUp, ') > 0
				BEGIN
					
					IF TelCntUp = 0
						SET TelIsDefaultUp = SUBSTRING(TempTelUp,0,STRPOS(',TempTelUp, '))
					ELSE IF TelCntUp = 1
						SET TelTypeUp = SUBSTRING(TempTelUp,0,STRPOS(',TempTelUp, '))
					ELSE IF TelCntUp = 2
						SET TelTypeNameUp = SUBSTRING(TempTelUp,0,STRPOS(',TempTelUp, '))
						
					SET TelCntUp = TelCntUp + 1
					SET TempTelUp = SUBSTRING(TempTelUp,STRPOS(',TempTelUp, ')+1,LEN(TempTelUp))
				END
				SET TelValueUp = TempTelUp
				
				-- 임시테이블에 저장;
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
				)
				SET TelInfo = SUBSTRING(TelInfo,STRPOS(TelInfo, '$')+1,LEN(TelInfo))
			END
			-- 최종 저장;
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
			RETURN QUERY
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabNumberUp
		END
		
		-- ============================================
		-- 이메일
		-- ============================================

		

		SET ChkEmailInfoUp = REPLACE(EmailInfo,',','')
		
		DELETE FROM ContactsEmail WHERE  UserSeq = Seq -- and RegUserNo = UserNo
		
		IF LEN(ChkEmailInfoUp) > 0
		BEGIN
			SET EmailInfo = EmailInfo || '$'
			-- Row 분리
			WHILE STRPOS(EmailInfo, '$') > 0
			BEGIN

				SET TempEmailUp = SUBSTRING(EmailInfo,0,STRPOS(EmailInfo, '$'))
				



				
				-- Column 분리
				WHILE STRPOS(',TempEmailUp, ') > 0
				BEGIN
					IF EmailCntUp = 0
						SET EmailIsDefaultUp = SUBSTRING(TempEmailUp,0,STRPOS(',TempEmailUp, '))
						
					SET EmailCntUp = EmailCntUp + 1;
					SET TempEmailUp = SUBSTRING(TempEmailUp,STRPOS(',TempEmailUp, ')+1,LEN(TempEmailUp))
				END
				SET EmailValueUp = TempEmailUp
				
				INSERT INTO tabEmailUp
				(
					IsDefault,
					Value
				)
				VALUES
				(
					EmailIsDefaultUp,
					EmailValueUp
				)
				SET EmailInfo = SUBSTRING(EmailInfo,STRPOS(EmailInfo, '$')+1,LEN(EmailInfo))
			END;
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				UserSeq,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			RETURN QUERY
			SELECT UserNo, Seq, Value, IsDefault, NOW(), NOW() FROM tabEmailUp
		END

		-- ============================================
		-- 회사
		-- ============================================

		

		SET ChkCompanyInfoUp = REPLACE(CompanyInfo,',','')
		
		DELETE FROM ContactsCompany WHERE  UserSeq = Seq  -- and RegUserNo = UserNo
		
		IF LEN(ChkCompanyInfoUp) > 0
		BEGIN
			SET CompanyInfo = CompanyInfo || '$'
			-- Row 분리
			WHILE STRPOS(CompanyInfo, '$') > 0
			BEGIN

				SET TempCompanyUp = SUBSTRING(CompanyInfo,0,STRPOS(CompanyInfo, '$'))
				





				
				-- Column 분리
				WHILE STRPOS(',TempCompanyUp, ') > 0
				BEGIN
					IF CompanyCntUp = 0
						SET CompanyIsDefaultUp = SUBSTRING(TempCompanyUp,0,STRPOS(',TempCompanyUp, '))
					ELSE IF CompanyCntUp = 1
						SET CompanyNameUp = SUBSTRING(TempCompanyUp,0,STRPOS(',TempCompanyUp, '))
					ELSE IF CompanyCntUp = 2
						SET DepartUp = SUBSTRING(TempCompanyUp,0,STRPOS(',TempCompanyUp, '))
						
					SET CompanyCntUp = CompanyCntUp + 1;
					SET TempCompanyUp = SUBSTRING(TempCompanyUp,STRPOS(',TempCompanyUp, ')+1,LEN(TempCompanyUp))
				END
				SET PositionUp = TempCompanyUp;
				
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
				)
				SET CompanyInfo = SUBSTRING(CompanyInfo,STRPOS(CompanyInfo, '$')+1,LEN(CompanyInfo))
			END;
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
			RETURN QUERY
			SELECT UserNo, Seq, Company, Depart, Position, IsDefault, NOW(), NOW() FROM tabCompanyUp
		END
		-- ============================================
		-- 주소
		-- ============================================

		

		SET ChkAddrInfoUp = REPLACE(AddressInfo,'#','')
		
		DELETE FROM ContactsAddress WHERE  UserSeq = Seq  -- and RegUserNo = UserNo
		
		IF LEN(ChkAddrInfoUp) > 0
		BEGIN
			SET AddressInfo = AddressInfo || '$'
			-- Row 분리
			WHILE STRPOS(AddressInfo, '$') > 0
			BEGIN

				SET TempAddrUp = SUBSTRING(AddressInfo,0,STRPOS(AddressInfo, '$'))
				









				-- Column 분리
				WHILE STRPOS(TempAddrUp, '#') > 0
				BEGIN
					IF AddrCntUp = 0
						SET AddrIsDefaultUp = SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'))
						
					ELSE IF AddrCntUp = 1
						SET AddrTypeUp = SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'))
					ELSE IF AddrCntUp = 2
						SET AddrTypeNameUp = SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'))
					ELSE IF AddrCntUp = 3
						SET AddrZipCode1Up = SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'))
					ELSE IF AddrCntUp = 4
						SET AddrZipCode2Up = SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'))
					ELSE IF AddrCntUp = 5
						SET AddressUp = SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'))
					ELSE IF AddrCntUp = 6
						SET Latitude2 = SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'))		
					ELSE IF AddrCntUp = 7
						SET Longitude2 = SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, '#'))		
						
					SET AddrCntUp = AddrCntUp + 1;
					SET TempAddrUp = SUBSTRING(TempAddrUp,STRPOS(TempAddrUp, '#')+1,LEN(TempAddrUp))
				END
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
				)
				SET AddressInfo = SUBSTRING(AddressInfo,STRPOS(AddressInfo, '$')+1,LEN(AddressInfo))
			END;
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
			RETURN QUERY
			SELECT UserNo, Seq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, NOW(), NOW(),Latitude,Longitude FROM tabAddrUp
		END
		
		-- ============================================
		-- 홈페이지
		-- ============================================
		-- 임시테이블 생성

		-- 체크데이터 생성

		SET ChkHomeInfoUp = REPLACE(HomepageInfo,',','')
		
		DELETE FROM ContactsHomepage WHERE UserSeq = Seq  -- and RegUserNo = UserNo
		
		IF LEN(ChkHomeInfoUp) > 0 -- 값이 존재하는지 체크
		BEGIN
			-- 정보가 존재하면 끝에 $ 추가
			SET HomepageInfo = HomepageInfo || '$'
			-- Row 분리 
			WHILE STRPOS(HomepageInfo, '$') > 0
			BEGIN

				SET TempHomeUp = SUBSTRING(HomepageInfo,0,STRPOS(HomepageInfo, '$'))
			
				





				-- Column 분리
				WHILE STRPOS(',TempHomeUp, ') > 0
				BEGIN
					
					IF HomeCntUp = 0
						SET HomeIsDefaultUp = SUBSTRING(TempHomeUp,0,STRPOS(',TempHomeUp, '))
					ELSE IF HomeCntUp = 1
						SET HomeTypeUp = SUBSTRING(TempHomeUp,0,STRPOS(',TempHomeUp, '))
					ELSE IF HomeCntUp = 2
						SET HomeTypeNameUp = SUBSTRING(TempHomeUp,0,STRPOS(',TempHomeUp, '))
						
					SET HomeCntUp = HomeCntUp + 1
					SET TempHomeUp = SUBSTRING(TempHomeUp,STRPOS(',TempHomeUp, ')+1,LEN(TempHomeUp))
				END
				SET HomeValueUp = TempHomeUp
				
				-- 임시테이블에 저장;
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
				)
				SET HomepageInfo = SUBSTRING(HomepageInfo,STRPOS(HomepageInfo, '$')+1,LEN(HomepageInfo))
			END
			-- 최종 저장;
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
			RETURN QUERY
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabHomeUp
		END
		-- ============================================
		-- 메신저 SNS
		-- ============================================
		-- 임시테이블 생성

		-- 체크데이터 생성

		SET ChkSnsInfoUp = REPLACE(SnsInfo,',','')
		
		DELETE FROM ContactsSns WHERE UserSeq = Seq  -- and RegUserNo = UserNo
		
		IF LEN(ChkSnsInfoUp) > 0 -- 값이 존재하는지 체크
		BEGIN
			-- 정보가 존재하면 끝에 $ 추가
			SET SnsInfo = SnsInfo || '$'
			-- Row 분리 
			WHILE STRPOS(SnsInfo, '$') > 0
			BEGIN

				SET TempSnsUp = SUBSTRING(SnsInfo,0,STRPOS(SnsInfo, '$'))
			
				





				-- Column 분리
				WHILE STRPOS(',TempSnsUp, ') > 0
				BEGIN
					
					IF SnsCntUp = 0
						SET SnsIsDefaultUp = SUBSTRING(TempSnsUp,0,STRPOS(',TempSnsUp, '))
					ELSE IF SnsCntUp = 1
						SET SnsTypeUp = SUBSTRING(TempSnsUp,0,STRPOS(',TempSnsUp, '))
					ELSE IF SnsCntUp = 2
						SET SnsTypeNameUp = SUBSTRING(TempSnsUp,0,STRPOS(',TempSnsUp, '))
						
					SET SnsCntUp = SnsCntUp + 1
					SET TempSnsUp = SUBSTRING(TempSnsUp,STRPOS(',TempSnsUp, ')+1,LEN(TempSnsUp))
				END
				SET SnsValueUp = TempSnsUp
				
				-- 임시테이블에 저장;
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
				)
				SET SnsInfo = SUBSTRING(SnsInfo,STRPOS(SnsInfo, '$')+1,LEN(SnsInfo))
			END
			-- 최종 저장;
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
			RETURN QUERY
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabSnsUp
		END
		
		-- ============================================
		-- 그룹관련
		-- ============================================
		--DECLARE tabGroupUp TABLE(GroupNo INT, UserSeq INT)
		
		--DECLARE ChkGroupInfoUp text
		
		--SET ChkGroupInfoUp = REPLACE(GroupInfo,',','')
		
		--IF LEN(ChkGroupInfoUp) > 0
		--BEGIN
		--	DELETE FROM ContactsGroupUser WHERE UserSeq = Seq
		--	-- 정보가 존재하면 끝에 , 추가
		--	SET GroupInfo = GroupInfo || ','
			
		--	DECLARE GroupCntUp INT = 0
		--	DECLARE GroupNoUp INT;
		--	WHILE STRPOS(',GroupInfo, ') > 0
		--	BEGIN
		--		SET GroupNoUp = SUBSTRING(GroupInfo,0,STRPOS(',GroupInfo, '))
				
		--		-- if((SELECT COUNT(*) FROM ContactsGroupUser	WHERE RegUserNo=UserNo AND UserSeq=Seq AND GroupNo=GroupNoUp) >0 )

		--		if((select count(*) from ContactsGroupUser where GroupNo=GroupNo and userSeq=Seq)=0)
		--		BEGIN
		--			INSERT INTO tabGroup
		--			(
		--				GroupNo,
		--				UserSeq
		--			)
		--			VALUES
		--			(
		--				GroupNoUp,
		--				Seq
		--			)
		--		END
					
		--		SET GroupCntUp = GroupCntUp + 1
		--		SET GroupInfo = SUBSTRING(GroupInfo,STRPOS(',GroupInfo, ')+1,LEN(GroupInfo))
		--	END
			
		--	INSERT INTO ContactsGroupUser
		--	(
		--		GroupNo,
		--		UserSeq,
		--		RegUserNo,
		--		RegDate,
		--		ModDate
		--	)
		--	SELECT GroupNo, UserSeq, UserNo, NOW(), NOW() FROM tabGroup
		--END
		--ELSE
		--BEGIN
		--	DELETE FROM ContactsGroupUser WHERE UserSeq = Seq
		--END
		IF @ERROR <> 0
		BEGIN
			ROLLBACK TRAN
		END
		COMMIT TRAN
	END
	
		RETURN QUERY
		select Seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
