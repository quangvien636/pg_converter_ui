-- ─── PROCEDURE→FUNCTION: integrated_getintegrateddetailmultitable ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_getintegrateddetailmultitable(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.integrated_getintegrateddetailmultitable(
    IN no integer,
    IN userno integer,
    IN type integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF(Type=0) BEGIN

	RETURN QUERY
	SELECT BC.BoardNo as Id, BC.RegUserNo as UserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as UserName,
		BC.ModPositionNo as PositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as PositionName,
		 BC.ModDepartNo as DepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as DepartName,
		
		BC.RegDate, 
		BC.ModDate, BC.Title, 
		BC.BoardNo as CatNo,
		B.Name as CatName,
		BC.Content,BC.StartDate, BC.EndDate,

		 BC.IsFile as IsAttach,
		 -- BC.FileCount,
		--BC.ReplyCount, BC.RecommendedCount, 
		
		BC.ViewedCount as ReadCount,
		
		-- COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended,

		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		---BC.RegPositionNo,
		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		-- BC.RegDepartNo,
		--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		--,BC.IsAlarm
		'' as TreeName

	FROM Board_Contents BC
	LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo
	LEFT JOIN Board_Boards B ON BC.BoardNo=B.BoardNo
	WHERE ContentNo = integrated_getintegrateddetailmultitable.no

END;
ELSE IF(Type=1) BEGIN
	IF SELECT ReadDate FROM Integrated_Reference (NOLOCK THEN
		WHERE IntegratedNo = integrated_getintegrateddetailmultitable.no AND UserNo = integrated_getintegrateddetailmultitable.userno) IS NULL BEGIN
	
		UPDATE Integrated_Reference
		ReadDate := NOW();
		WHERE IntegratedNo = integrated_getintegrateddetailmultitable.no AND UserNo = integrated_getintegrateddetailmultitable.userno
		
		UPDATE Integrateds
		CurrentViews := CurrentViews + 1;
		WHERE IntegratedNo = integrated_getintegrateddetailmultitable.no
		
	END;
	
	RETURN QUERY
	SELECT N.IntegratedNo as Id, N.RegUserNo as UserNo,
		U.Name AS UserName,P.PositionNo, P.Name AS PositionName,D.DepartNo, D.Name AS DepartName,
		N.RegDate,  N.ModDate,	N.Title, 
		N.DivisionNo as CatNo, ND.Name AS CatName,
		N.Content, N.StartDate, N.EndDate,

		-- N.Important, N.IsShare,
		 N.IsAttach, 
		 --N.TotalViews, N.CurrentViews, N.IsContentImg,
		(SELECT COUNT(*) FROM Integrated_Reference WHERE IntegratedNo = N.IntegratedNo) AS ReadCount,
		--N.TypeNo,
		--N.TreeRoot, N.TreeNo,N.TreeItem2, N.TreeItem3,
		IT.Name as TreeName
	FROM Integrateds N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	LEFT JOIN Integrated_TreeItem IT ON IT.ID=N.TreeNo
	WHERE N.IntegratedNo = integrated_getintegrateddetailmultitable.no
	END;

	ELSE IF(Type=2) BEGIN

	IF SELECT ReadDate FROM NoticeSyn_References (NOLOCK THEN
		WHERE NoticeNo = integrated_getintegrateddetailmultitable.no AND UserNo = integrated_getintegrateddetailmultitable.userno) IS NULL BEGIN
	
		UPDATE NoticeSyn_References
		ReadDate := NOW();
		WHERE NoticeNo = integrated_getintegrateddetailmultitable.no AND UserNo = integrated_getintegrateddetailmultitable.userno
		
		UPDATE Notices
		CurrentViews := CurrentViews + 1;
		WHERE NoticeNo = integrated_getintegrateddetailmultitable.no
		
	END;
	
	RETURN QUERY
	SELECT N.NoticeNo as Id, N.RegUserNo as UserNo,
		U.Name AS UserName,P.PositionNo, P.Name AS PositionName,D.DepartNo, D.Name AS DepartName,
		N.RegDate,  N.ModDate,
		N.Title, N.DivisionNo as CatNo, ND.Name AS CatName,
		N.Content, N.StartDate, N.EndDate,
		--N.Important, N.IsShare, 
		N.IsAttach, 
		--N.TotalViews, N.CurrentViews, N.IsContentImg,
		(SELECT COUNT(*) FROM NoticeSyn_Reference WHERE NoticeNo = N.NoticeNo) AS ReadCount,
		--N.TypeNo
		'' as TreeName
	FROM NoticesSyn N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	WHERE N.NoticeNo = integrated_getintegrateddetailmultitable.no
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
