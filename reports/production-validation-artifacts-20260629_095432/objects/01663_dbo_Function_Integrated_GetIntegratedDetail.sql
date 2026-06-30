-- ─── FUNCTION: integrated_getintegrateddetail ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getintegrateddetail(integer, integer);
CREATE OR REPLACE FUNCTION public.integrated_getintegrateddetail(
    integratedno integer,
    userno integer
) RETURNS TABLE(
    integratedno text,
    reguserno text,
    username text,
    positionname text,
    departname text,
    regdate text,
    moduserno text,
    moddate text,
    title text,
    divisionno text,
    divisionname text,
    content text,
    startdate text,
    enddate text,
    important text,
    isshare text,
    isattach text,
    totalviews text,
    currentviews text,
    iscontentimg text,
    col21 text
)
AS $function$
BEGIN


	IF (SELECT ReadDate FROM Integrated_Reference
		WHERE IntegratedNo = integrated_getintegrateddetail.integratedno AND UserNo = integrated_getintegrateddetail.userno) IS NULL BEGIN
	
		UPDATE Integrated_Reference
		SET ReadDate = NOW()
		WHERE IntegratedNo = integrated_getintegrateddetail.integratedno AND UserNo = integrated_getintegrateddetail.userno
		
		UPDATE Integrateds
		SET CurrentViews = CurrentViews + 1
		WHERE IntegratedNo = integrated_getintegrateddetail.integratedno
		
	END
	
	RETURN QUERY
	SELECT N.IntegratedNo, N.RegUserNo,
		U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
		N.RegDate, N.ModUserNo, N.ModDate,
		N.Title, N.DivisionNo, COALESCE(ND.Name,'') AS DivisionName,
		N.Content, N.StartDate, N.EndDate,
		N.Important, N.IsShare, N.IsAttach, N.TotalViews, N.CurrentViews, N.IsContentImg,
		(SELECT COUNT(*) FROM Integrated_Reference WHERE IntegratedNo = N.IntegratedNo) AS ViewUserCnt,
		N.TypeNo,
		N.TreeRoot, N.TreeNo,N.TreeItem2, N.TreeItem3,IT.Name as TreeName
	FROM Integrateds N
	LEFT JOIN Organization_Users U ON U.UserNo = N.RegUserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = N.RegUserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	LEFT JOIN NoticeSyn_Divisions ND ON ND.DivisionNo = N.DivisionNo
	LEFT JOIN Integrated_TreeItem IT ON IT.ID=N.TreeNo
	WHERE N.IntegratedNo = integrated_getintegrateddetail.integratedno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
