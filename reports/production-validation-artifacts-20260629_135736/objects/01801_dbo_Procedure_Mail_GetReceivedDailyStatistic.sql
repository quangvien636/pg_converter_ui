-- ─── PROCEDURE→FUNCTION: mail_getreceiveddailystatistic ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.mail_getreceiveddailystatistic(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getreceiveddailystatistic(
    IN year integer,
    IN month integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	CurrentDate := CONVERT(DATE, Convert(VARCHAR, Year) + '-' || CONVERT(VARCHAR, Month) + '-01');
	MaxDate := DATEADD(MONTH, 1, CurrentDate);
	WHILE CurrentDate < MaxDate LOOP

		RETURN QUERY
		SELECT CurrentDate AS ReceivedDate, COALESCE(SUM(NormalCount), 0) AS NormalCount, COALESCE(SUM(SpamCount), 0) AS SpamCount
		FROM Mail_MailReceivedStatistics
		WHERE ReceivedDate = CurrentDate

		CurrentDate := DATEADD(DAY, 1, CurrentDate);
	END LOOP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
