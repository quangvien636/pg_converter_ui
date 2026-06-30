-- ─── PROCEDURE→FUNCTION: contacts_getuser_noname ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuser_noname(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_noname(
    IN userno integer,
    IN viewcount integer,
    IN currentpageindex integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
