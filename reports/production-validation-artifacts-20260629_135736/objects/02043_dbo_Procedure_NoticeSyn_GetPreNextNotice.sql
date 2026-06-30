-- ─── PROCEDURE→FUNCTION: noticesyn_getprenextnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.noticesyn_getprenextnotice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getprenextnotice(
    IN noticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	,
	NoticeNo INT,	
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
	TypeNo Int
	)
	-- 이전글;
	INSERT INTO tab
	RETURN QUERY
	SELECT /* TOP 1 */ '0', N.NoticeNo, N.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, ND.Name AS DivisionName,
		--N.Content,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews,
		(SELECT COUNT(*) FROM NoticeSyn_Reference WHERE NoticeNo = N.NoticeNo) AS ViewUserCnt, N.TypeNo		
	FROM NoticesSyn N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	WHERE N.NoticeNo < noticesyn_getprenextnotice.noticeno -- and N.IsDelete=''
	order by N.NoticeNo desc


	
	-- 다음글;
	INSERT INTO tab	
	RETURN QUERY
	SELECT /* TOP 1 */ '1', N.NoticeNo, N.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, ND.Name AS DivisionName,
		--N.Content,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews,
		(SELECT COUNT(*) FROM NoticeSyn_Reference WHERE NoticeNo = N.NoticeNo) AS ViewUserCnt, N.TypeNo		
	FROM NoticesSyn N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	WHERE N.NoticeNo > noticesyn_getprenextnotice.noticeno 
	order by N.NoticeNo


	RETURN QUERY
	SELECT * FROM tab;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
