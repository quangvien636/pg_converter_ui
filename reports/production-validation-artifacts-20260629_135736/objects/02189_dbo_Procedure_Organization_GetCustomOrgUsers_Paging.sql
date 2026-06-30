-- ─── PROCEDURE→FUNCTION: organization_getcustomorgusers_paging ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getcustomorgusers_paging(integer, integer, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.organization_getcustomorgusers_paging(
    IN currentpageindex integer,
    IN pagepercount integer,
    IN searchtext character varying,
    IN departno integer,
    IN userno integer,
    IN auth integer
) RETURNS SETOF record
AS $function$
DECLARE
    departnolist table (
		departno	int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	IF Auth = 1 THEN

		IF DepartNo =0 THEN;
		INSERT INTO departnolist select departno from Organization_Departments where Enabled = TRUE;
		ELSE;
		INSERT INTO departnolist select departno from Organization_Departments where Enabled = TRUE and DepartNo = organization_getcustomorgusers_paging.departno
	
	END IF;
	ELSE

		IF DepartNo =0 THEN;
		INSERT INTO departnolist select SharedDepartNo  as departno  from CustomOrg_AuthInfo where UserNo = organization_getcustomorgusers_paging.userno
		ELSE;
		INSERT INTO departnolist select SharedDepartNo  as departno  from CustomOrg_AuthInfo where UserNo = organization_getcustomorgusers_paging.userno and SharedDepartNo = organization_getcustomorgusers_paging.departno
		
	END IF;


	RETURN QUERY
	SELECT COUNT(*)
				FROM 
					Organization_BelongToDepartment B
				INNER JOIN 
					Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
				INNER JOIN 
					Organization_Positions P ON P.PositionNo = B.PositionNo
				INNER JOIN 
					Organization_Departments D ON D.DepartNo = B.DepartNo
				LEFT JOIN 
					Organization_Duties DT ON DT.DutyNo = B.DutyNo
				WHERE 
					B.DepartNo in (select * from departnolist)
				AND U.Name ILIKE '%' || SearchText || '%'


	RETURN QUERY
	SELECT
			sub.UserNo, 
			sub.ModUserNo, 
			sub.ModDate, 
			sub.UserID, 
			sub.Name, 
			sub.Name_EN, 
			sub.MailAddress, 
			sub.CellPhone, 
			sub.CompanyPhone, 
			sub.ExtensionNumber,
			sub.UserPhoto, 
			sub.Photo,
			sub.Enabled, 
			sub.DepartNo, 
			sub.DepartName, 
			sub.DepartName_EN, 
			sub.DepartSortNo, 
			sub.PositionNo, 
			sub.PositionName, 
			sub.PositionName_EN, 
			sub.PositionSortNo,
			sub.DutyNo, 
			sub.DutyName, 
			sub.DutyName_EN, 
			sub.DutySortNo, 
			sub.Name_CH,
			sub.Name_JP,
			sub.Name_VN,
			sub.DepartName_CH,
			sub.DepartName_JP,
			sub.DepartName_VN,
			sub.PositionName_CH,
			sub.PositionName_JP,
			sub.PositionName_VN,
			sub.DutyName_CH,
			sub.DutyName_JP,
			sub.DutyName_VN
		FROM
		(
			SELECT 
					ROW_NUMBER() OVER(ORDER BY P.SortNo,U.Name) AS rowNum,
					B.UserNo, 
					U.ModUserNo, 
					U.ModDate, 
					U.UserID, 
					U.Name, 
					U.Name_EN, 
					U.MailAddress, 
					U.CellPhone, 
					U.CompanyPhone,
					U.ExtensionNumber,
					U.UserPhoto, 
					U.Photo, 
					U.Enabled,
					D.DepartNo, 
					public."Organization_Departments_GetPath"(D.DepartNo) AS DepartName, 
					--D.Name AS DepartName, 
					D.Name_EN AS DepartName_EN, 
					D.SortNo AS DepartSortNo,
					P.PositionNo, 
					P.Name AS PositionName, 
					P.Name_EN AS PositionName_EN, 
					P.SortNo AS PositionSortNo,
					COALESCE(DT.DutyNo, 0) AS DutyNo, 
					COALESCE(DT.Name, '') AS DutyName, 
					COALESCE(DT.Name_EN, '') AS DutyName_EN, 
					COALESCE(DT.SortNo, 9999) AS DutySortNo,
					U.Name_CH,
					U.Name_JP,
					U.Name_VN,
					D.Name_CH AS DepartName_CH,
					D.Name_JP AS DepartName_JP,
					D.Name_VN AS DepartName_VN,
					P.Name_CH AS PositionName_CH,
					P.Name_JP AS PositionName_JP,
					P.Name_VN AS PositionName_VN,
					COALESCE(DT.Name_CH, '') AS DutyName_CH,
					COALESCE(DT.Name_JP, '') AS DutyName_JP,
					COALESCE(DT.Name_VN, '') AS DutyName_VN
				FROM 
					Organization_BelongToDepartment B
				INNER JOIN 
					Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
				INNER JOIN 
					Organization_Positions P ON P.PositionNo = B.PositionNo
				INNER JOIN 
					Organization_Departments D ON D.DepartNo = B.DepartNo
				LEFT JOIN 
					Organization_Duties DT ON DT.DutyNo = B.DutyNo
				WHERE 
					B.DepartNo in (select * from departnolist)
				AND U.Name ILIKE '%' || SearchText || '%'
		
		) 
		AS sub
		WHERE
			sub.rowNum BETWEEN ((CurrentPageIndex - 1) * PagePerCount) + 1 AND PagePerCount * CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
