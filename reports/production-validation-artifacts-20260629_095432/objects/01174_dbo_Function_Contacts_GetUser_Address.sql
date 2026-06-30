-- ─── FUNCTION: contacts_getuser_address ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_address(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_address(
    userseq integer
) RETURNS TABLE(
    seq text,
    reguserno text,
    userseq text,
    type text,
    typename text,
    zipcode1 text,
    zipcode2 text,
    address text,
    isdefault text,
    regdate text,
    moddate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
	Seq, 
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	ZipCode1,
	ZipCode2,
	Address,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsAddress WHERE UserSeq = contacts_getuser_address.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
