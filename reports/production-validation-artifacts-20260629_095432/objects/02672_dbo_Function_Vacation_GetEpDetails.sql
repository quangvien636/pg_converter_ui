-- ─── FUNCTION: vacation_getepdetails ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_getepdetails(integer, integer);
CREATE OR REPLACE FUNCTION public.vacation_getepdetails(
    p_y integer,
    p_uno integer
) RETURNS TABLE(
    requestid text,
    typename text,
    typei text,
    typeid text,
    userno text,
    userid text,
    fromd text,
    tod text,
    note text,
    datecreate text,
    col11 text,
    col12 text,
    typeforall text,
    timedis text,
    usernos text,
    departnos text
)
AS $function$
BEGIN


		RETURN QUERY
		SELECT 
				R.RequestId
			, T.Name as TypeName
			, T.Typei
			, T.TypeId
			, U.UserNo
			, U.UserId as UserID
			, R.Fromd
			, R.Tod
			, R.Note
			, R.DateCreate
			, COALESCE(R.StatusUser,0) StatusUser
			, COALESCE(R.StatusAdmin,0) StatusAdmin
			, R.TypeForAll
			, R.TimeDis
			, COALESCE(R.UserNo,CAST(U.UserNo as varchar) + ',') as UserNos
			, COALESCE(R.departno,'') as Departnos
		FROM  Vacation_RequestEps R
		LEFT JOIN Vacation_Types T on R.TypeId = T.TypeId
		LEFT JOIN Organization_Users u on r.UsernoI = u.UserNo
		where  YEAR(R.Tod) = vacation_getepdetails.p_y  
		AND r.UsernoI = vacation_getepdetails.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
