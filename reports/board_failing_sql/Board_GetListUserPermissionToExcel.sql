-- ─── PROCEDURE→FUNCTION: board_getlistuserpermissiontoexcel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getlistuserpermissiontoexcel(integer, integer, integer, integer, integer, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getlistuserpermissiontoexcel(
    IN itemno integer DEFAULT 25,
    IN itemtype integer DEFAULT 1,
    IN applicationno integer DEFAULT 7,
    IN departno integer DEFAULT 1,
    IN positionno integer DEFAULT 0,
    IN languagecode character varying DEFAULT 'EN',
    IN pagenumber integer DEFAULT 1,
    IN pagesize integer DEFAULT 10,
    IN ispermission boolean DEFAULT TRUE
) RETURNS TABLE(userid varchar, username varchar, "Admin" boolean, write boolean, "Read" boolean)
AS $function$
DECLARE
    total bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	--DECLARE ParentFolderNo INT;
	--IF(ItemType=1)
	--	SET ParentFolderNo= (SELECT ParentNo FROM Board_Folders  WHERE  FolderNo=ItemNo)
	--ELSE 
	--	SET ParentFolderNo= (SELECT FolderNo FROM Board_Boards  WHERE  BoardNo=ItemNo);
	Total := (SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	RETURN QUERY
	WITH 
	--UserParentPermistions AS(
	--	SELECT * FROM Board_AllowAccess WHERE ItemNo=ParentFolderNo AND ItemType=1
	--), 
	UserPermistions as (
		SELECT DISTINCT BA.UserNo,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =2 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =4 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
		FALSE  AS DisableAdmin ,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS DisableWrite ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue=4 OR BA.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
		FROM Board_AllowAccess BA 
		--LEFT JOIN UserParentPermistions UP ON UP.UserNo=BA.UserNo AND UP.ItemNo=ParentFolderNo AND UP.ItemType=1
		WHERE BA.ItemNo=board_getlistuserpermissiontoexcel.itemno AND BA.ItemType=board_getlistuserpermissiontoexcel.itemtype
	), 
	RootDeparts AS (
		  SELECT *
		  FROM Organization_Departments 
		  WHERE DepartNo = board_getlistuserpermissiontoexcel.departno
		  UNION ALL
		  SELECT OD.*
		  FROM Organization_Departments OD 
		  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	 ),
	 BelongToDepartment AS(
			SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.UserNo,T.DepartNo ORDER BY T.IsDefault) AS Nm FROM ORGANIZATION_BelongToDepartment T
	),
	 USERS AS(
		SELECT	ROW_NUMBER() OVER ( ORDER BY U.UserNo ) AS RowNum ,
			U.Name,
            U.UserId,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsAdmin IS NOT NULL THEN  UP.IsAdmin ELSE FALSE END AS IsAdmin ,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsRead ELSE FALSE END AS IsRead ,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsWrite ELSE FALSE END AS IsWrite 
			FROM ORGANIZATION_USERS U
		LEFT JOIN UserPermistions UP ON UP.UserNo=U.UserNo
		INNER JOIN BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.Nm=1
		INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
		INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
		LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
		LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=board_getlistuserpermissiontoexcel.applicationno
		WHERE (DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=board_getlistuserpermissiontoexcel.positionno OR PositionNo=0) AND U.Enabled = TRUE
	)--,
	--TOTAL AS (SELECT COUNT(*) AS Total  FROM USERS U)
	SELECT U.UserId,U.Name AS UserName,U.IsAdmin AS "Admin" ,U.IsWrite As Write ,U.IsRead AS "Read"
	FROM USERS U--,TOTAL T
	--LEFT JOIN UserParentPermistions  UP ON UP.UserNo=U.UserNo 
	WHERE U.RowNum >board_getlistuserpermissiontoexcel.pagesize*(PageNumber-1) AND U.RowNum <=board_getlistuserpermissiontoexcel.pagesize*PageNumber;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.