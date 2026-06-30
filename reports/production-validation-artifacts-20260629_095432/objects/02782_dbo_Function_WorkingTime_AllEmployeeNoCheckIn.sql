-- ─── FUNCTION: workingtime_allemployeenocheckin ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_allemployeenocheckin(timestamp without time zone, timestamp without time zone, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_allemployeenocheckin(
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_depart integer DEFAULT 0,
    p_groupno integer DEFAULT 0,
    p_uid character varying DEFAULT '',
    p_uname character varying DEFAULT '',
    p_unameen character varying DEFAULT ''
) RETURNS TABLE(
    workingdayc text
)
AS $function$
BEGIN


		UserNo				INT,
		ModUserNo			INT,
		ModDate				DATETIME,
		UserID				VARCHAR(100),
		Name				NVARCHAR(100),
		Name_EN				NVARCHAR(100),
		MailAddress			NVARCHAR(200),
		CellPhone			VARCHAR(100),
		CompanyPhone		VARCHAR(100),
		UserPhoto			BIT,
		Photo				NVARCHAR(500),
		Enabled			BIT,
		DepartNo			INT,
		DepartName			NVARCHAR(100),
		DepartName_EN		NVARCHAR(100),
		DepartSortNo		INT,
		PositionNo			INT,
		PositionName		NVARCHAR(100),
		PositionName_EN		NVARCHAR(100),
		PositionSortNo		INT
		
	)

	INSERT INTO ListOfUsers
	RETURN QUERY
	SELECT 

		B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone, U.UserPhoto, U.Photo, U.Enabled,
		D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
		P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo
	FROM Organization_BelongToDepartment B 
	INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	JOIN (SELECT u.UserNo FROM Organization_Users U
			LEFT JOIN WorkingTime_AllowDevices A
			ON U.userno = a.userno
			where COALESCE(ContentAllow, 'true') ILIKE '%true%'
		) AL ON U.UserNo = AL.UserNo
	LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
	LEFT JOIN WorkingTime_SettingGroup G ON U.GroupId = G.ID
	WHERE (p_Depart = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_Depart, 0)))
	AND B.IsDefault = TRUE --AND U.Enabled = TRUE AND U.IsVirtual = FALSE
	AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_allemployeenocheckin.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_allemployeenocheckin.p_groupno))
	---------------------------- End Filter user hide when no permission-------------------------

	IF (p_To > NOW()) SET p_To = NOW();
	RETURN QUERY
	SELECT
		L.UserNo,
		L.Name AS UserName,
		L.Name_EN AS UserNameEN,
		L.PositionName AS Position,
		L.PositionName_EN AS PositionEN,
		L.DepartName AS Department,
		L.DepartName_EN AS DepartmentEN,
		I.DateInsert AS DateCheck1,
		L.PositionSortNo AS SortNo
	FROM WorkingTime_DateInsert i
	INNER JOIN ListOfUsers L ON 1 = 1
	WHERE  i.DateInsert <= workingtime_allemployeenocheckin.p_to 
		AND  i.DateInsert >= workingtime_allemployeenocheckin.p_from
		AND i.DateInt NOT IN (
				SELECT 
					wt.WorkingDayC
				FROM WorkingTime_Times wt 
				LEFT JOIN WorkingTime_RequestCorrectionTime wr ON wt.WorkingNo = wr.WorkingNo
				WHERE WorkingDayC BETWEEN CAST(CONVERT(VARCHAR(8), p_From, 112) AS INT) 
					AND CAST(CONVERT(VARCHAR(8), p_To, 112) AS INT) AND wt.TimeType IN (1, 8)
					AND wt.UserNo = L.UserNo
		)
	ORDER BY DateCheck1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
