-- ─── PROCEDURE→FUNCTION: board_getlistnoticepermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getlistnoticepermission(integer, integer, integer, integer, character varying, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_getlistnoticepermission(
    IN itemno integer DEFAULT 25,
    IN applicationno integer DEFAULT 7,
    IN departno integer DEFAULT 1,
    IN positionno integer DEFAULT 0,
    IN languagecode character varying DEFAULT 'EN',
    IN pagenumber integer DEFAULT 1,
    IN pagesize integer DEFAULT 10,
    IN searchvalue character varying DEFAULT '',
    IN sortcolumn character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	Total := (SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	WITH 
	RootDeparts AS (
		  SELECT *
		  FROM Organization_Departments 
		  WHERE DepartNo = board_getlistnoticepermission.departno
		  UNION ALL
		  SELECT OD.*
		  FROM Organization_Departments OD 
		  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	 ),
	 BelongToDepartment AS(
			SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.UserNo,T.DepartNo ORDER BY T.IsDefault) AS Nm FROM ORGANIZATION_BelongToDepartment T
	),
	 USERS AS(
		SELECT	ROW_NUMBER() OVER (PARTITION BY U.Enabled  ORDER BY 
					CASE WHEN  SortColumn='' THEN  CASE LanguageCode WHEN 'EN' THEN  COALESCE(U.Name_EN,U.Name) WHEN 'VN' THEN  COALESCE(U.Name_VN,U.Name) WHEN 'CH' THEN COALESCE(U.Name_CH,U.Name)  WHEN 'JP' THEN COALESCE(U.Name_JP,U.Name) ELSE U.Name END END ASC,
					CASE WHEN  SortColumn='USERNAME' THEN  CASE LanguageCode WHEN 'EN' THEN  COALESCE(U.Name_EN,U.Name) WHEN 'VN' THEN  COALESCE(U.Name_VN,U.Name) WHEN 'CH' THEN COALESCE(U.Name_CH,U.Name)  WHEN 'JP' THEN COALESCE(U.Name_JP,U.Name) ELSE U.Name END END DESC
		) AS RowNum ,
			U.Name,
            U.UserId,
			U.UserNo,
			OB.DepartNo,
			OB.PositionNo,
			CASE WHEN LanguageCode='EN' THEN OD.Name_EN WHEN LanguageCode='VN' THEN OD.Name_VN WHEN LanguageCode='CH' THEN OD.Name_CH WHEN LanguageCode='JP' THEN OD.Name_JP ELSE OD.Name  END AS DepartName,
			CASE WHEN LanguageCode='EN' THEN OP.NAME_EN WHEN LanguageCode='VN' THEN OP.Name_VN WHEN LanguageCode='CH' THEN OP.Name_CH WHEN LanguageCode='JP' THEN OP.Name_JP ELSE OP.Name END  AS PositionName,
			CAST( CASE WHEN UP.AllowValue>0 THEN 1  ELSE 0 END AS BIT) AS IsAdmin 
		FROM ORGANIZATION_USERS U
		LEFT JOIN Board_NoticePermission UP ON UP.UserNo=U.UserNo
		INNER JOIN BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.Nm=1
		INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
		INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
		LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
		LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=board_getlistnoticepermission.applicationno
		WHERE  (DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=board_getlistnoticepermission.positionno OR PositionNo=0) AND U.Enabled = TRUE AND (U.UserID ILIKE '%' || SearchValue || '%' OR U.Name ILIKE '%' || SearchValue || '%'  )
	)

	RETURN QUERY
	SELECT (SELECT COUNT(*) AS Total  FROM USERS U) AS Total, U.Name,U.UserId,U.UserNo,U.DepartNo,U.PositionNo,U.DepartName,U.PositionName,U.IsAdmin
	FROM USERS U--,TOTAL T
	WHERE  U.RowNum >board_getlistnoticepermission.pagesize*(PageNumber-1) AND U.RowNum <=board_getlistnoticepermission.pagesize*PageNumber;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
