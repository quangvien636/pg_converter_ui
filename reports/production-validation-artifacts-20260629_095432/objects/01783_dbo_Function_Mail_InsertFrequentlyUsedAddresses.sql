-- ─── FUNCTION: mail_insertfrequentlyusedaddresses ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertfrequentlyusedaddresses(bigint, character varying);
CREATE OR REPLACE FUNCTION public.mail_insertfrequentlyusedaddresses(
    userno bigint,
    name character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    addressno bigint;
BEGIN



	SELECT AddressNo = AddressNo FROM Mail_FrequentlyUsedAddresses
	WHERE UserNo = mail_insertfrequentlyusedaddresses.userno AND Name = mail_insertfrequentlyusedaddresses.name AND Address = Address

	IF (AddressNo IS NULL) BEGIN
	
		INSERT INTO Mail_FrequentlyUsedAddresses
		VALUES (UserNo, Name, Address, 1)
	
		SET AddressNo = lastval()
	
	END
	
	ELSE BEGIN
	
		UPDATE Mail_FrequentlyUsedAddresses SET UsedCount = UsedCount + 1
		WHERE AddressNo = AddressNo
	
	END
	
	RETURN QUERY
	SELECT AddressNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
