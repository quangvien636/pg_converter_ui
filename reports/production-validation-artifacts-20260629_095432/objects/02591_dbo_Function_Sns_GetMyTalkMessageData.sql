-- ─── FUNCTION: sns_getmytalkmessagedata ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getmytalkmessagedata(integer);
CREATE OR REPLACE FUNCTION public.sns_getmytalkmessagedata(
    userno integer
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN



	-- 본문 메시지
	RETURN QUERY
	SELECT * FROM 
	((SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
	M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
	FROM SnsMessages AS M
	INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
	WHERE M.IsDelete = FALSE AND M.UserNo = sns_getmytalkmessagedata.userno
	AND M.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmessagedata.userno)
	)

	UNION ALL

	(SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
	M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
	FROM SnsMessages AS M
	INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
	WHERE M.IsDelete = FALSE 
	AND M.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmessagedata.userno)
	)) A
	
	-- 댓글
	RETURN QUERY
	SELECT * FROM 
	((SELECT R.ReplyNo, R.MessageNo, R.UserNo, R.Message, R.GroupNo, R.RegDate,
	G.GroupName,U.Name,
	(SELECT COUNT(*) FROM SnsIssues WHERE ParentNo=R.MessageNo AND IssueType = TRUE AND ActionType=0) AS LikeCnt,
	(SELECT COUNT(*) FROM SnsIssues WHERE ParentNo=R.MessageNo AND IssueType = TRUE AND ActionType=1) AS HateCnt
	FROM SnsReplys R
	INNER JOIN SnsGroups G ON G.GroupNo=R.GroupNo
	INNER JOIN Organization_Users U ON U.UserNo = R.UserNo
	WHERE R.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno)
	AND R.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmessagedata.userno)
	)
	
	UNION ALL
	
	(SELECT R.ReplyNo, R.MessageNo, R.UserNo, R.Message, R.GroupNo, R.RegDate,
	G.GroupName,U.Name,
	(SELECT COUNT(*) FROM SnsIssues WHERE ParentNo=R.MessageNo AND IssueType = TRUE AND ActionType=0) AS LikeCnt,
	(SELECT COUNT(*) FROM SnsIssues WHERE ParentNo=R.MessageNo AND IssueType = TRUE AND ActionType=1) AS HateCnt
	FROM SnsReplys R
	INNER JOIN SnsGroups G ON G.GroupNo=R.GroupNo
	INNER JOIN Organization_Users U ON U.UserNo = R.UserNo
	WHERE R.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmessagedata.userno)
	)) A


	-- 좋아요/싫어요/공유
	RETURN QUERY
	SELECT * FROM
	((SELECT IssueNo,IssueType,ActionType,GroupNo,ParentNo,Send_UserNo,Recv_UserNo,
	Message,RegDate,
	(SELECT Name FROM Organization_Users U WHERE U.UserNo=Send_UserNo) AS Send_UserName,
	(SELECT Name FROM Organization_Users U WHERE U.UserNo=Recv_UserNo) AS Recv_UserName,
	--COALESCE((SELECT FilePath FROM SnsAttachs A WHERE A.MessageNo=Send_UserNo AND A.FileType=2),'') AS Send_UserPhoto
	CASE WHEN COALESCE((SELECT Photo FROM Organization_Users U WHERE U.UserNo = Send_UserNo),'') = '' THEN '' ELSE '/Attachments/Personal/' + (SELECT Photo FROM Organization_Users U WHERE U.UserNo = Send_UserNo) END AS Send_UserPhoto
	FROM SnsIssues 
	WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno)
	AND IssueType IN (0,1) AND ActionType IN (0,1,3)
	AND GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmessagedata.userno)
	)
	
	UNION ALL
	
	(SELECT IssueNo,IssueType,ActionType,GroupNo,ParentNo,Send_UserNo,Recv_UserNo,
	Message,RegDate,
	(SELECT Name FROM Organization_Users U WHERE U.UserNo=Send_UserNo) AS Send_UserName,
	(SELECT Name FROM Organization_Users U WHERE U.UserNo=Recv_UserNo) AS Recv_UserName,
	--COALESCE((SELECT FilePath FROM SnsAttachs A WHERE A.MessageNo=Send_UserNo AND A.FileType=2),'') AS Send_UserPhoto
	CASE WHEN COALESCE((SELECT Photo FROM Organization_Users U WHERE U.UserNo = Send_UserNo),'') = '' THEN '' ELSE '/Attachments/Personal/' + (SELECT Photo FROM Organization_Users U WHERE U.UserNo = Send_UserNo) END AS Send_UserPhoto
	FROM SnsIssues 
	WHERE IssueType IN (0,1) AND ActionType IN (0,1,3)
	AND GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmessagedata.userno)
	)) A

	-- 첨부파일
	RETURN QUERY
	SELECT * FROM (
	(
	SELECT * FROM SnsAttachs 
	WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno)
	AND GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmessagedata.userno)
	)
	
	UNION ALL
	
	(
	SELECT * FROM SnsAttachs 
	WHERE GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmessagedata.userno)
	)
	) A

	-- 그룹정보
	RETURN QUERY
	SELECT GroupNo, GroupName, MakeUserNo, GroupType, 
	OpenType, Enabled, DepartNo 
	FROM SnsGroups 
	WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno)
	OR MakeUserNo IN (SELECT UserNo FROM SnsMessages WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno))
	OR MakeUserNo IN (SELECT UserNo FROM SnsReplys WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno))
	OR MakeUserNo IN (SELECT Send_UserNo FROM SnsIssues WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno) AND IssueType IN (0,1) AND ActionType IN (0,1,3))
	
	-- 유저정보
	RETURN QUERY
	SELECT UserNo,UserID,Name,UserPhoto,
	(SELECT G.GroupNo FROM SnsGroups AS G WHERE G.MakeUserNo = sns_getmytalkmessagedata.userno AND GroupType=104) AS MyTalkNo,
	--COALESCE((SELECT FilePath FROM SnsAttachs A WHERE A.MessageNo=UserNo AND FileType=2),'') AS FileName
	CASE WHEN COALESCE(Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || Photo END AS FileName
	FROM Organization_Users
	WHERE 
	UserNo IN (SELECT UserNo FROM SnsMessages WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno)) 
	OR UserNo IN (SELECT UserNo FROM SnsReplys WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno))
	OR UserNo IN (SELECT Send_UserNo FROM SnsIssues WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno) AND IssueType IN (0,1) AND ActionType IN (0,1,3))
	
	-- 직책 및 부서 정보
	RETURN QUERY
	SELECT B.UserNo, P.Name AS PosName, D.Name AS DepName FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Departments D ON B.DepartNo=D.DepartNo
	INNER JOIN Organization_Positions P ON B.PositionNo=P.PositionNo
	WHERE UserNo IN (SELECT UserNo FROM SnsMessages WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno))
	OR UserNo IN (SELECT UserNo FROM SnsReplys WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno))
	OR UserNo IN (SELECT Send_UserNo FROM SnsIssues WHERE GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getmytalkmessagedata.userno) AND IssueType IN (0,1) AND ActionType IN (0,1,3));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
