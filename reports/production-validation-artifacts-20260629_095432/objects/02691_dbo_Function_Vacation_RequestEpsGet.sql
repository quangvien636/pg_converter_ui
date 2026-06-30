-- ─── FUNCTION: vacation_requestepsget ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_requestepsget(integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_requestepsget(
    p_y integer,
    p_index integer,
    p_viewcount integer,
    p_uname character varying DEFAULT '',
    p_lang character varying DEFAULT 'KO'
) RETURNS TABLE(
    requestid text,
    rownum text,
    col3 text,
    col4 text,
    col5 text,
    userno text,
    userid text,
    name text,
    timedis text,
    used text
)
AS $function$
BEGIN




RETURN QUERY
select * from
(
				SELECT 
					0 AS RequestId
					 ,ROW_NUMBER() OVER(ORDER BY U.Name ASC) AS RowNum
					, pTotal = COUNT(*) OVER()
					, pSize = vacation_requestepsget.p_viewcount
					, pIndex = vacation_requestepsget.p_index
					, U.UserNo
					, U.UserId as UserID
					, U.Name
					, v.TimeDis
					, v.UseVacationCnt  AS Used
				FROM  Vacation_Sum v 
				LEFT JOIN Organization_Users u on v.UsernoI = u.UserNo
				where v.years= vacation_requestepsget.p_y and (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%' OR LOWER(U.UserID) ILIKE '%' || p_UName || '%')
)x WHERE X.RowNum BETWEEN ((p_Index - 1) * p_ViewCount) + 1  AND (p_Index * p_ViewCount)
			order by X.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
