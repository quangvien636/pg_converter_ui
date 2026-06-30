-- ─── PROCEDURE→FUNCTION: contacts_getuser_touserno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuser_touserno(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_touserno(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
	U.Seq
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
	WHERE U.Seq = contacts_getuser_touserno.userno
	AND U.UseYn = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
