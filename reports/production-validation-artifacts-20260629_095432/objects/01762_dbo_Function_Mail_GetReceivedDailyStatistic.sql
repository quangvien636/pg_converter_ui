-- ─── FUNCTION: mail_getreceiveddailystatistic ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getreceiveddailystatistic(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getreceiveddailystatistic(
    year integer,
    month integer
) RETURNS TABLE(
    receiveddate text,
    normalcount text,
    spamcount text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET CurrentDate = CONVERT(DATE, Convert(VARCHAR, Year) + '-' || CONVERT(VARCHAR, Month) + '-01')
	SET MaxDate = DATEADD(MONTH, 1, CurrentDate)

	WHILE (CurrentDate < MaxDate) BEGIN

		RETURN QUERY
		SELECT CurrentDate AS ReceivedDate, COALESCE(SUM(NormalCount), 0) AS NormalCount, COALESCE(SUM(SpamCount), 0) AS SpamCount
		FROM Mail_MailReceivedStatistics
		WHERE ReceivedDate = CurrentDate

		SET CurrentDate = DATEADD(DAY, 1, CurrentDate)

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
