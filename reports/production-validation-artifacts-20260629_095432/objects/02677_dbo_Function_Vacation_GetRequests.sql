-- ─── FUNCTION: vacation_getrequests ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_getrequests(integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_getrequests(
    p_uno integer,
    p_y integer,
    p_lang character varying DEFAULT 'KO',
    p_from character varying DEFAULT '2021-06-23',
    p_to character varying DEFAULT '2040-06-23'
) RETURNS TABLE(
    requestid text,
    userid text,
    name text,
    typei text,
    typename text,
    typeid text,
    timeview text,
    userno text,
    fromd text,
    tod text,
    col11 text,
    note text,
    datecreate text,
    col14 text,
    col15 text,
    col16 text,
    col17 text,
    timedis text,
    col19 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT 
		R.RequestId
		, U.UserID
		, U.Name
		, T.Typei
		, COALESCE(T.Name,'') as TypeName
		, T.TypeId
		, T.Time as TimeView
		, R.UserNo
		, R.Fromd
		, R.Tod
		, COALESCE(R.VacationsCount,0) VacationsCount
		, R.Note
		, R.DateCreate
		, COALESCE(R.StatusUser,0) StatusUser
		, COALESCE(R.StatusAdmin,0) StatusAdmin
		------------------------
		, X3.Used + COALESCE(v.Used,0) as Used 		--total used
		, COALESCE(V.Vacations,0) + COALESCE(X2.TimeDis,0) AS Vacations --total unused
		, t.TimeDis 
		, COALESCE(T.OffType,-1) OffType
	FROM  Vacation_Requests R
	LEFT JOIN Vacation_Vacations v ON R.UserNo = V.UserNo and v.years = vacation_getrequests.p_y 
	left join Vacation_Types T on R.TypeId = T.TypeId
	INNER JOIN Organization_Users U  ON U.UserNo = R.UserNo AND U.IsVirtual = FALSE
	LEFT JOIN Vacation_Sum X2 ON u.UserNo =  x2.UsernoI AND X2.YEARS =  vacation_getrequests.p_y
	LEFT JOIN Vacation_SumRequest X3 ON V.UserNo =  X3.UserNo and x3.years = vacation_getrequests.p_y
	WHERE R.UserNo = vacation_getrequests.p_uno AND R.Fromd >= vacation_getrequests.p_from AND R.Tod <= vacation_getrequests.p_to  
	AND R.StatusAdmin != 1
	AND YEAR(R.Tod) = vacation_getrequests.p_y;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
