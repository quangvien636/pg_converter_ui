-- ─── FUNCTION: wchat_findchatroomlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.wchat_findchatroomlist(character varying, integer);
CREATE OR REPLACE FUNCTION public.wchat_findchatroomlist(
    findtext character varying,
    viewcount integer
) RETURNS TABLE(
    chatno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	IF Mode = 0	-- 일반 사용자 검색
	BEGIN
		-- 내용검색
		IF FindType = 1 AND FindText != ''
		BEGIN
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
		END
		-- 참여자 이름 검색
		ELSE IF FindType = 2 AND FindText != ''
		BEGIN
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
		END
	END
	ELSE IF Mode = 1	--관리자 검색
	BEGIN
		-- 내용검색
		IF FindType = 1 AND FindText != ''
		BEGIN
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
		END
		-- 참여자 이름 검색
		ELSE IF FindType = 2 AND FindText != ''
		BEGIN
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
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
