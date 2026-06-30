-- ─── FUNCTION: organization_getusersbyposition_paging ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getusersbyposition_paging(integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.organization_getusersbyposition_paging(
    currentpageindex integer,
    pagepercount integer,
    positionno integer,
    alsodisabled boolean
) RETURNS TABLE(
    rownum text,
    userno text,
    moduserno text,
    moddate text,
    userid text,
    name text,
    name_en text,
    mailaddress text,
    cellphone text,
    companyphone text,
    extensionnumber text,
    userphoto text,
    photo text,
    enabled text,
    departno text,
    departname text,
    departname_en text,
    departsortno text,
    positionno text,
    positionname text,
    positionname_en text,
    positionsortno text,
    dutyno text,
    dutyname text,
    dutyname_en text,
    dutysortno text,
    name_ch text,
    name_jp text,
    name_vn text,
    departname_ch text,
    departname_jp text,
    departname_vn text,
    positionname_ch text,
    positionname_jp text,
    positionname_vn text,
    dutyname_ch text,
    dutyname_jp text,
    dutyname_vn text
)
AS $function$
BEGIN


	IF (AlsoDisabled = 0) BEGIN
		
		RETURN QUERY
		SELECT COUNT(*) AS cnt
		FROM Organization_Users  U
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		LEFT JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo
		WHERE U.Enabled = TRUE AND U.IsVirtual = FALSE AND B.PositionNo = organization_getusersbyposition_paging.positionno

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
				ROW_NUMBER() OVER(ORDER BY B.UserNo) AS rowNum,
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
				D.Name AS DepartName,
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
				Organization_Users  U
			INNER JOIN 
				Organization_BelongToDepartment B ON B.UserNo = U.UserNo
			INNER JOIN 
				Organization_Positions P ON P.PositionNo = B.PositionNo
			INNER JOIN 
				Organization_Departments D ON D.DepartNo = B.DepartNo
			LEFT JOIN 
				Organization_Duties DT ON DT.DutyNo = B.DutyNo
			WHERE 
				U.Enabled = TRUE AND U.IsVirtual = FALSE AND B.PositionNo = organization_getusersbyposition_paging.positionno
		) AS sub
		WHERE
			sub.rowNum BETWEEN ((CurrentPageIndex - 1) * PagePerCount) + 1 AND PagePerCount * CurrentPageIndex

		
	END
	
	ELSE BEGIN

		RETURN QUERY
		SELECT COUNT(*) AS cnt
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		LEFT JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo
		WHERE U.IsVirtual = FALSE AND B.PositionNo = organization_getusersbyposition_paging.positionno

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
				ROW_NUMBER() OVER(ORDER BY B.UserNo) AS rowNum,
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
				D.Name AS DepartName, 
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
				Organization_Users U
			INNER JOIN 
				Organization_BelongToDepartment B ON B.UserNo = U.UserNo
			INNER JOIN 
				Organization_Positions P ON P.PositionNo = B.PositionNo
			INNER JOIN 
				Organization_Departments D ON D.DepartNo = B.DepartNo
			LEFT JOIN 
				Organization_Duties DT ON DT.DutyNo = B.DutyNo
			WHERE 
				U.IsVirtual = FALSE AND B.PositionNo = organization_getusersbyposition_paging.positionno
		) AS sub
		WHERE
			sub.rowNum BETWEEN ((CurrentPageIndex - 1) * PagePerCount) + 1 AND PagePerCount * CurrentPageIndex
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
