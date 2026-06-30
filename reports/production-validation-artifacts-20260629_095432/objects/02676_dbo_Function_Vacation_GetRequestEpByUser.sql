-- ─── FUNCTION: vacation_getrequestepbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_getrequestepbyuser(integer, integer);
CREATE OR REPLACE FUNCTION public.vacation_getrequestepbyuser(
    p_uno integer,
    p_year integer
) RETURNS TABLE(
    requestid text,
    userno text,
    typename text,
    typei text,
    typeid text,
    usernos text,
    fromd text,
    tod text,
    vacationscount text,
    note text,
    datecreate text,
    typeforall text
)
AS $function$
BEGIN



					 R.RequestId
				FROM  Vacation_RequestEps  R
				where R.UsernoI = vacation_getrequestepbyuser.p_uno and YEAR(r.Tod) = vacation_getrequestepbyuser.p_year);;
DELETE FROM Vacation_RequestEps where UsernoI = vacation_getrequestepbyuser.p_uno and YEAR(Tod) = vacation_getrequestepbyuser.p_year and RequestId != p_type;

				RETURN QUERY
				SELECT 
					 R.RequestId
					 , R.UsernoI as UserNo
					, T.Name as TypeName
					, T.Typei
					, T.TypeId
					, R.UserNo as UserNos
					, R.Fromd
					, R.Tod
					, R.VacationsCount
					, R.Note
					, R.DateCreate
					, R.TypeForAll
				FROM  Vacation_RequestEps  R
				LEFT JOIN Vacation_Types T on R.TypeId = T.TypeId
				where R.UsernoI = vacation_getrequestepbyuser.p_uno and YEAR(r.Tod) = vacation_getrequestepbyuser.p_year;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
