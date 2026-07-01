=== ORIGINAL MSSQL DEFINITION FOR Contacts_GetContactsTrashList ===





-- ======================================================================
-- 작성자: 정두용
-- 생성일: 2013.09.02
-- 설  명: 사용자의 휴지통 목록을 가져 옵니다.
-- ======================================================================

CREATE PROCEDURE [dbo].[Contacts_GetContactsTrashList]
	@RegUserNo INT,
	@Sidx INT,
	@Eidx INT,
	@TS NVARCHAR(5),
	@TE NVARCHAR(5),
	@Search NVARCHAR(50),
	@SearchMode CHAR(1),
	@GroupNo INT,
	@Mode CHAR(1),
	@SortColumn NVARCHAR(100) = ''
AS

BEGIN
	-- ==========================
	-- 데이터/카운트 구분 0 = 데이터 / 1 = 카운트
	-- ==========================
	IF @Mode = '0'
	BEGIN
		-- ==========================
		-- 검색값 - 검색이 아닌 경우
		-- ==========================
		IF @Search = '' 
		BEGIN
			-- ===========================
			-- 색인 모드가 아닐 경우
			-- ===========================
			IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
			BEGIN
				-- ===========================
				-- 정렬 
				-- ===========================
				IF @SortColumn = 'FirstName ASC'
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
				ELSE IF @SortColumn = 'FirstName DESC'
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
				ELSE IF @SortColumn = 'LastName ASC'
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
				ELSE IF @SortColumn = 'LastName DESC'
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
				ELSE
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
			END
			ELSE
			-- ===========================
			-- 색인 모드 일 경우 
			-- ===========================
			BEGIN

				-- ===========================
				-- 정렬 
				-- ===========================
				IF @SortColumn = 'FirstName ASC'
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
						AND LastName BETWEEN @TS AND @TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
				ELSE IF @SortColumn = 'FirstName DESC'
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
						AND LastName BETWEEN @TS AND @TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
				ELSE IF @SortColumn = 'LastName ASC'
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
						AND LastName BETWEEN @TS AND @TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
				ELSE IF @SortColumn = 'LastName DESC'
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
						AND LastName BETWEEN @TS AND @TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
				ELSE
				BEGIN
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU (NOLOCK)
						WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
						AND LastName BETWEEN @TS AND @TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN @Sidx AND @Eidx
				END
			END
		END
		-- ===========================
		-- 검색일경우  
		-- ===========================
		ELSE
		BEGIN
			-- ===========================
			-- 성/이름 검색
			-- ===========================
			IF @SearchMode = '0' -- 이름 검색
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
			END
			ELSE IF @SearchMode = '1'
			-- ===========================
			-- 직위 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
			END
			ELSE IF @SearchMode = '2'
			-- ===========================
			-- 전화번호 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
			END
			ELSE IF @SearchMode = '3'
			-- ===========================
			-- 회사 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
			END
			ELSE IF @SearchMode = '4'
			-- ===========================
			-- 부서 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
			END
			ELSE IF @SearchMode = '5'
			-- ===========================
			-- 이메일 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value LIKE '%' + @Search + '%')
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
			END
			ELSE IF @SearchMode = '6'
			-- ===========================
			-- 그룹 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
						
					END
				END
			END
			ELSE IF @SearchMode = '7'
			-- ===========================
			-- 등록일 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
			END
			ELSE IF @SearchMode = '8'
			-- ===========================
			-- 수정일 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
			END
			ELSE IF @SearchMode = '9'
			-- ===========================
			-- 수정일 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END 
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE 
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
				ELSE
				-- ===========================
				-- 색인모드일 경우 
				-- ===========================
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF @SortColumn = 'FirstName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'FirstName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName ASC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE IF @SortColumn = 'LastName DESC'
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
					ELSE
					BEGIN
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU (NOLOCK)
							WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
							AND LastName BETWEEN @TS AND @TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = @RegUserNo
										 AND GroupNo IN (
														SELECT TreeID
														FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
						) A
						WHERE ROWNUM BETWEEN @Sidx AND @Eidx
					END
				END
			END
		END
	END
	ELSE 
	-- ===========================
	-- 카운트 쿼리
	-- ===========================
	BEGIN 
		-- ===========================
		-- 검색이 아닌경우
		-- ===========================
		IF @Search = ''
		BEGIN
			-- ===========================
			-- 색인이 아닌 경우
			-- ===========================
			IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
			BEGIN
				SELECT COUNT (*) CNT 
				FROM ContactsUser CU (NOLOCK)
				WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
			END
			ELSE 
			-- ===========================
			-- 색인인 경우
			-- ===========================
			BEGIN
				SELECT COUNT (*) CNT 
				FROM ContactsUser CU (NOLOCK)
				WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
				AND LastName BETWEEN @TS AND @TE
				AND Seq IN (
								 SELECT UserSeq 
								 FROM ContactsGroupUser
								 WHERE RegUserNo = @RegUserNo
								 AND GroupNo IN (
												SELECT TreeID
												FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
												)
								)
			END
		END
		ELSE
		-- ===========================
		-- 검색인 경우
		-- ===========================
		BEGIN
			-- ===========================
			-- 이름 검색인 경우
			-- ===========================
			IF @SearchMode = '0'
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND ( FirstName LIKE '%' + @Search + '%' OR LastName LIKE '%' + @Search + '%' )
				END
			END
			ELSE IF @SearchMode = '1'
			-- ===========================
			-- 직위 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Position LIKE '%' + @Search + '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Position LIKE '%' + @Search + '%')
				END
			END
			ELSE IF @SearchMode = '2'
			-- ===========================
			-- 전화번호 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value LIKE '%' + @Search + '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value LIKE '%' + @Search + '%')
				END
			END
			ELSE IF @SearchMode = '3'
			-- ===========================
			-- 회사 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company LIKE '%' + @Search + '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company LIKE '%' + @Search + '%')
				END
			END
			ELSE IF @SearchMode = '4'
			-- ===========================
			-- 부서 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart LIKE '%' + @Search + '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart LIKE '%' + @Search + '%')
				END
			END
			ELSE IF @SearchMode = '5'
			-- ===========================
			-- 이메일 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value LIKE '%' + @Search + '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value LIKE '%' + @Search + '%')
				END
			END
			ELSE IF @SearchMode = '6'
			-- ===========================
			-- 그룹검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND Seq IN (SELECT UserSeq FROM ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName LIKE '%' + @Search + '%'))
				END
			END
			ELSE IF @SearchMode = '7'
			-- ===========================
			-- 등록일 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND CONVERT(VARCHAR(8),RegDate, 112) LIKE '%' + @Search + '%'
				END
			END
			ELSE IF @SearchMode = '8'
			-- ===========================
			-- 수정일 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND CONVERT(VARCHAR(8),ModDate, 112) = '%' + @Search + '%'
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND CONVERT(VARCHAR(8),ModDate, 112) LIKE '%' + @Search + '%'
				END
			END
			ELSE IF @SearchMode = '9'
			-- ===========================
			-- 체크일 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF @TS = '' AND @TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND CONVERT(VARCHAR(8),CheckDate, 112) = '%' + @Search + '%'
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU (NOLOCK)
					WHERE UseYn = 'N' AND CU.RegUserNo = @RegUserNo
					AND LastName BETWEEN @TS AND @TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = @RegUserNo
									 AND GroupNo IN (
													SELECT TreeID
													FROM dbo.GetChildGroup(@RegUserNo, @GroupNo)
													)
									)
					AND CONVERT(VARCHAR(8),CheckDate, 112) LIKE '%' + @Search + '%'
				END
			END
		END
		
	END
	
	
END







