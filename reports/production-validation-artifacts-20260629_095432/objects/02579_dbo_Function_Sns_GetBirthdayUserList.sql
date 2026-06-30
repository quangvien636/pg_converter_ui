-- ─── FUNCTION: sns_getbirthdayuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getbirthdayuserlist(integer);
CREATE OR REPLACE FUNCTION public.sns_getbirthdayuserlist(
    mode integer
) RETURNS TABLE(
    userno text,
    name text,
    birthday text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0	--월/일 비교
	BEGIN
		RETURN QUERY
		SELECT UserNo,Name,Birthday FROM Organization_Users 
		WHERE MONTH(Birthday) = MONTH(NOW())
		AND DAY(Birthday) = DAY(NOW())
		AND Enabled = TRUE
	END
	ELSE IF Mode = 1	--월 비교
	BEGIN
		RETURN QUERY
		SELECT UserNo,Name,Birthday FROM Organization_Users 
		WHERE MONTH(Birthday) = MONTH(NOW())
		AND Enabled = TRUE
	END
	ELSE IF Mode = 2	--월/주 비교(해당주에 생일자/월요일~일요일)
	BEGIN
		RETURN QUERY
		SELECT UserNo,Name,Birthday FROM Organization_Users 
		WHERE MONTH(Birthday) = MONTH(NOW())
		AND DAY(Birthday) BETWEEN DAY(DateAdd(Day,-(DatePart(dw,NOW())-2),NOW()))
		AND DAY(DateAdd(Day,(8-DatePart(dw,NOW())),NOW()))
		AND Enabled = TRUE
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
