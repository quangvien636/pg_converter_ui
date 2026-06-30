-- ─── FUNCTION: notice_getreferencenotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getreferencenotices(integer);
CREATE OR REPLACE FUNCTION public.notice_getreferencenotices(
    noticeno integer
) RETURNS TABLE(
    userno text,
    departno text
)
AS $function$
BEGIN


		RETURN QUERY
		SELECT 
		  	COALESCE(CASE WHEN B.DepartNo IS NULL THEN R.Department ELSE  public."fn_GetDepartmentName"(B.DepartNo,'') END,'') AS  Department
			, COALESCE(Position,'') Position
			, R.Name, ReadDate
		FROM NoticeReference R
		LEFT JOIN Organization_Users U ON U.UserID = R.UserID
		LEFT JOIN ( SELECT UserNo, DepartNo FROM  Organization_BelongToDepartment WHERE IsDefault = TRUE GROUP BY UserNo, DepartNo) B 
		ON B.UserNo = U.UserNo 
		WHERE NoticeNo = notice_getreferencenotices.noticeno ORDER BY ReadDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
