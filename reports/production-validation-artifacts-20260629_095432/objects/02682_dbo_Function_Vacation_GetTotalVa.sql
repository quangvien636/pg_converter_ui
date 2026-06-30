-- ─── FUNCTION: vacation_gettotalva ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_gettotalva(character varying, integer);
CREATE OR REPLACE FUNCTION public.vacation_gettotalva(
    p_uid character varying,
    p_y integer
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
			SELECT 
				 COALESCE(V.Vacations,0) + X2.Addition1 + X2.Addition2 AS Vacations
			FROM (select * from  Organization_Users where UserID = vacation_gettotalva.p_uid) U 
			LEFT JOIN Vacation_Vacations V ON V.UserNo =  U.UserNo AND (V.years = vacation_gettotalva.p_y)
			LEFT JOIN Vacation_Sum X2 ON u.UserNo =  x2.UsernoI AND X2.YEARS =  vacation_gettotalva.p_y
			LEFT JOIN Vacation_SumRequest X3 ON u.UserNo =  X3.UserNo and x3.years = vacation_gettotalva.p_y;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
