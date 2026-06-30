-- ─── FUNCTION: sns_getuserinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getuserinfo();
CREATE OR REPLACE FUNCTION public.sns_getuserinfo(
) RETURNS TABLE(
    filepath text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	
    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT U.Name AS UserName,
	(SELECT D.Name FROM Organization_Departments AS D WHERE D.DepartNo = B.DepartNo AND D.Enabled = TRUE) AS DepartName,
	(SELECT P.Name FROM Organization_Positions AS P WHERE P.PositionNo = B.PositionNo AND P.Enabled = TRUE) AS PositionName,
	(SELECT G.GroupNo FROM SnsGroups AS G WHERE G.MakeUserNo = U.UserNo AND GroupType=104) AS MyTalkNo,
	COALESCE((SELECT L.PermissionType FROM Authority_SitePermissions AS L WHERE L.UserNo = U.UserNo), 3) AS Permission,
	--COALESCE((SELECT FilePath FROM SnsAttachs A WHERE A.MessageNo=U.UserNo AND A.FileType=2 ), '')
	CASE WHEN COALESCE(Photo,'') = '' THEN '' ELSE '/Attachments/Personal/' || Photo END AS FilePath
	FROM Organization_Users AS U
	INNER JOIN Organization_BelongToDepartment AS B ON B.UserNo = U.UserNo
	WHERE U.UserNo = UserNo AND U.Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
