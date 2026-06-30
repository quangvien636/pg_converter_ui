-- ─── PROCEDURE→FUNCTION: workingtime_moreoffs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_moreoffs(timestamp without time zone, timestamp without time zone, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_moreoffs(
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_type integer,
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
		COALESCE(S.SortNo, P.SortNo) SortNo FROM  Organization_Users U
	left join Organization_BelongToDepartment  B  ON U.UserNo = B.UserNo  AND U.IsVirtual = FALSE AND U.Enabled = TRUE and B.IsDefault = TRUE
	INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
	JOIN (SELECT u1.UserNo FROM Organization_Users U1 LEFT JOIN WorkingTime_AllowDevices A ON U1.userno = a.userno	where COALESCE(ContentAllow, 'true') ILIKE '%true%') AL ON U.UserNo = AL.UserNo
	LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and S.DepartNo = workingtime_moreoffs.p_departno
	WHERE (p_DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_DepartNo, 0)))
	AND ( (p_GroupNo = 0 OR U.GroupId = workingtime_moreoffs.p_groupno) OR (p_GroupNo !=  0 AND U.GroupId = workingtime_moreoffs.p_groupno))
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
		w.CheckTimeFull AS DateCheck1,
		L.SortNo,
		W.TimeType
	FROM ListOfUsers L
	JOIN (
					SELECT t.UserNo, t.CheckTimeFull, T.TimeType
					FROM WorkingTime_Times t
					where T.TimeType = workingtime_moreoffs.p_type and t.CheckTimeFull BETWEEN p_From AND p_To
		) W ON L.UserNo = W.UserNo
	ORDER BY w.CheckTimeFull, L.SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
