-- ─── PROCEDURE→FUNCTION: wchat_findchatroomlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.wchat_findchatroomlist(character varying, integer);
CREATE OR REPLACE FUNCTION public.wchat_findchatroomlist(
    IN findtext character varying,
    IN viewcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	IF Mode = 0	-- 일반 사용자 검색 THEN
		-- 내용검색
		IF FindType = 1 AND FindText != '' THEN
			RETURN QUERY
			SELECT ChatNo, MakeUserNo, RegDate, Title,
			(
				SELECT COUNT(*) FROM WCHATRooms R
				INNER JOIN WCHATMembers M ON M.UserNo=UserNo AND M.ChatNo=R.ChatNo
				WHERE R.ChatNo IN
				(
					SELECT C.ChatNo FROM WCHATContents C
					WHERE Content ILIKE '%' || FindText || '%'
					GROUP BY C.ChatNo
				)
				AND R.IsClose = FALSE
			) AS TotalCnt
			FROM
			(
			SELECT (ROW_NUMBER() OVER (ORDER BY R.RegDate ASC)) AS RowNum, R.ChatNo, R.MakeUserNo, R.RegDate 
			,COALESCE((SELECT /* TOP 1 */ C.Content FROM WCHATContents C WHERE C.ChatNo=R.ChatNo ORDER BY C.RegDate DESC), '') AS Title
			FROM WCHATRooms R
			INNER JOIN WCHATMembers M ON M.UserNo=UserNo AND M.ChatNo=R.ChatNo
			WHERE R.ChatNo IN
			(
				SELECT C.ChatNo FROM WCHATContents C
				WHERE Content ILIKE '%' || FindText || '%'
				GROUP BY C.ChatNo
			)
			AND R.IsClose = FALSE
			) T
			WHERE 
			T.RowNum BETWEEN 
			((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY RegDate ASC
		END IF;
		-- 참여자 이름 검색
		ELSIF FindType = 2 AND FindText != '' THEN
			RETURN QUERY
			SELECT ChatNo, MakeUserNo, RegDate, Title,
			(SELECT COUNT(*) FROM WCHATRooms R
			INNER JOIN WCHATMembers M ON M.UserNo=UserNo AND M.ChatNo=R.ChatNo
			WHERE R.ChatNo IN
			(
				SELECT M.ChatNo FROM WCHATMembers M
				INNER JOIN Organization_Users U ON U.UserNo = M.UserNo
				WHERE U.Name ILIKE '%' || FindText || '%'
				GROUP BY M.ChatNo
			)
			AND R.IsClose = FALSE) AS TotalCnt
			FROM
			(
			SELECT (ROW_NUMBER() OVER (ORDER BY R.RegDate ASC)) AS RowNum,R.ChatNo, R.MakeUserNo, R.RegDate 
						,COALESCE((SELECT /* TOP 1 */ C.Content FROM WCHATContents C WHERE C.ChatNo=R.ChatNo ORDER BY C.RegDate DESC), '') AS Title
						FROM WCHATRooms R
						INNER JOIN WCHATMembers M ON M.UserNo=UserNo AND M.ChatNo=R.ChatNo
						WHERE R.ChatNo IN
						(
							SELECT M.ChatNo FROM WCHATMembers M
							INNER JOIN Organization_Users U ON U.UserNo = M.UserNo
							WHERE U.Name ILIKE '%' || FindText || '%'
							GROUP BY M.ChatNo
						)
						AND R.IsClose = FALSE
			) T
			WHERE 
			T.RowNum BETWEEN 
			((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY RegDate ASC
		END IF;
	END IF;
	ELSIF Mode = 1	--관리자 검색 THEN
		-- 내용검색
		IF FindType = 1 AND FindText != '' THEN
			RETURN QUERY
			SELECT ChatNo, MakeUserNo, RegDate, Title,
			(
			SELECT COUNT(*) FROM WCHATRooms R
			WHERE R.ChatNo IN
			(
				SELECT C.ChatNo FROM WCHATContents C
				WHERE Content ILIKE '%' || FindText || '%'
				GROUP BY C.ChatNo
			)
			AND R.IsClose = FALSE
			) AS TotalCnt
			FROM
			(
			SELECT (ROW_NUMBER() OVER (ORDER BY R.RegDate ASC)) AS RowNum, R.ChatNo, R.MakeUserNo, R.RegDate 
			,COALESCE((SELECT /* TOP 1 */ C.Content FROM WCHATContents C WHERE C.ChatNo=R.ChatNo ORDER BY C.RegDate DESC), '') AS Title
			FROM WCHATRooms R
			WHERE R.ChatNo IN
			(
				SELECT C.ChatNo FROM WCHATContents C
				WHERE Content ILIKE '%' || FindText || '%'
				GROUP BY C.ChatNo
			)
			AND R.IsClose = FALSE
			) T
			WHERE 
			T.RowNum BETWEEN 
			((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY RegDate ASC
		END IF;
		-- 참여자 이름 검색
		ELSIF FindType = 2 AND FindText != '' THEN
			RETURN QUERY
			SELECT ChatNo, MakeUserNo, RegDate, Title,
			(
			SELECT COUNT(*) FROM WCHATRooms R
			WHERE R.ChatNo IN
			(
				SELECT M.ChatNo FROM WCHATMembers M
				INNER JOIN Organization_Users U ON U.UserNo = M.UserNo
				WHERE U.Name ILIKE '%' || FindText || '%'
				GROUP BY M.ChatNo
			)
			AND R.IsClose = FALSE
			) AS TotalCnt
			FROM
			(
			SELECT (ROW_NUMBER() OVER (ORDER BY R.RegDate ASC)) AS RowNum, R.ChatNo, R.MakeUserNo, R.RegDate 
			,COALESCE((SELECT /* TOP 1 */ C.Content FROM WCHATContents C WHERE C.ChatNo=R.ChatNo ORDER BY C.RegDate DESC), '') AS Title
			FROM WCHATRooms R
			WHERE R.ChatNo IN
			(
				SELECT M.ChatNo FROM WCHATMembers M
				INNER JOIN Organization_Users U ON U.UserNo = M.UserNo
				WHERE U.Name ILIKE '%' || FindText || '%'
				GROUP BY M.ChatNo
			)
			AND R.IsClose = FALSE
			) T
			WHERE 
			T.RowNum BETWEEN 
			((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY RegDate ASC
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
