-- ─── FUNCTION: integrate_getprenext ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrate_getprenext(integer);
CREATE OR REPLACE FUNCTION public.integrate_getprenext(
    integratedno integer
) RETURNS TABLE(
    integratedno serial,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying(300),
    divisionno integer,
    content text,
    startdate date,
    enddate date,
    important boolean,
    isshare boolean,
    isattach boolean,
    totalviews integer,
    currentviews integer,
    iscontentimg boolean,
    treeroot integer,
    treeno integer,
    treeitem2 integer,
    treeitem3 integer,
    typeno integer,
    isdelete character(1),
    isimportant boolean
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    treeno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


--select TreeNo = TreeNo from Integrateds where IntegratedNo=IntegratedNo


	Type CHAR(1),
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
