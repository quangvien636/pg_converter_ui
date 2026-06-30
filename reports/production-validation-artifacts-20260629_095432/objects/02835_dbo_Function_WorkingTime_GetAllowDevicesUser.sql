-- ─── FUNCTION: workingtime_getallowdevicesuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getallowdevicesuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getallowdevicesuser(
    userno integer
) RETURNS TABLE(
    allowdeviceno serial,
    departno integer,
    userno integer,
    contentallow text,
    moddate timestamp without time zone,
    regdate timestamp without time zone,
    isuserfull boolean,
    deviceid character varying(2000),
    verson character varying(100),
    sessionid character(32)
)
AS $function$
BEGIN

     DELETE FROM WorkingTime_AllowDevices where DeviceId  ILIKE '%0000-0000%';
	IF (SELECT COUNT(*) FROM WorkingTime_AllowDevices WHERE UserNo = workingtime_getallowdevicesuser.userno) = 0 BEGIN

		INSERT INTO WorkingTime_AllowDevices (DepartNo, UserNo, ContentAllow, ModDate, RegDate,IsUserFull)
		VALUES (0, UserNo, '[{"Device":"PC","Allow":true},{"Device":"MOBILE","Allow":true}]', NOW(), NOW(),0)
	END
	
	RETURN QUERY
	SELECT *
	FROM WorkingTime_AllowDevices WHERE UserNo = workingtime_getallowdevicesuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
