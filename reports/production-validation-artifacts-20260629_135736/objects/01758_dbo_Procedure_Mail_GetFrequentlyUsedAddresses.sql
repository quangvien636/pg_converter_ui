-- ─── PROCEDURE→FUNCTION: mail_getfrequentlyusedaddresses ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getfrequentlyusedaddresses(bigint);
CREATE OR REPLACE FUNCTION public.mail_getfrequentlyusedaddresses(
    IN userno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT AddressNo, Name, Address, UsedCount
	FROM Mail_FrequentlyUsedAddresses
	WHERE UserNo = mail_getfrequentlyusedaddresses.userno
	ORDER BY UsedCount DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
