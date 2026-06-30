-- ─── PROCEDURE→FUNCTION: personal_getgroupone ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.personal_getgroupone(integer, integer);
CREATE OR REPLACE FUNCTION public.personal_getgroupone(
    IN groupno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		GroupNo,
		GroupName,
		Description,
		ShareType,
		DepartNo,
		CASE WHEN RegUserNo = personal_getgroupone.userno THEN 'Y' ELSE '' END ModYN
	FROM PersonalGroup
	WHERE GroupNo = personal_getgroupone.groupno
	
	RETURN QUERY
	SELECT
		UserNo,
		public."COMNGetUserName"(UserNo) AS UserName
	FROM PersonalGroupUser
	WHERE GroupNo = personal_getgroupone.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
