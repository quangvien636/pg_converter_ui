-- ─── FUNCTION: contacts_getuser_email ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_email(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_email(
    userseq integer
) RETURNS TABLE(
    seq text,
    reguserno text,
    userseq text,
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
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsEmail WHERE UserSeq = contacts_getuser_email.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
