-- ─── PROCEDURE→FUNCTION: voteresultlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.voteresultlist(integer);
CREATE OR REPLACE FUNCTION public.voteresultlist(
    IN id integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- List
	RETURN QUERY
	SELECT
	--(select /* TOP 1 */ Title from VOTESubItem where MasterID = ID and VOTESubItem.ParentID = R.ParentID) as Title,
	R.*, U.UserID,
	CASE 
	WHEN Lang = 'KO' THEN U.Name 
	WHEN Lang = 'EN' THEN U.Name_EN
	WHEN Lang = 'VN' THEN U.Name_VN
	WHEN Lang = 'JP' THEN U.Name_JP
	WHEN Lang = 'CH' THEN U.Name_CH ELSE U.Name END AS UserName,
	CASE 
	WHEN Lang = 'KO' THEN D.Name 
	WHEN Lang = 'EN' THEN D.Name_EN
	WHEN Lang = 'VN' THEN D.Name_VN
	WHEN Lang = 'JP' THEN D.Name_JP
	WHEN Lang = 'CH' THEN D.Name_CH ELSE D.Name END AS DepartName,
	CASE 
	WHEN Lang = 'KO' THEN P.Name 
	WHEN Lang = 'EN' THEN P.Name_EN
	WHEN Lang = 'VN' THEN P.Name_VN
	WHEN Lang = 'JP' THEN P.Name_JP
	WHEN Lang = 'CH' THEN P.Name_CH ELSE D.Name END AS PositionName
	FROM VOTEResult R
	JOIN
	(
		SELECT *
		FROM 
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY UserNo ORDER BY UserNo DESC) AS RowNum, UserNo, DepartNo, PositionNo
			FROM Organization_BelongToDepartment
		) R1
		WHERE RowNum = 1 -- Deduplication
	) B ON (R.UserNo = B.UserNo)
	JOIN Organization_Users U ON (R.UserNo = U.UserNo)
	JOIN Organization_Departments D ON (B.DepartNo = D.DepartNo)
	JOIN Organization_Positions P ON (B.PositionNo = P.PositionNo)
	WHERE MasterID = voteresultlist.id
	ORDER BY U.UserNo, R.ParentID;
	--ORDER BY U.UserNo, R.Type
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
