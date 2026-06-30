-- ─── PROCEDURE→FUNCTION: board_getiosdeviceofusersbydepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getiosdeviceofusersbydepartment(character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_getiosdeviceofusersbydepartment(
    IN listdepartno character varying,
    IN delimiter character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Board_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	and U.UserNo in (select * from public."fn_split_array"(ListUserNo,Delimiter))
	UNION
RETURN QUERY
SELECT DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Board_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	and U.UserNo in (select o.UserNo
from Organization_BelongToDepartment o
inner join Organization_Departments d on o.departno=d.departno
--inner join Organization_Users u on u.userno=o.userno
where  o.departno in (select * from FN_GetChildDepartNoByDepartNo(ListDepartNo,Delimiter))
--and u.Enabled = TRUE
);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.