-- ─── FUNCTION: vacation_getrequestbewteens ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_getrequestbewteens(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_getrequestbewteens(
    p_uno integer,
    p_from character varying DEFAULT '2021-06-23',
    p_to character varying DEFAULT '2040-06-23'
) RETURNS TABLE(
    requestid text,
    typei text,
    typename text,
    typeid text,
    timeview text,
    userno text,
    fromd text,
    tod text,
    col9 text,
    note text,
    datecreate text,
    col12 text,
    col13 text,
    timedis text,
    col15 text
)
AS $function$
BEGIN


				RETURN QUERY
				SELECT 
					 R.RequestId
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
					, t.TimeDis
					 , COALESCE(T.OffType,-1) OffType
				FROM  Vacation_Requests R
				left join Vacation_Types T on R.TypeId = T.TypeId
				WHERE R.UserNo = vacation_getrequestbewteens.p_uno 
				AND (p_from between R.Fromd  AND R.Tod or p_to  between R.Fromd  AND R.Tod);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
