-- ─── FUNCTION: edmsgetadminlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetadminlist(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmsgetadminlist(
    adminall character varying DEFAULT 'N',
    searchuser character varying DEFAULT '',
    langcode character varying DEFAULT 'KO'
) RETURNS TABLE(
    userno text,
    userid text,
    username text,
    topdeptname text,
    deptname text,
    adminflag text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT 
		U.UserNo, 
		U.UserId, 
		CASE WHEN LangCode = 'KO' THEN U.Name
			WHEN LangCode = 'CH' THEN U.Name_CH
			WHEN LangCode = 'EN' THEN U.Name_EN
			WHEN LangCode = 'JP' THEN U.Name_JP
			WHEN LangCode = 'VN' THEN U.Name_VN
		ELSE
			U.Name
		END AS UserName,
		public."COMNGetDepartName"(public."GetDepartMentTop"(B.DepartNo)) AS TopDeptName,  
		CASE WHEN LangCode = 'KO' THEN D.Name
			WHEN LangCode = 'CH' THEN D.Name_CH
			WHEN LangCode = 'EN' THEN D.Name_EN
			WHEN LangCode = 'JP' THEN D.Name_JP
			WHEN LangCode = 'VN' THEN D.Name_VN
		ELSE
			D.Name
		END AS DeptName,
		COALESCE(E.AdminFlag,'') AS AdminFlag
	FROM Organization_Users U
	INNER JOIN Organization_BelongToDepartment B ON U.UserNo = B.UserNo AND B.IsDefault = TRUE
	INNER JOIN Organization_Departments D ON B.DepartNo = D.DepartNo
	INNER JOIN Organization_Positions P ON B.PositionNo = P.PositionNo 
	LEFT OUTER JOIN EDMSUSERENV E ON U.UserID = E.UserID
	WHERE (0 = DepartNo OR B.DepartNo = DepartNo) 
	AND ('' = edmsgetadminlist.adminall OR COALESCE(E.AdminFlag,'') = edmsgetadminlist.adminall)
	AND (U.UserID ILIKE '%' || SearchUser || '%' 
		OR U.Name ILIKE '%' || SearchUser || '%' 
		OR U.Name_EN ILIKE '%' || SearchUser || '%'
		OR U.Name_JP ILIKE '%' || SearchUser || '%'
		OR U.Name_VN ILIKE '%' || SearchUser || '%'
		OR U.Name_CH ILIKE '%' || SearchUser || '%')
	ORDER BY P.SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
