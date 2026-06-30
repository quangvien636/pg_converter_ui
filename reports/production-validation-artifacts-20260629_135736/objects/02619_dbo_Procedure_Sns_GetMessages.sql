-- ─── PROCEDURE→FUNCTION: sns_getmessages ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.sns_getmessages(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getmessages(
    IN groupno integer,
    IN userno integer,
    IN messageno integer,
    IN gettype integer,
    IN gettabtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	-- 그룹키값을 이용한 글정보
	IF GetType = 1 AND GroupNo > 0 THEN
		IF DateTime = '' THEN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo = sns_getmessages.groupno AND M.IsDelete = FALSE
			AND M.RegDate < NOW()
			ORDER BY RegDate DESC
		END IF;
		ELSE
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo = sns_getmessages.groupno AND M.IsDelete = FALSE
			AND M.RegDate < DateTime
			ORDER BY RegDate DESC
		END IF;
	END IF;
	--개인톡의 메시지 가져오기
	-- GroupNo : 개인톡 유저의 No, UserNo: 방문유저의 No
	ELSIF GetType = 3 AND GroupNo > 0 AND UserNo > 0 THEN
		IF DateTime = '' THEN
			RETURN QUERY
			SELECT /* TOP 20 */ * FROM 					

			((SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE AND M.UserNo = sns_getmessages.groupno
			AND M.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmessages.groupno)
			)

			UNION ALL

			(SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE 
			AND M.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmessages.groupno)
			))

			A WHERE 
			GroupNo IN 
			(
			SELECT GroupNo FROM SnsGroupUsers WHERE UserNo = sns_getmessages.userno
			UNION ALL
			SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmessages.groupno
			)
			AND A.IsAttach IN ((CASE WHEN GetTabType=3 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND A.IsPicture IN ((CASE WHEN GetTabType=2 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND RegDate < NOW()
			ORDER BY RegDate DESC
		END IF;
		ELSE
			RETURN QUERY
			SELECT /* TOP 20 */ * FROM 					

			((SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE AND M.UserNo = sns_getmessages.groupno
			AND M.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmessages.groupno)
			)

			UNION ALL

			(SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE 
			AND M.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmessages.groupno)
			))

			A WHERE 
			GroupNo IN 
			(
			SELECT GroupNo FROM SnsGroupUsers WHERE UserNo = sns_getmessages.userno
			UNION ALL
			SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmessages.groupno
			)
			AND A.IsAttach IN ((CASE WHEN GetTabType=3 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND A.IsPicture IN ((CASE WHEN GetTabType=2 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND RegDate < DateTime
			ORDER BY RegDate DESC
		END IF;
	END IF;
	-- 메시지키값을 이용한 글정보
	ELSIF GetType = 2 AND MessageNo > 0 THEN
		RETURN QUERY
		SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
		M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
		FROM SnsMessages AS M
		INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
		WHERE M.MessageNo = sns_getmessages.messageno
		ORDER BY RegDate DESC
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
