-- ─── FUNCTION: mail_getreceivedmonthlystatistic ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getreceivedmonthlystatistic(integer);
CREATE OR REPLACE FUNCTION public.mail_getreceivedmonthlystatistic(
    year integer
) RETURNS TABLE(
    month text,
    normalcount text,
    spamcount text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    currentmonth integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET CurrentMonth = 1



	WHILE (CurrentMonth < 13) BEGIN

		SET StartDate = CONVERT(DATE, CONVERT(VARCHAR, Year) + '-' || CONVERT(VARCHAR, CurrentMonth) + '-01')
		SET EndDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, StartDate))

		RETURN QUERY
		SELECT CurrentMonth AS Month, COALESCE(SUM(NormalCount), 0) AS NormalCount, COALESCE(SUM(SpamCount), 0) AS SpamCount
		FROM Mail_MailReceivedStatistics
		WHERE ReceivedDate BETWEEN StartDate AND EndDate 

		SET CurrentMonth = CurrentMonth + 1

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
