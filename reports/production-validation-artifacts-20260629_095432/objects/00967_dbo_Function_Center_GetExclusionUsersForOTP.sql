-- ─── FUNCTION: center_getexclusionusersforotp ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getexclusionusersforotp();
CREATE OR REPLACE FUNCTION public.center_getexclusionusersforotp(
) RETURNS TABLE(
    exclusionno text,
    userno text,
    departno text,
    startdate text,
    enddate text,
    allow text,
    sortno text,
    username text,
    username_en text,
    departname text,
    departname_en text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ExclusionNo, E.UserNo, E.DepartNo, StartDate, EndDate, Allow, E.SortNo,
		COALESCE(U.Name, '') AS UserName, COALESCE(U.Name_EN, '') AS UserName_EN,
		COALESCE(D.Name, '') AS DepartName, COALESCE(D.Name_EN, '') AS DepartName_EN
	FROM Center_ExclusionUsersForOTP E
	LEFT JOIN Organization_Users U ON U.UserNo = E.UserNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = E.DepartNo
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
