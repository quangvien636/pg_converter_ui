-- ─── PROCEDURE→FUNCTION: sns_findgetmessages ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.sns_findgetmessages(integer, character varying, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_findgetmessages(
    IN groupno integer,
    IN find character varying,
    IN gettype integer,
    IN userno integer,
    IN mytalkuserno integer,
    IN gettabtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 일반 그룹에서의 검색
	--내용 검색
	IF GetType = 1 AND GroupNo > 0 THEN
		IF DateTime = '' THEN
				RETURN QUERY
				SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
				M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
				FROM SnsMessages M
				INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
				WHERE Message ILIKE '%' || Find || '%' 
				AND M.GroupNo=sns_findgetmessages.groupno
				AND M.RegDate < NOW()
				ORDER BY M.RegDate DESC
			END IF;
		ELSE
				RETURN QUERY
				SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
				M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete 
				FROM SnsMessages M
				INNER JOIN SnsGroups G ON M.GroupNo = G.GroupNo
				WHERE Message ILIKE '%' || Find || '%' 
				AND M.GroupNo=sns_findgetmessages.groupno
				AND M.RegDate < DateTime
				ORDER BY M.RegDate DESC
			END IF;
		END IF;
	
	--작성자 검색
	ELSIF GetType = 2 AND GroupNo > 0 THEN
	IF DateTime = '' THEN
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
		END IF;
		ELSE
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
		END IF;
	END IF;
	
	-- 최신톡에서의 검색
	--내용 검색
	ELSIF GetType = 1 AND GroupNo = 0 THEN
		IF DateTime = '' THEN
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
		END IF;
		ELSE
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
		END IF;
	END IF;
	
	--작성자 검색
	ELSIF GetType = 2 AND GroupNo = 0 AND UserNo > 0 THEN
		IF DateTime = '' THEN
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
		END IF;
		ELSE
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
		END IF;
	END IF;
	
	-- 즐겨찾기에서의 검색
	--내용 검색
	ELSIF GetType = 1 AND GroupNo = -2 THEN
		IF DateTime = '' THEN
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
		END IF;
		ELSE
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
		END IF;
	END IF;
	
	--작성자 검색
	ELSIF GetType = 2 AND GroupNo = -2 AND UserNo > 0 THEN
		IF DateTime = '' THEN
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
		END IF;
		ELSE
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
		END IF;
	END IF;
	
	-- 개인톡에서의 검색
	--내용 검색
	ELSIF GetType = 1 AND GroupNo = -1 AND MyTalkUserNo > 0 THEN
		IF DateTime = '' THEN
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
		END IF;
		ELSE
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
		END IF;
	END IF;
	
	--작성자 검색
	ELSIF GetType = 2 AND GroupNo = -1 AND UserNo > 0 THEN
		IF DateTime = '' THEN
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
		END IF;
		ELSE
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
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
