-- ─── FUNCTION: notice_getshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getshare(integer);
CREATE OR REPLACE FUNCTION public.notice_getshare(
    noticeno integer
) RETURNS TABLE(
    departno text,
    userno text,
    col3 text,
    col4 text,
    ischild text
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT N.DepartNo
		, N.UserNo
		, DepartName = COALESCE(D.Name, '')
		, UserName = COALESCE(U.Name, '')
		, IsChild 
	FROM NoticeSharers N
	LEFT JOIN Organization_Departments D on n.DepartNo = D.DepartNo
	LEFT JOIN Organization_Users U on N.UserNo = U.UserNo
	WHERE N.NoticeNo = notice_getshare.noticeno 
		AND (D.DepartNo  is not null or U.UserNo is not null);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
