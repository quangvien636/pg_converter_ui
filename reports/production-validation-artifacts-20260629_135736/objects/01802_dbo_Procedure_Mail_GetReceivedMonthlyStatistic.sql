-- ─── PROCEDURE→FUNCTION: mail_getreceivedmonthlystatistic ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.mail_getreceivedmonthlystatistic(integer);
CREATE OR REPLACE FUNCTION public.mail_getreceivedmonthlystatistic(
    IN year integer
) RETURNS SETOF record
AS $function$
DECLARE
    currentmonth integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	CurrentMonth := 1;


	WHILE CurrentMonth < 13 LOOP

		StartDate := CONVERT(DATE, CONVERT(VARCHAR, Year) + '-' || CONVERT(VARCHAR, CurrentMonth) + '-01');
		EndDate := DATEADD(DAY, -1, DATEADD(MONTH, 1, StartDate));
		RETURN QUERY
		SELECT CurrentMonth AS Month, COALESCE(SUM(NormalCount), 0) AS NormalCount, COALESCE(SUM(SpamCount), 0) AS SpamCount
		FROM Mail_MailReceivedStatistics
		WHERE ReceivedDate BETWEEN StartDate AND EndDate 

		CurrentMonth := CurrentMonth + 1;
	END LOOP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
