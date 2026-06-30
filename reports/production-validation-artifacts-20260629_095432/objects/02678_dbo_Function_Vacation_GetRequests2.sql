-- ─── FUNCTION: vacation_getrequests2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_getrequests2(integer, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.vacation_getrequests2(
    p_uno integer,
    p_lang character varying DEFAULT 'KO',
    p_from character varying DEFAULT '2021-06-1',
    p_to character varying DEFAULT '2040-06-23',
    p_type integer DEFAULT 0
) RETURNS TABLE(
    requestid text,
    userid text,
    name text,
    typei text,
    typeid text,
    typename text,
    userno text,
    fromd text,
    timeview text,
    tod text,
    vacationscount text,
    note text,
    datecreate text,
    col14 text,
    col15 text,
    vacations text,
    used text,
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
					, T.TypeId
					, COALESCE(T.Name,'') as TypeName
					, R.UserNo
					, R.Fromd
					, T.Time as TimeView
					, R.Tod
					, R.VacationsCount
					, R.Note
					, R.DateCreate
					, COALESCE(R.StatusUser,0) StatusUser
					, COALESCE(R.StatusAdmin,0) StatusAdmin
					--, V.Vacations
					, V.Used
					, T.TimeDis
					, COALESCE(T.OffType,-1) OffType
				FROM  Vacation_Requests R
				LEFT JOIN Vacation_Vacations v ON R.UserNo = V.UserNo and years = p_y
				LEFT JOIN Vacation_Types T on R.TypeId = T.TypeId
				LEFT JOIN Organization_Users U ON U.UserNo = R.UserNo
				WHERE R.UserNo = vacation_getrequests2.p_uno AND (R.Fromd between p_from AND p_to or R.Tod  between p_from AND p_to) and ( r.TypeId = vacation_getrequests2.p_type or p_type = 0)
				AND R.StatusAdmin != 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
