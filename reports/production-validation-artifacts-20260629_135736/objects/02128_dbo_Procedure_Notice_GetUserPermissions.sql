-- ─── PROCEDURE→FUNCTION: notice_getuserpermissions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_getuserpermissions(integer, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.notice_getuserpermissions(
    IN departno integer,
    IN positionno integer,
    IN p_index integer,
    IN p_viewcount integer,
    IN p_uid character varying DEFAULT '',
    IN p_uname character varying DEFAULT '',
    IN p_pname character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	-- Get list departments include all childs
	WITH DepartmentTemp(DepartNo, ParentNo)
	 as (
			 CREATE TEMP TABLE ListDepartment AS SELECT DepartNo, ParentNo
			 From Organization_Departments
			 Where DepartNo = notice_getuserpermissions.departno
			 Union All
			 Select b.DepartNo, b.ParentNo
			 From DepartmentTemp as a, Organization_Departments as b
			 Where a.DepartNo = b.ParentNo and b.Enabled = TRUE
	 )
	 Select DepartNo FROM DepartmentTemp
	SELECT * FROM (
			SELECT 
				ROW_NUMBER() OVER(ORDER BY COALESCE(S.SortNo,99999) ASC, P.SortNo ASC, U.Name ASC) AS RowNum
				, pTotal = COUNT(*) OVER()
				,U.UserNo, U.UserID, 
				U.Name UserName, 
				U.Name_EN UserName_EN, 
				U.Name_CH UserName_CH, 
				U.Name_JP UserName_JP, 
				U.Name_VN UserName_VN, 
				P.PositionNo, 
				P.Name AS PositionName, 
				P.Name_EN AS PositionName_EN, 
				P.Name_CH AS PositionName_CH, 
				P.Name_JP AS PositionName_JP, 
				P.Name_VN AS PositionName_VN, 
				D.DepartNo, 
				COALESCE(Per.Permission,0) AS Permission 
				,COALESCE(Per.ViewEndDate,1) AS ViewEndDate 
			FROM Organization_Users U
				INNER JOIN (
						SELECT MAX(DepartNo) DepartNo, MAX(PositionNo) PositionNo, UserNo FROM Organization_BelongToDepartment bl
						WHERE EXISTS (Select l.DepartNo from ListDepartment l WHERE l.DepartNo = bl.DepartNo) OR DepartNo = 0
						GROUP BY UserNo
						) D ON U.UserNo = D.UserNo --AND D.DepartNo = DepartNo
				INNER JOIN Organization_Positions P ON  P.PositionNo = D.PositionNo
				LEFT JOIN Notice_UserPermission Per ON Per.UserNo = U.UserNo
				LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and s.DepartNo = notice_getuserpermissions.departno
			WHERE U.Enabled = TRUE 
				--AND (d.DepartNo IN (Select DepartNo from ListDepartment) OR DepartNo = 0) 
				AND (d.PositionNo = notice_getuserpermissions.positionno OR PositionNo = 0)
				AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
			    AND (p_UName = '' OR LOWER(U.Name + U.Name_EN + U.Name_CH+ U.Name_JP) ILIKE '%' || p_UName || '%')
			    AND (p_PName = '' OR LOWER(P.Name + P.Name_EN + P.Name_CH+ P.Name_JP) ILIKE '%' || p_PName || '%')
	) X  WHERE X.RowNum BETWEEN ((p_Index - 1) * p_ViewCount) + 1  AND (p_Index * p_ViewCount)
			order by X.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
