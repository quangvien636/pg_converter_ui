-- ─── PROCEDURE→FUNCTION: dday_getcountofappbadge ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_getcountofappbadge(integer);
CREATE OR REPLACE FUNCTION public.dday_getcountofappbadge(
    IN userno integer DEFAULT 70
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT BadgeCount, ListOfDays FROM DDay_CountOfAppBadge WHERE UserNo = dday_getcountofappbadge.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
