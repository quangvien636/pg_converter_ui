-- ─── PROCEDURE→FUNCTION: voteauthlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.voteauthlist(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteauthlist(
    IN itemsperpage integer,
    IN currentpage integer,
    IN departno integer,
    IN positionno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- Total Count
	RETURN QUERY
	SELECT 
		COUNT(*) Cnt
	FROM 
		Organization_BelongToDepartment B
	INNER JOIN 
		Organization_Users U ON (U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE)
	INNER JOIN 
		Organization_Positions P ON (P.PositionNo = B.PositionNo)
	LEFT JOIN 
		VOTEAuthority A ON (U.UserNo = A.UserNo)
	WHERE B.IsDefault = TRUE AND B.DepartNo = voteauthlist.departno
	AND
	(
		CASE
		WHEN PositionNo > 0  AND P.PositionNo = voteauthlist.positionno THEN 1
		WHEN PositionNo = 0 THEN 1
		ELSE 0 END
	) = 1;

	-- Department
	WITH LIstDepartments AS 
	(
		SELECT ParentNo, DepartNo,
		CASE 
		WHEN Lang = 'KO' THEN Name 
		WHEN Lang = 'EN' THEN Name_EN
		WHEN Lang = 'VN' THEN Name_VN
		WHEN Lang = 'JP' THEN Name_JP
		WHEN Lang = 'CH' THEN Name_CH ELSE Name END AS Name
		FROM Organization_Departments WHERE DepartNo = voteauthlist.departno
	)

	-- List
	RETURN QUERY
	SELECT *
	FROM
	(
		SELECT
			ROW_NUMBER() OVER(ORDER BY P.SortNo ASC, U.Name ASC) AS RowNum,
			U.UserID,
			U.UserNo,
			CASE 
			WHEN Lang = 'KO' THEN U.Name 
			WHEN Lang = 'EN' THEN U.Name_EN
			WHEN Lang = 'VN' THEN U.Name_VN
			WHEN Lang = 'JP' THEN U.Name_JP
			WHEN Lang = 'CH' THEN U.Name_CH ELSE U.Name END AS Name,
			D.DepartNo,
			D.Name AS DepartName,
			P.PositionNo,
			CASE 
			WHEN Lang = 'KO' THEN P.Name 
			WHEN Lang = 'EN' THEN P.Name_EN
			WHEN Lang = 'VN' THEN P.Name_VN
			WHEN Lang = 'JP' THEN P.Name_JP
			WHEN Lang = 'CH' THEN P.Name_CH ELSE P.Name END AS PositionName,
			A.IsFullAuth,
			A.IsRegMod
		FROM 
			Organization_BelongToDepartment B
		INNER JOIN 
			Organization_Users U ON (U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE)
		INNER JOIN 
			LIstDepartments D ON (D.DepartNo = B.DepartNo)
		INNER JOIN 
			Organization_Positions P ON (P.PositionNo = B.PositionNo)
		LEFT JOIN 
			VOTEAuthority A ON (U.UserNo = A.UserNo)
		WHERE B.IsDefault = TRUE
		AND
		(
			CASE
			WHEN PositionNo > 0  AND P.PositionNo = voteauthlist.positionno THEN 1
			WHEN PositionNo = 0 THEN 1
			ELSE 0 END
		) = 1
	) AS R1
	WHERE R1.RowNum BETWEEN ((CurrentPage - 1) * ItemsPerPage) + 1 AND CurrentPage * ItemsPerPage;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
