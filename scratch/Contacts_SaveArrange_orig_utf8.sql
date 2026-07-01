=== ORIGINAL MSSQL DEFINITION FOR Contacts_SaveArrange ===




-- =============================================
-- Author:		허욱
-- Create date: 2014-05-02
-- Description:	중복주소록 정리
-- =============================================
CREATE PROCEDURE [dbo].[Contacts_SaveArrange] 
	-- Add the parameters for the stored procedure here
	@UserNo INT,
	@MainSeqList VARCHAR(MAX), -- 기준이 되는 주소록 
	@NameList VARCHAR(MAX),	-- 기준이름 목록 '기준번호,정리번호$...'
	@EmailList	VARCHAR(MAX), -- 이메일 정리 목록 '기준번호,정리번호,정리순번,병합여부$...'
	@NumberList VARCHAR(MAX) -- 전화번호 정리목록 '기준번호,정리번호,정리순번,병합여부$...'
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	
	DECLARE @TempMainSeqList VARCHAR(MAX)
	DECLARE @TempMainSeqNo INT;
	DECLARE @CheckMainSeqList VARCHAR(MAX)
	DECLARE @TempDelUserSeqList VARCHAR(MAX) = ''
	
	SET @TempMainSeqList = @MainSeqList + ','
	SET @CheckMainSeqList = REPLACE(@TempMainSeqList,',','')
	-- 정리할 주소록이 있는지 검사
	IF LEN(@CheckMainSeqList) > 0
	BEGIN
		BEGIN TRAN
		-- 정리할 주소록 분할 처리
		WHILE CHARINDEX(',',@TempMainSeqList) > 0
		BEGIN
			-- 정리 기준 주소록 번호
			SET @TempMainSeqNo = SUBSTRING(@TempMainSeqList,0,CHARINDEX(',',@TempMainSeqList))
			
			-- 성명 
			DECLARE @TempNameList VARCHAR(MAX)
			DECLARE @TempNameOneList VARCHAR(MAX)
			DECLARE @TempNameOne VARCHAR(MAX)
			DECLARE @TempNameCnt INT
			DECLARE @TempNameMainSeq INT
			DECLARE @TempNameUserSeq INT
			DECLARE @CheckNameList VARCHAR(MAX)
			SET @TempNameList = @NameList + '$'
			SET @CheckNameList = REPLACE(REPLACE(@TempNameList,',',''),'$',',')
			
			IF LEN(@CheckNameList) > 0
			BEGIN
				WHILE CHARINDEX('$',@TempNameList) > 0
				BEGIN

					SET @TempNameOneList = SUBSTRING(@TempNameList,0,CHARINDEX('$',@TempNameList))
					SET @TempNameOneList = @TempNameOneList + ','
					SET @TempNameCnt = 0
					
					WHILE CHARINDEX(',',@TempNameOneList) > 0
					BEGIN
						SET @TempNameOne = SUBSTRING(@TempNameOneList,0,CHARINDEX(',',@TempNameOneList))
						IF @TempNameCnt = 0
							SET @TempNameMainSeq = @TempNameOne
						ELSE IF @TempNameCnt = 1
							SET @TempNameUserSeq = @TempNameOne
						SET @TempNameCnt = @TempNameCnt + 1
						SET @TempNameOneList = SUBSTRING(@TempNameOneList,CHARINDEX(',',@TempNameOneList)+1,LEN(@TempNameOneList))
					END
					
					IF @TempMainSeqNo = @TempNameMainSeq
					BEGIN
					
						UPDATE U
						SET
							U.LastName = S.LastName,
							U.FirstName = S.FirstName
						FROM ContactsUser U, ContactsUser S
						WHERE U.Seq = @TempMainSeqNo
						AND S.Seq = @TempNameUserSeq
					
					END
					
					SET @TempNameList = SUBSTRING(@TempNameList,CHARINDEX('$',@TempNameList)+1,LEN(@TempNameList))
				END
			END
			-- 이메일
			DECLARE @TempEmailList VARCHAR(MAX)
			DECLARE @TempEmailOneList VARCHAR(MAX)
			DECLARE @TempEmailOne VARCHAR(MAX)
			DECLARE @TempEmailCnt INT;
			DECLARE @TempEmailMainSeq INT
			DECLARE @TempEmailUserSeq INT
			DECLARE @TempEmailSeq INT
			DECLARE @TempEmailYN VARCHAR(1)
			DECLARE @CheckEmailList VARCHAR(MAX)
			SET @TempEmailList = @EmailList + '$'
			SET @CheckEmailList = REPLACE(REPLACE(@TempEmailList,',',''),'$','')
			-- // ========================
			-- // 이메일 데이터 체크
			-- // ========================
			IF LEN(@CheckEmailList) > 0
			BEGIN
				WHILE CHARINDEX('$',@TempEmailList) > 0
				BEGIN
					PRINT('이메일 루프')
					SET @TempEmailOneList = SUBSTRING(@TempEmailList,0,CHARINDEX('$',@TempEmailList))
					SET @TempEmailOneList = @TempEmailOneList + ','
					SET @TempEmailCnt = 0
					
					WHILE CHARINDEX(',', @TempEmailOneList) > 0
					BEGIN
						SET @TempEmailOne = SUBSTRING(@TempEmailOneList,0,CHARINDEX(',',@TempEmailOneList))
							
						IF @TempEmailCnt = 0
							SET @TempEmailMainSeq = @TempEmailOne
						ELSE IF @TempEmailCnt = 1
							SET @TempEmailUserSeq = @TempEmailOne
						ELSE IF @TempEmailCnt = 2
							SET @TempEmailSeq = @TempEmailOne
						ELSE IF @TempEmailCnt = 3
							SET @TempEmailYN = @TempEmailOne
							
						SET @TempEmailCnt = @TempEmailCnt +1
						
						SET @TempEmailOneList = SUBSTRING(@TempEmailOneList,CHARINDEX(',',@TempEmailOneList)+1,LEN(@TempEmailOneList))
					END
					-- ========================	
					-- MainSeq가 같은 것만 처리
					-- ========================
					IF @TempMainSeqNo = @TempEmailMainSeq
					BEGIN
						IF @TempMainSeqNo <> @TempEmailUserSeq
						BEGIN
							SET @TempDelUserSeqList += CONVERT(VARCHAR(MAX),@TempEmailUserSeq) + ','
						END
						IF @TempEmailYN = 'Y'
						BEGIN -- Y인 경우 병합처리
							
							DECLARE @TempEmailValue VARCHAR(50)
							
							SELECT @TempEmailValue = Value 
							FROM ContactsEmail WITH (NOLOCK)
							WHERE Seq = @TempEmailSeq
							
							DECLARE @TempEMailCheck INT
							
							SELECT @TempEMailCheck = COUNT(Value)
							FROM ContactsEmail WITH (NOLOCK)
							WHERE UserSeq = @TempEmailMainSeq
							AND Value = @TempEmailValue 
							-- 메인에 존재하지 않으면 업데이트
							IF @TempEMailCheck = 0
							BEGIN
								UPDATE ContactsEmail
								SET
									UserSeq = @TempMainSeqNo,
									IsDefault = 0,
									ModDate = GETDATE()
								WHERE 
									Seq = @TempEmailSeq
								AND UserSeq = @TempEmailUserSeq
							END 
							ELSE IF @TempMainSeqNo <> @TempEmailMainSeq AND @TempEMailCheck > 0
							BEGIN -- 메인의 데이터가 아니면서 존재하는 경우는 삭제
								DELETE FROM ContactsEmail
								WHERE Seq = @TempEmailSeq
								AND UserSeq = @TempEmailUserSeq
							END
						END
						ELSE -- N인 경우 병합하지 않고 삭제
						BEGIN
							DELETE FROM ContactsEmail 
							WHERE Seq = @TempEmailSeq
							AND UserSeq = @TempEmailUserSeq
						END	
					END
					
					SET @TempEmailList = SUBSTRING(@TempEmailList,CHARINDEX('$',@TempEmailList)+1,LEN(@TempEmailList))
				END
			END
			
			-- 전화번호
			DECLARE @TempNumberList VARCHAR(MAX)
			DECLARE @TempNumberOneList VARCHAR(MAX)
			DECLARE @TempNumberOne VARCHAR(MAX)
			DECLARE @TempNumberCnt INT;
			DECLARE @TempNumberMainSeq INT
			DECLARE @TempNumberUserSeq INT
			DECLARE @TempNumberSeq INT
			DECLARE @TempNumberYN VARCHAR(1)
			DECLARE @CheckNumberList VARCHAR(MAX)
			SET @TempNumberList = @NumberList + '$'
			SET @CheckNumberList = REPLACE(REPLACE(@TempNumberList,',',''),'$','')
			-- // ========================
			-- // 전화번호 데이터 체크
			-- // ========================
			IF LEN(@CheckNumberList) > 0
			BEGIN
				WHILE CHARINDEX('$',@TempNumberList) > 0
				BEGIN
					SET @TempNumberOneList = SUBSTRING(@TempNumberList,0,CHARINDEX('$',@TempNumberList))
					SET @TempNumberOneList = @TempNumberOneList + ','
					SET @TempNumberCnt = 0
					
					WHILE CHARINDEX(',', @TempNumberOneList) > 0
					BEGIN
						SET @TempNumberOne = SUBSTRING(@TempNumberOneList,0,CHARINDEX(',',@TempNumberOneList))
							
						IF @TempNumberCnt = 0
							SET @TempNumberMainSeq = @TempNumberOne
						ELSE IF @TempNumberCnt = 1
							SET @TempNumberUserSeq = @TempNumberOne
						ELSE IF @TempNumberCnt = 2
							SET @TempNumberSeq = @TempNumberOne
						ELSE IF @TempNumberCnt = 3
							SET @TempNumberYN = @TempNumberOne
							
						SET @TempNumberCnt = @TempNumberCnt + 1
						SET @TempNumberOneList = SUBSTRING(@TempNumberOneList,CHARINDEX(',',@TempNumberOneList)+1,LEN(@TempNumberOneList))
					END
					-- ========================	
					-- MainSeq가 같은 것만 처리
					-- ========================
					IF @TempMainSeqNo = @TempNumberMainSeq
					BEGIN
						IF @TempMainSeqNo <> @TempNumberUserSeq
						BEGIN
							PRINT(@TempDelUserSeqList)
							SET @TempDelUserSeqList += CONVERT(VARCHAR(MAX),@TempNumberUserSeq) + ','
						END
						IF @TempNumberYN = 'Y'
						BEGIN -- Y인 경우 병합처리
							
							DECLARE @TempNumberValue VARCHAR(50)
							
							SELECT @TempNumberValue = Value 
							FROM ContactsNumber WITH (NOLOCK)
							WHERE Seq = @TempNumberSeq
							
							DECLARE @TempNumberCheck INT
							
							SELECT @TempNumberCheck = COUNT(Value)
							FROM ContactsNumber WITH (NOLOCK)
							WHERE UserSeq = @TempNumberMainSeq
							AND Value = @TempNumberValue 
							-- 메인에 존재하지 않으면 업데이트
							IF @TempNumberCheck = 0
							BEGIN
								UPDATE ContactsNumber
								SET
									UserSeq = @TempMainSeqNo,
									IsDefault = 0,
									ModDate = GETDATE()
								WHERE 
									Seq = @TempNumberSeq
								AND UserSeq = @TempNumberUserSeq
							END 
							ELSE IF @TempMainSeqNo <> @TempNumberMainSeq AND @TempNumberCheck > 0
							BEGIN -- 메인의 데이터가 아니면서 존재하는 경우는 삭제
								DELETE FROM ContactsNumber
								WHERE Seq = @TempNumberSeq
								AND UserSeq = @TempNumberUserSeq
							END
						END
						ELSE -- N인 경우 병합하지 않고 삭제
						BEGIN
							DELETE FROM ContactsNumber
							WHERE Seq = @TempNumberSeq
							AND UserSeq = @TempNumberUserSeq
						END	
					END
					
					SET @TempNumberList = SUBSTRING(@TempNumberList,CHARINDEX('$',@TempNumberList)+1,LEN(@TempNumberList))
				END	
			END
			-- 처리되면 전부 삭제
			IF LEN(@TempDelUserSeqList) > 0
			BEGIN
				DECLARE @TempDelUserSeqNo INT
				WHILE CHARINDEX(',',@TempDelUserSeqList) > 0
				BEGIN
					SET @TempDelUserSeqNo = SUBSTRING(@TempDelUserSeqList,0,CHARINDEX(',',@TempDelUserSeqList))
					DELETE FROM ContactsAddress WHERE UserSeq = @TempDelUserSeqNo
					DELETE FROM ContactsCompany WHERE UserSeq = @TempDelUserSeqNo
					DELETE FROM ContactsDays WHERE UserSeq = @TempDelUserSeqNo
					DELETE FROM ContactsEmail WHERE UserSeq = @TempDelUserSeqNo
					DELETE FROM ContactsGroupUser WHERE UserSeq = @TempDelUserSeqNo
					DELETE FROM ContactsHomepage WHERE UserSeq = @TempDelUserSeqNo
					DELETE FROM ContactsNumber WHERE UserSeq = @TempDelUserSeqNo
					DELETE FROM ContactsSns WHERE UserSeq = @TempDelUserSeqNo
					DELETE FROM ContactsUser WHERE Seq = @TempDelUserSeqNo 
					
					SET @TempDelUserSeqList = SUBSTRING(@TempDelUserSeqList,CHARINDEX(',',@TempDelUserSeqList)+1,LEN(@TempDelUserSeqList))
				END
			END
			-- 다음 정리> 기준 주소록번호
			SET @TempMainSeqList = SUBSTRING(@TempMainSeqList,CHARINDEX(',',@TempMainSeqList)+1,LEN(@TempMainSeqList))
		END
		

	
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
		END
		
		COMMIT TRAN
	END	
END







