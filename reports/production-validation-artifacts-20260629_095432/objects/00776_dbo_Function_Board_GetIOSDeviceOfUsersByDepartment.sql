-- ─── FUNCTION: board_getiosdeviceofusersbydepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getiosdeviceofusersbydepartment(character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_getiosdeviceofusersbydepartment(
    listdepartno character varying,
    delimiter character varying
) RETURNS TABLE(
    userno serial,
    moduserno integer,
    moddate timestamp without time zone,
    userid character varying(100),
    password character varying(200),
    passwordchangedate timestamp without time zone,
    name character varying(100),
    name_en character varying(100),
    mailaddress character varying(200),
    sex integer,
    cellphone character varying(100),
    companyphone character varying(100),
    extensionnumber character varying(20),
    entrancedate timestamp without time zone,
    birthdate timestamp without time zone,
    userphoto boolean,
    photo character varying(500),
    timezone character varying(200),
    enabled boolean,
    isvirtual boolean,
    name_ch character varying(200),
    name_jp character varying(200),
    name_vn character varying(200),
    workplacetype character varying(20),
    groupid integer,
    skinname character varying(50),
    faxnumber character varying(100),
    failedlogincount integer,
    birthdatetype integer
)
AS $function$
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
