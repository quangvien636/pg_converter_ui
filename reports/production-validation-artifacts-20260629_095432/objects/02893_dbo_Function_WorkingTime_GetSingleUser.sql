-- ─── FUNCTION: workingtime_getsingleuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsingleuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsingleuser(
    userno integer
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
	SELECT * FROM Organization_Users
	WHERE UserNo=workingtime_getsingleuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
