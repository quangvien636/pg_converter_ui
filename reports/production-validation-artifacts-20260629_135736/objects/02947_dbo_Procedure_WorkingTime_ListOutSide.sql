-- ─── PROCEDURE→FUNCTION: workingtime_listoutside ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_listoutside(integer, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_listoutside(
    IN p_from integer,
    IN p_to integer,
    IN p_departno integer DEFAULT 0,
    IN p_groupno integer DEFAULT 0,
    IN p_uid character varying DEFAULT '',
    IN p_uname character varying DEFAULT '',
    IN p_unameen character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	
	CREATE TEMP TABLE ListOfUsers AS SELECT B.UserNo, U.UserID, U.Name, U.Name_EN,
		D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN,
		P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN,
		COALESCE(S.SortNo, P.SortNo) SortNo FROM Organization_BelongToDepartment B 
	INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	JOIN (SELECT u1.UserNo FROM Organization_Users U1 LEFT JOIN WorkingTime_AllowDevices A ON U1.userno = a.userno	where COALESCE(ContentAllow, 'true') ILIKE '%true%') AL ON U.UserNo = AL.UserNo
	LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and S.DepartNo = workingtime_listoutside.p_departno
	WHERE (p_DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_DepartNo, 0)))
	AND B.IsDefault = TRUE
	AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_listoutside.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_listoutside.p_groupno))
	AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
	AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%')
	AND (p_UNameEn = '' OR LOWER(U.Name_EN) ILIKE '%' || p_UNameEn || '%')
	SELECT
		L.UserNo,
		L.Name AS UserName,
		L.Name_EN AS UserNameEN,
		L.PositionName AS Position,
		L.PositionName_EN AS PositionEN,
		L.DepartName AS Department,
		L.DepartName_EN AS DepartmentEN,
		CONVERT(datetime, w.CheckDateTimeOffset) AS DateCheck1,
		L.SortNo
	FROM ListOfUsers L
	JOIN (
			SELECT X.UserNo, X.WorkingDayOfCompany, X.CheckDateTimeOffset
			FROM(
					SELECT t.UserNo, wt2.WorkingDayOfCompany, RN = ROW_NUMBER() OVER (PARTITION BY WorkingDayOfCompany ORDER BY CheckDateTimeOffset), wt2.CheckDateTimeOffset
					FROM WorkingTime_Times t
					INNER JOIN WorkingTime_Times_v2 wt2 ON t.WorkingNo = wt2.WorkingNo
					where t.TimeType IN( 2,4) and wt2.WorkingDayOfCompany BETWEEN p_From AND p_To
				) X --WHERE RN = 1	
		) W ON L.UserNo = W.UserNo
	ORDER BY w.WorkingDayOfCompany, L.SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
