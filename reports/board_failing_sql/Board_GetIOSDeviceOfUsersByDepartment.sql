-- ─── PROCEDURE→FUNCTION: board_getiosdeviceofusersbydepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getiosdeviceofusersbydepartment(character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_getiosdeviceofusersbydepartment(
    IN listdepartno character varying,
    IN delimiter character varying
) RETURNS TABLE(deviceid varchar, osversion varchar, notificationoptions integer, timezoneoffset integer)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT A.DeviceID, A.OSVersion, A.NotificationOptions, A.TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Board_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	AND U.UserNo IN (SELECT * FROM public."fn_split_array"(board_getiosdeviceofusersbydepartment.listdepartno, board_getiosdeviceofusersbydepartment.delimiter))
	UNION
SELECT A.DeviceID, A.OSVersion, A.NotificationOptions, A.TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Board_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	AND U.UserNo IN (SELECT o.UserNo
FROM Organization_BelongToDepartment o
INNER JOIN Organization_Departments d ON o.departno = d.departno
WHERE o.departno IN (SELECT * FROM FN_GetChildDepartNoByDepartNo(board_getiosdeviceofusersbydepartment.listdepartno, board_getiosdeviceofusersbydepartment.delimiter))
);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.