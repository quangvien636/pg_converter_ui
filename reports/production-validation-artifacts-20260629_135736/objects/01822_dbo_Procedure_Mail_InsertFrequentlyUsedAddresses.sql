-- ─── PROCEDURE→FUNCTION: mail_insertfrequentlyusedaddresses ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertfrequentlyusedaddresses(bigint, character varying);
CREATE OR REPLACE FUNCTION public.mail_insertfrequentlyusedaddresses(
    IN userno bigint,
    IN name character varying
) RETURNS SETOF record
AS $function$
DECLARE
    addressno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT AddressNo INTO addressno FROM Mail_FrequentlyUsedAddresses
	WHERE UserNo = mail_insertfrequentlyusedaddresses.userno AND Name = mail_insertfrequentlyusedaddresses.name AND Address = Address

	IF AddressNo IS NULL THEN
	
		INSERT INTO Mail_FrequentlyUsedAddresses
		VALUES (UserNo, Name, Address, 1)
	
		AddressNo := lastval();
	END IF;
	
	ELSE BEGIN
	
		UPDATE Mail_FrequentlyUsedAddresses SET UsedCount = UsedCount + 1
		WHERE AddressNo = AddressNo
	
	END;
	
	RETURN QUERY
	SELECT AddressNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
