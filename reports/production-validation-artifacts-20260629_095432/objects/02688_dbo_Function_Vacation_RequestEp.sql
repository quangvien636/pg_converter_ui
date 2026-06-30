-- ─── FUNCTION: vacation_requestep ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_requestep(integer);
CREATE OR REPLACE FUNCTION public.vacation_requestep(
    p_no integer
) RETURNS TABLE(
    requestid text,
    userid text,
    name text,
    typename text,
    typei text,
    typeid text,
    userno text,
    fromd text,
    tod text,
    vacationscount text,
    note text,
    datecreate text,
    col13 text,
    col14 text,
    vacations text,
    used text,
    typeforall text
)
AS $function$
BEGIN



				RETURN QUERY
				SELECT 
					 R.RequestId
					, U.UserID
					, U.Name
					, T.Name as TypeName
					, T.Typei
					, T.TypeId
					, R.UserNo
					, R.Fromd
					, R.Tod
					, R.VacationsCount
					, R.Note
					, R.DateCreate
					, COALESCE(R.StatusUser,0) StatusUser
					, COALESCE(R.StatusAdmin,0) StatusAdmin
					, V.Vacations
					, V.Used
					, R.TypeForAll
				FROM  Vacation_RequestEps R
				LEFT JOIN Vacation_Vacations v ON R.UserNo = V.UserNo
				LEFT JOIN Vacation_Types T on R.TypeId = T.TypeId
				LEFT JOIN Organization_Users U ON U.UserNo = R.UserNo
				where R.RequestId = vacation_requestep.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
