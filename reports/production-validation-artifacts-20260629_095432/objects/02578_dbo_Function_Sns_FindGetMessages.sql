-- ─── FUNCTION: sns_findgetmessages ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_findgetmessages(integer, character varying, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_findgetmessages(
    groupno integer,
    find character varying,
    gettype integer,
    userno integer,
    mytalkuserno integer,
    gettabtype integer
) RETURNS TABLE(
    groupno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- 일반 그룹에서의 검색
	--내용 검색
	IF GetType = 1 AND GroupNo > 0
	BEGIN
		IF DateTime = ''
			BEGIN
				RETURN QUERY
				SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
				M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
				FROM SnsMessages M
				INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
				WHERE Message ILIKE '%' || Find || '%' 
				AND M.GroupNo=sns_findgetmessages.groupno
				AND M.RegDate < NOW()
				ORDER BY M.RegDate DESC
			END
		ELSE
			BEGIN
				RETURN QUERY
				SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
				M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
				FROM SnsMessages M
				INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
				WHERE Message ILIKE '%' || Find || '%' 
				AND M.GroupNo=sns_findgetmessages.groupno
				AND M.RegDate < DateTime
				ORDER BY M.RegDate DESC
			END
		END
	
	--작성자 검색
	ELSE IF GetType = 2 AND GroupNo > 0
	BEGIN
	IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
			FROM SnsMessages M 
			INNER JOIN Organization_Users U ON M.UserNo = U.UserNo
			INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
			WHERE U.Name ILIKE '%' || Find || '%' 
			AND M.GroupNo=sns_findgetmessages.groupno
			AND M.RegDate < NOW()
			ORDER BY M.RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
			FROM SnsMessages M 
			INNER JOIN Organization_Users U ON M.UserNo = U.UserNo
			INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
			WHERE U.Name ILIKE '%' || Find || '%' 
			AND M.GroupNo=sns_findgetmessages.groupno
			AND M.RegDate < DateTime
			ORDER BY M.RegDate DESC
		END
	END
	
	-- 최신톡에서의 검색
	--내용 검색
	ELSE IF GetType = 1 AND GroupNo = 0	
	BEGIN
		IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_findgetmessages.userno AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE 
			AND Message ILIKE '%' || Find || '%'
			AND M.RegDate < NOW()
			ORDER BY M.RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_findgetmessages.userno AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE 
			AND Message ILIKE '%' || Find || '%'
			AND M.RegDate < DateTime
			ORDER BY M.RegDate DESC
		END
	END
	
	--작성자 검색
	ELSE IF GetType = 2 AND GroupNo = 0 AND UserNo > 0
	BEGIN
		IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
			FROM SnsMessages M 
			INNER JOIN Organization_Users U ON M.UserNo = U.UserNo
			INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_findgetmessages.userno AND IsJoin = TRUE)
			AND U.Name ILIKE '%' || Find || '%' 
			AND M.RegDate < NOW()
			ORDER BY M.RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
			FROM SnsMessages M 
			INNER JOIN Organization_Users U ON M.UserNo = U.UserNo
			INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_findgetmessages.userno AND IsJoin = TRUE)
			AND U.Name ILIKE '%' || Find || '%' 
			AND M.RegDate < DateTime
			ORDER BY M.RegDate DESC
		END
	END
	
	-- 즐겨찾기에서의 검색
	--내용 검색
	ELSE IF GetType = 1 AND GroupNo = -2	
	BEGIN
		IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_findgetmessages.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE 
			AND Message ILIKE '%' || Find || '%'
			AND M.RegDate < NOW()
			ORDER BY M.RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_findgetmessages.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE 
			AND Message ILIKE '%' || Find || '%'
			AND M.RegDate < DateTime
			ORDER BY M.RegDate DESC
		END
	END
	
	--작성자 검색
	ELSE IF GetType = 2 AND GroupNo = -2 AND UserNo > 0
	BEGIN
		IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
			FROM SnsMessages M 
			INNER JOIN Organization_Users U ON M.UserNo = U.UserNo
			INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_findgetmessages.userno AND IsBookmark = TRUE AND IsJoin = TRUE)
			AND U.Name ILIKE '%' || Find || '%' 
			AND M.RegDate < NOW()
			ORDER BY M.RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
			FROM SnsMessages M 
			INNER JOIN Organization_Users U ON M.UserNo = U.UserNo
			INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_findgetmessages.userno AND IsBookmark = TRUE AND IsJoin = TRUE)
			AND U.Name ILIKE '%' || Find || '%' 
			AND M.RegDate < DateTime
			ORDER BY M.RegDate DESC
		END
	END
	
	-- 개인톡에서의 검색
	--내용 검색
	ELSE IF GetType = 1 AND GroupNo = -1 AND MyTalkUserNo > 0
	BEGIN
		IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ * FROM 					

			((SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE AND M.UserNo = sns_findgetmessages.mytalkuserno
			AND M.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno)
			)

			UNION ALL

			(SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE 
			AND M.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno)
			))

			A WHERE 
			A.GroupNo IN 
			(
			SELECT GroupNo FROM SnsGroupUsers WHERE UserNo = sns_findgetmessages.userno
			UNION ALL
			SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno
			)
			AND A.IsAttach IN ((CASE WHEN GetTabType=3 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND A.IsPicture IN ((CASE WHEN GetTabType=2 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND A.Message ILIKE '%' || Find || '%'
			AND A.RegDate < NOW()
			ORDER BY A.RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ * FROM 					

			((SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE AND M.UserNo = sns_findgetmessages.mytalkuserno
			AND M.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno)
			)

			UNION ALL

			(SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE 
			AND M.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno)
			))

			A WHERE 
			A.GroupNo IN 
			(
			SELECT GroupNo FROM SnsGroupUsers WHERE UserNo = sns_findgetmessages.userno
			UNION ALL
			SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno
			)
			AND A.IsAttach IN ((CASE WHEN GetTabType=3 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND A.IsPicture IN ((CASE WHEN GetTabType=2 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND A.Message ILIKE '%' || Find || '%'
			AND A.RegDate < DateTime
			ORDER BY A.RegDate DESC
		END
	END
	
	--작성자 검색
	ELSE IF GetType = 2 AND GroupNo = -1 AND UserNo > 0
	BEGIN
		IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ * FROM 					

			((SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE AND M.UserNo = sns_findgetmessages.mytalkuserno
			AND M.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno)
			)

			UNION ALL

			(SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE 
			AND M.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno)
			))

			A 
			INNER JOIN Organization_Users U ON A.UserNo = U.UserNo
			WHERE 
			A.GroupNo IN 
			(
			SELECT GroupNo FROM SnsGroupUsers WHERE UserNo = sns_findgetmessages.userno
			UNION ALL
			SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno
			)
			AND U.Name ILIKE '%' || Find || '%'
			AND A.RegDate < NOW()
			ORDER BY A.RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ * FROM 					

			((SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE AND M.UserNo = sns_findgetmessages.mytalkuserno
			AND M.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno)
			)

			UNION ALL

			(SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE 
			AND M.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno)
			))

			A 
			INNER JOIN Organization_Users U ON A.UserNo = U.UserNo
			WHERE 
			A.GroupNo IN 
			(
			SELECT GroupNo FROM SnsGroupUsers WHERE UserNo = sns_findgetmessages.userno
			UNION ALL
			SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_findgetmessages.mytalkuserno
			)
			AND U.Name ILIKE '%' || Find || '%'
			AND A.RegDate < DateTime
			ORDER BY A.RegDate DESC
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
