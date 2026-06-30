-- ─── PROCEDURE→FUNCTION: notice_getshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getshare(integer);
CREATE OR REPLACE FUNCTION public.notice_getshare(
    IN noticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
