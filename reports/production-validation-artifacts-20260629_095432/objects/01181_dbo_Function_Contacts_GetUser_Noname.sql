-- ─── FUNCTION: contacts_getuser_noname ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_noname(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_noname(
    userno integer,
    viewcount integer,
    currentpageindex integer
) RETURNS TABLE(
    totalcnt text,
    rownum text,
    seq text,
    firstname text,
    lastname text,
    reguserno text,
    memo text,
    regdate text,
    photo text,
    moddate text,
    checkdate text,
    share text,
    useyn text,
    deldate text,
    important text,
    callname text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM (SELECT 
	CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
	,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.RegDate DESC)) AS RowNum
	,U.Seq
	,U.FirstName
	,U.LastName
	,U.RegUserNo
	,U.Memo
	,U.RegDate
	,U.Photo
	,U.ModDate
	,U.CheckDate
	,U.Share
	,U.UseYn
	,U.DelDate
	,U.Important
	,U.CallName
	FROM ContactsUser U
	WHERE LTRIM(U.FirstName) = '' AND LTRIM(U.LastName) = ''
	AND U.RegUserNo = contacts_getuser_noname.userno) T 
	WHERE T.RowNum
	BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
	AND CurrentPageIndex * ViewCount;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
