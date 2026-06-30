-- ─── PROCEDURE→FUNCTION: contacts_getcontactstrashlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getcontactstrashlist(integer, integer, integer, character varying, character varying, character varying, character varying, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getcontactstrashlist(
    IN reguserno integer,
    IN sidx integer,
    IN eidx integer,
    IN ts character varying,
    IN te character varying,
    IN search character varying,
    IN searchmode character varying,
    IN groupno integer,
    IN mode character varying,
    IN sortcolumn character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- ==========================
	-- 데이터/카운트 구분 0 = 데이터 / 1 = 카운트
	-- ==========================
	IF Mode = '0' THEN
		-- ==========================
		-- 검색값 - 검색이 아닌 경우
		-- ==========================
		IF Search = '' THEN
			-- ===========================
			-- 색인 모드가 아닐 경우
			-- ===========================
			IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
				-- ===========================
				-- 정렬
				-- ===========================
				IF SortColumn = 'FirstName ASC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				ELSIF SortColumn = 'FirstName DESC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY FirstName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				ELSIF SortColumn = 'LastName ASC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName ASC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx
				ELSIF SortColumn = 'LastName DESC' THEN
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx;
				ELSE
					RETURN QUERY
					SELECT ROWNUM, Seq, FirstName, LastName, Memo
					FROM
					(
						SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
						FROM ContactsUser CU
						WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					) A
					WHERE ROWNUM BETWEEN Sidx AND Eidx;
				END IF;
			ELSE
			-- ===========================
			-- 색인 모드 일 경우
			-- ===========================

				-- ===========================
				-- 정렬
				-- ===========================
				IF SortColumn = 'FirstName ASC' THEN
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
				ELSIF SortColumn = 'FirstName DESC' THEN
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
				ELSIF SortColumn = 'LastName ASC' THEN
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
				ELSIF SortColumn = 'LastName DESC' THEN
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
					WHERE ROWNUM BETWEEN Sidx AND Eidx;
				ELSE
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
					WHERE ROWNUM BETWEEN Sidx AND Eidx;
				END IF;
			END IF;
		-- ===========================
		-- 검색일경우
		-- ===========================
		ELSE
			-- ===========================
			-- 성/이름 검색
			-- ===========================
			IF SearchMode = '0' THEN -- 이름 검색
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' )
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				END IF;
			ELSIF SearchMode = '1' THEN
			-- ===========================
			-- 직위 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				END IF;
			ELSIF SearchMode = '2' THEN
			-- ===========================
			-- 전화번호 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsNumber WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				END IF;
			ELSIF SearchMode = '3' THEN
			-- ===========================
			-- 회사 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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

					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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

					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Company  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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

					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				END IF;
			ELSIF SearchMode = '4' THEN
			-- ===========================
			-- 부서 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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

					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsCompany WHERE Depart  ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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

					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				END IF;
			ELSIF SearchMode = '5' THEN
			-- ===========================
			-- 이메일 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND Seq IN (select UserSeq from ContactsEmail WHERE Value ILIKE '%' || Search || '%')
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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

					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				END IF;
			ELSIF SearchMode = '6' THEN
			-- ===========================
			-- 그룹 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;

					END IF;
				END IF;
			ELSIF SearchMode = '7' THEN
			-- ===========================
			-- 등록일 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				END IF;
			ELSIF SearchMode = '8' THEN
			-- ===========================
			-- 수정일 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				END IF;
			ELSIF SearchMode = '9' THEN
			-- ===========================
			-- 수정일 검색일 경우
			-- ===========================
				-- ===========================
				-- 색인모드가 아닐 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY LastName DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
						RETURN QUERY
						SELECT ROWNUM, Seq, FirstName, LastName, Memo
						FROM
						(
							SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, FirstName, LastName, Memo
							FROM ContactsUser CU
							WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
							AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%'
						) A
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				ELSE
				-- ===========================
				-- 색인모드일 경우
				-- ===========================
					-- ===========================
					-- 정렬
					-- ===========================
					IF SortColumn = 'FirstName ASC' THEN
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
					ELSIF SortColumn = 'FirstName DESC' THEN
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
					ELSIF SortColumn = 'LastName ASC' THEN
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
					ELSIF SortColumn = 'LastName DESC' THEN
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					ELSE
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
						WHERE ROWNUM BETWEEN Sidx AND Eidx;
					END IF;
				END IF;
			END IF;
		END IF;
	ELSE
	-- ===========================
	-- 카운트 쿼리
	-- ===========================
		-- ===========================
		-- 검색이 아닌경우
		-- ===========================
		IF Search = '' THEN
			-- ===========================
			-- 색인이 아닌 경우
			-- ===========================
			IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
				RETURN QUERY
				SELECT COUNT (*) CNT
				FROM ContactsUser CU
				WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno;
			ELSE
			-- ===========================
			-- 색인인 경우
			-- ===========================;
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
								);
			END IF;
		ELSE
		-- ===========================
		-- 검색인 경우
		-- ===========================
			-- ===========================
			-- 이름 검색인 경우
			-- ===========================
			IF SearchMode = '0' THEN
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' );
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND ( FirstName ILIKE '%' || Search || '%' OR LastName ILIKE '%' || Search || '%' );
				END IF;
			ELSIF SearchMode = '1' THEN
			-- ===========================
			-- 직위 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Position ILIKE '%' || Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Position ILIKE '%' || Search || '%');
				END IF;
			ELSIF SearchMode = '2' THEN
			-- ===========================
			-- 전화번호 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE '%' || Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE '%' || Search || '%');
				END IF;
			ELSIF SearchMode = '3' THEN
			-- ===========================
			-- 회사 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE '%' || Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE '%' || Search || '%');
				END IF;
			ELSIF SearchMode = '4' THEN
			-- ===========================
			-- 부서 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE '%' || Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE '%' || Search || '%');
				END IF;
			ELSIF SearchMode = '5' THEN
			-- ===========================
			-- 이메일 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE '%' || Search || '%');
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE '%' || Search || '%');
				END IF;
			ELSIF SearchMode = '6' THEN
			-- ===========================
			-- 그룹검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND Seq IN (SELECT UserSeq FROM ContactsGroupUser WHERE
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'));
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE '%' || Search || '%'));
				END IF;
			ELSIF SearchMode = '7' THEN
			-- ===========================
			-- 등록일 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%';
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND CONVERT(VARCHAR(8),RegDate, 112) ILIKE '%' || Search || '%';
				END IF;
			ELSIF SearchMode = '8' THEN
			-- ===========================
			-- 수정일 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND CONVERT(VARCHAR(8),ModDate, 112) = '%' || Search || '%';
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND CONVERT(VARCHAR(8),ModDate, 112) ILIKE '%' || Search || '%';
				END IF;
			ELSIF SearchMode = '9' THEN
			-- ===========================
			-- 체크일 검색인 경우
			-- ===========================
				-- ===========================
				-- 색인이 아닌 경우
				-- ===========================
				IF TS = '' AND TE = '' THEN -- ㄱㄴㄷ 검색용
					RETURN QUERY
					SELECT COUNT (*) CNT
					FROM ContactsUser CU
					WHERE UseYn = '' AND CU.RegUserNo = contacts_getcontactstrashlist.reguserno
					AND CONVERT(VARCHAR(8),CheckDate, 112) = '%' || Search || '%';
				ELSE
				-- ===========================
				-- 색인인 경우
				-- ===========================;
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
					AND CONVERT(VARCHAR(8),CheckDate, 112) ILIKE '%' || Search || '%';
				END IF;
			END IF;
		END IF;

	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.