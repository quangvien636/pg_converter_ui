-- ─── FUNCTION: sns_getnewslist ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getnewslist(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getnewslist(
    userno integer,
    groupno integer,
    standardday integer,
    mode integer,
    newstype integer
) RETURNS TABLE(
    groupno text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF NewsType = 0	-- 새소식
	BEGIN
		-- 일반그룹(프리/부서/우리)
		IF Mode = 0
		BEGIN
			RETURN QUERY
			SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE I.GroupNo = sns_getnewslist.groupno
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			ORDER BY I.RegDate DESC
		END
		-- 최신톡
		ELSE IF Mode = 1
		BEGIN
			RETURN QUERY
			SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE I.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getnewslist.userno AND IsJoin = TRUE) 
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			ORDER BY I.RegDate DESC
		END
		-- 개인톡
		ELSE IF Mode = 2
		BEGIN
			RETURN QUERY
			SELECT * FROM
			((SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE 
			I.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getnewslist.userno)
			AND I.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getnewslist.userno AND IsJoin = TRUE) 
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			)
			UNION ALL
			(SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE 
			I.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getnewslist.userno)
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			)) T
			ORDER BY RegDate DESC
		END
		--즐겨찾기
		ELSE IF Mode = 3
		BEGIN
			RETURN QUERY
			SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE I.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getnewslist.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			ORDER BY I.RegDate DESC
		END
	END
	ELSE IF NewsType = 1	--그룹소식
	BEGIN
		-- 일반그룹(프리/부서/우리)
		IF Mode = 0
		BEGIN
			RETURN QUERY
			SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE I.GroupNo = sns_getnewslist.groupno
			AND I.IssueType IN (0,1)
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			ORDER BY I.RegDate DESC
		END
		-- 최신톡
		ELSE IF Mode = 1
		BEGIN
			RETURN QUERY
			SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE I.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getnewslist.userno AND IsJoin = TRUE) 
			AND I.IssueType IN (0,1)
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			ORDER BY I.RegDate DESC
		END
		-- 개인톡
		ELSE IF Mode = 2
		BEGIN
			RETURN QUERY
			SELECT * FROM
			((SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE 
			I.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getnewslist.userno)
			AND I.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getnewslist.userno AND IsJoin = TRUE) 
			AND I.IssueType IN (0,1)
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			)
			UNION ALL
			(SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE 
			I.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getnewslist.userno)
			AND I.IssueType IN (0,1)
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			)) T
			ORDER BY RegDate DESC
		END
		--즐겨찾기
		ELSE IF Mode = 3
		BEGIN
			RETURN QUERY
			SELECT I.IssueNo, I.IssueType, I.ActionType, I.GroupNo, I.ParentNo, I.Send_UserNo,
			I.Recv_UserNo, I.Message, I.RegDate,
			COALESCE(GG.GroupName, '') AS GroupName, 
			SU.Name AS Send_UserName, RU.Name AS Recv_UserName, 
			--COALESCE((SELECT A.FilePath FROM SnsAttachs A WHERE A.MessageNo=SU.UserNo AND A.FileType=2),'') AS UserProfile,
			CASE WHEN COALESCE(SU.Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || SU.Photo END AS UserProfile,
			COALESCE(M.Message, '') AS ParentMsg	
			FROM 
			SnsIssues AS I
			LEFT OUTER JOIN SnsGroups AS GG ON GG.GroupNo = I.GroupNo
			LEFT OUTER JOIN SnsMessages AS M ON M.MessageNo = I.ParentNo	
			INNER JOIN Organization_Users AS RU ON RU.UserNo = I.Recv_UserNo			-- 수신유저
			INNER JOIN Organization_Users AS SU ON SU.UserNo = I.Send_UserNo			-- 발신유저
			WHERE I.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getnewslist.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND I.IssueType IN (0,1)
			AND I.RegDate >= DATEADD(DD, -StandardDay, NOW())
			ORDER BY I.RegDate DESC
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
