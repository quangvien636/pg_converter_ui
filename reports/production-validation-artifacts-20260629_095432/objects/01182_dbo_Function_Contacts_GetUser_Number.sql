-- ─── FUNCTION: contacts_getuser_number ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_number(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_number(
    userseq integer
) RETURNS TABLE(
    seq text,
    reguserno text,
    userseq text,
    type text,
    typename text,
    value text,
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
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsNumber WHERE UserSeq = contacts_getuser_number.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
