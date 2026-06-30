-- ─── PROCEDURE→FUNCTION: sns_getlastestmessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.sns_getlastestmessage(integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getlastestmessage(
    IN userno integer,
    IN mode integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0 THEN
	-- 최신톡의 메시지
		IF DateTime = '' THEN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getlastestmessage.userno AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE
			AND M.RegDate < NOW()
			ORDER BY RegDate DESC
		END IF;
		ELSE
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getlastestmessage.userno AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE
			AND M.RegDate < DateTime
			ORDER BY RegDate DESC
		END IF;
	END IF;
	ELSIF Mode = 1 THEN
	-- 즐겨찾기의 메시지
		IF DateTime = '' THEN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getlastestmessage.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE
			AND M.RegDate < NOW()
			ORDER BY RegDate DESC
		END IF;
		ELSE
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getlastestmessage.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE
			AND M.RegDate < DateTime
			ORDER BY RegDate DESC
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
