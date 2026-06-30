-- ─── PROCEDURE→FUNCTION: sns_getbirthdayuserlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.sns_getbirthdayuserlist(integer);
CREATE OR REPLACE FUNCTION public.sns_getbirthdayuserlist(
    IN mode integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0	--월/일 비교 THEN
		RETURN QUERY
		SELECT UserNo,Name,Birthday FROM Organization_Users 
		WHERE MONTH(Birthday) = MONTH(NOW())
		AND DAY(Birthday) = DAY(NOW())
		AND Enabled = TRUE
	END IF;
	ELSIF Mode = 1	--월 비교 THEN
		RETURN QUERY
		SELECT UserNo,Name,Birthday FROM Organization_Users 
		WHERE MONTH(Birthday) = MONTH(NOW())
		AND Enabled = TRUE
	END IF;
	ELSIF Mode = 2	--월/주 비교(해당주에 생일자/월요일~일요일) THEN
		RETURN QUERY
		SELECT UserNo,Name,Birthday FROM Organization_Users 
		WHERE MONTH(Birthday) = MONTH(NOW())
		AND DAY(Birthday) BETWEEN DAY(DateAdd(Day,-(DatePart(dw,NOW())-2),NOW()))
		AND DAY(DateAdd(Day,(8-DatePart(dw,NOW())),NOW()))
		AND Enabled = TRUE
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
