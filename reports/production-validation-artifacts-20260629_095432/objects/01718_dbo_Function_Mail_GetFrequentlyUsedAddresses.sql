-- ─── FUNCTION: mail_getfrequentlyusedaddresses ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getfrequentlyusedaddresses(bigint);
CREATE OR REPLACE FUNCTION public.mail_getfrequentlyusedaddresses(
    userno bigint
) RETURNS TABLE(
    addressno text,
    name text,
    address text,
    usedcount text
)
AS $function$
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
