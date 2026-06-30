-- ─── PROCEDURE→FUNCTION: integrate_getprenext ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.integrate_getprenext(integer);
CREATE OR REPLACE FUNCTION public.integrate_getprenext(
    IN integratedno integer
) RETURNS SETOF record
AS $function$
DECLARE
    treeno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


--SELECT TreeNo INTO treeno from Integrateds where IntegratedNo=IntegratedNo

	,
	IntegratedNo INT,	
	RegUserNo INT,
	UserName nvarchar(500),
	PositionName nvarchar(500),
	DepartName nvarchar(500),
	RegDate DateTime,
	ModUserNo INT,
	ModDate DateTime,
	Title nvarchar(500),
	DivisionNo INT,
	DivisionName text,
	--Content text,
	Important BIT,
	IsShare BIT,
	IsAttach BIT,
	TotalViews INT,
	CurrentViews INT,
	ViewUserCnt INT,
	TypeNo Int,
	TreeRoot INT,
	TreeName text
	)
	-- 이전글;
	INSERT INTO tab

	RETURN QUERY
	SELECT /* TOP 1 */ '0',N.IntegratedNo, N.RegUserNo,
	COALESCE(U.Name ,'') AS UserName,
		 COALESCE(P.Name,'') AS PositionName,
		  COALESCE(D.Name,'') AS DepartName,

		--U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, COALESCE(ND.Name,'') AS DivisionName,
		--N.Content,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews,
		(SELECT COUNT(*) FROM Integrated_Reference WHERE IntegratedNo = N.IntegratedNo) AS ViewUserCnt,
		N.TypeNo,
		N.TreeRoot,IT.Name as TreeName
	FROM Integrateds N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	LEFT JOIN Integrated_TreeItem IT ON IT.ID=N.TreeNo
	WHERE N.IntegratedNo < integrate_getprenext.integratedno
	--AND N.TreeNo=TreeNo
	order by N.IntegratedNo desc

	INSERT INTO tab
	RETURN QUERY
	SELECT /* TOP 1 */ '1',N.IntegratedNo, N.RegUserNo,
		--U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		COALESCE(U.Name,'') AS UserName,
		 COALESCE(P.Name,'') AS PositionName,
		  COALESCE(D.Name,'') AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, COALESCE(ND.Name,'')  AS DivisionName,
		--N.Content,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews,
		(SELECT COUNT(*) FROM Integrated_Reference WHERE IntegratedNo = N.IntegratedNo) AS ViewUserCnt,
		N.TypeNo,
		N.TreeRoot,IT.Name as TreeName
	FROM Integrateds N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	LEFT JOIN Integrated_TreeItem IT ON IT.ID=N.TreeNo
	WHERE N.IntegratedNo > integrate_getprenext.integratedno
	--AND N.TreeNo=TreeNo
	order by N.IntegratedNo
	


	RETURN QUERY
	SELECT * FROM tab;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
