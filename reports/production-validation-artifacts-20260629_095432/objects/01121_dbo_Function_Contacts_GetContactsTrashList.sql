-- ─── FUNCTION: contacts_getcontactstrashlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getcontactstrashlist(integer, integer, integer, character varying, character varying, character varying, character varying, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getcontactstrashlist(
    reguserno integer,
    sidx integer,
    eidx integer,
    ts character varying,
    te character varying,
    search character varying,
    searchmode character varying,
    groupno integer,
    mode character varying,
    sortcolumn character varying DEFAULT ''
) RETURNS TABLE(
    treeid text
)
AS $function$
BEGIN

	-- ==========================
	-- 데이터/카운트 구분 0 = 데이터 / 1 = 카운트
	-- ==========================
	IF Mode = '0'
	BEGIN
		-- ==========================
		-- 검색값 - 검색이 아닌 경우
		-- ==========================
		IF Search = '' 
		BEGIN
			-- ===========================
			-- 색인 모드가 아닐 경우
			-- ===========================
			IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
			BEGIN
				-- ===========================
				-- 정렬 
				-- ===========================
				IF SortColumn = 'FirstName ASC'
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				END
				ELSE IF SortColumn = 'FirstName DESC'
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				END
				ELSE IF SortColumn = 'LastName ASC'
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				END
				ELSE IF SortColumn = 'LastName DESC'
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				END
				ELSE
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
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
				IF SortColumn = 'FirstName ASC'
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
						AND LastName BETWEEN TS AND TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				END
				ELSE IF SortColumn = 'FirstName DESC'
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
						AND LastName BETWEEN TS AND TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				END
				ELSE IF SortColumn = 'LastName ASC'
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
						AND LastName BETWEEN TS AND TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				END
				ELSE IF SortColumn = 'LastName DESC'
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
						AND LastName BETWEEN TS AND TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				END
				ELSE
				BEGIN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo 
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
						AND LastName BETWEEN TS AND TE
						AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
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
			IF SearchMode = '0' -- 이름 검색
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
				END
			END
			ELSE IF SearchMode = '1'
			-- ===========================
			-- 직위 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
				END
			END
			ELSE IF SearchMode = '2'
			-- ===========================
			-- 전화번호 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
				END
			END
			ELSE IF SearchMode = '3'
			-- ===========================
			-- 회사 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
				END
			END
			ELSE IF SearchMode = '4'
			-- ===========================
			-- 부서 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
				END
			END
			ELSE IF SearchMode = '5'
			-- ===========================
			-- 이메일 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
				END
			END
			ELSE IF SearchMode = '6'
			-- ===========================
			-- 그룹 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND Seq IN (select UserSeq from ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
						
					END
				END
			END
			ELSE IF SearchMode = '7'
			-- ===========================
			-- 등록일 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
				END
			END
			ELSE IF SearchMode = '8'
			-- ===========================
			-- 수정일 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
				END
			END
			ELSE IF SearchMode = '9'
			-- ===========================
			-- 수정일 검색일 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END 
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE 
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
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
					IF SortColumn = 'FirstName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'FirstName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName ASC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE IF SortColumn = 'LastName DESC'
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
					END
					ELSE
					BEGIN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo 
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND LastName BETWEEN TS AND TE
							AND Seq IN (
										 SELECT UserSeq 
										 FROM ContactsGroupUser
										 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
										 AND GroupNo IN (
														SELECT TreeID
														FROM public."GetChildGroup"(RegUserNo, GroupNo)
														)
										)
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx
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
		IF Search = ''
		BEGIN
			-- ===========================
			-- 색인이 아닌 경우
			-- ===========================
			IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
			BEGIN
				RETURN QUERY
				SELECT COUNT (*) CNT 
				FROM ContactsUser CU
				WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
			END
			ELSE 
			-- ===========================
			-- 색인인 경우
			-- ===========================
			BEGIN
				RETURN QUERY
				SELECT COUNT (*) CNT 
				FROM ContactsUser CU
				WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
				AND LastName BETWEEN TS AND TE
				AND Seq IN (
								 SELECT UserSeq 
								 FROM ContactsGroupUser
								 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
								 AND GroupNo IN (
												SELECT TreeID
												FROM public."GetChildGroup"(RegUserNo, GroupNo)
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
			IF SearchMode = '0'
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
				END
			END
			ELSE IF SearchMode = '1'
			-- ===========================
			-- 직위 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Position ILIKE '%' || Search || '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Position ILIKE '%' || Search || '%')
				END
			END
			ELSE IF SearchMode = '2'
			-- ===========================
			-- 전화번호 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE '%' || Search || '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE '%' || Search || '%')
				END
			END
			ELSE IF SearchMode = '3'
			-- ===========================
			-- 회사 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE '%' || Search || '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE '%' || Search || '%')
				END
			END
			ELSE IF SearchMode = '4'
			-- ===========================
			-- 부서 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE '%' || Search || '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE '%' || Search || '%')
				END
			END
			ELSE IF SearchMode = '5'
			-- ===========================
			-- 이메일 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE '%' || Search || '%')
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE '%' || Search || '%')
				END
			END
			ELSE IF SearchMode = '6'
			-- ===========================
			-- 그룹검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND Seq IN (SELECT UserSeq FROM ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'))
				END
			END
			ELSE IF SearchMode = '7'
			-- ===========================
			-- 등록일 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
				END
			END
			ELSE IF SearchMode = '8'
			-- ===========================
			-- 수정일 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND CONVERT(VARCHAR(8),ModDate, 112) = '%' || Search || '%'
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
				END
			END
			ELSE IF SearchMode = '9'
			-- ===========================
			-- 체크일 검색인 경우
			-- ===========================
			BEGIN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' -- ㄱㄴㄷ 검색용
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND CONVERT(VARCHAR(8),CheckDate, 112) = '%' || Search || '%'
				END
				ELSE 
				-- ===========================
				-- 색인인 경우
				-- ===========================
				BEGIN
					RETURN QUERY
					SELECT COUNT (*) CNT 
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND LastName BETWEEN TS AND TE
					AND Seq IN (
									 SELECT UserSeq 
									 FROM ContactsGroupUser
									 WHERE RegUserNo = contacts_getcontactstrashlist.reguserno
									 AND GroupNo IN (
													SELECT TreeID
													FROM public."GetChildGroup"(RegUserNo, GroupNo)
													)
									)
					AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
				END
			END
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
