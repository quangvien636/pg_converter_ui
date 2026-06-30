-- ─── FUNCTION: sns_getlastestmessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getlastestmessage(integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getlastestmessage(
    userno integer,
    mode integer
) RETURNS TABLE(
    groupno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Mode = 0
	-- 최신톡의 메시지
	BEGIN
		IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getlastestmessage.userno AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE
			AND M.RegDate < NOW()
			ORDER BY RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getlastestmessage.userno AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE
			AND M.RegDate < DateTime
			ORDER BY RegDate DESC
		END
	END
	ELSE IF Mode = 1
	BEGIN
	-- 즐겨찾기의 메시지
		IF DateTime = ''
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getlastestmessage.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE
			AND M.RegDate < NOW()
			ORDER BY RegDate DESC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT /* TOP 20 */ M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getlastestmessage.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND M.IsDelete = FALSE
			AND M.RegDate < DateTime
			ORDER BY RegDate DESC
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
