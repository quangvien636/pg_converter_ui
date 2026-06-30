-- ─── FUNCTION: contacts_getuser_company ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_company(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_company(
    userseq integer
) RETURNS TABLE(
    seq text,
    reguserno text,
    userseq text,
    company text,
    depart text,
    position text,
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
	Company,
	Depart,
	Position,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsCompany WHERE UserSeq = contacts_getuser_company.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
