-- ─── PROCEDURE→FUNCTION: integrated_getintegrateddetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_getintegrateddetail(integer, integer);
CREATE OR REPLACE FUNCTION public.integrated_getintegrateddetail(
    IN integratedno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF SELECT ReadDate FROM Integrated_Reference (NOLOCK THEN
		WHERE IntegratedNo = integrated_getintegrateddetail.integratedno AND UserNo = integrated_getintegrateddetail.userno) IS NULL BEGIN
	
		UPDATE Integrated_Reference
		ReadDate := NOW();
		WHERE IntegratedNo = integrated_getintegrateddetail.integratedno AND UserNo = integrated_getintegrateddetail.userno
		
		UPDATE Integrateds
		CurrentViews := CurrentViews + 1;
		WHERE IntegratedNo = integrated_getintegrateddetail.integratedno
		
	END;
	
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
