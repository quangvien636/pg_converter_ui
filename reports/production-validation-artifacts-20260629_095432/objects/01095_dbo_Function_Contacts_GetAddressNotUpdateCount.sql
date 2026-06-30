-- ─── FUNCTION: contacts_getaddressnotupdatecount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getaddressnotupdatecount();
CREATE OR REPLACE FUNCTION public.contacts_getaddressnotupdatecount(
) RETURNS TABLE(
    seq serial,
    groupno integer,
    userseq integer,
    reguserno integer,
    regdate timestamp without time zone,
    moddate timestamp without time zone
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsUser WHERE Seq = Seq
	RETURN QUERY
	SELECT * FROM ContactsNumber WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsEmail WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsCompany WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsAddress WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsHomepage WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsSns WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM ContactsGroupUser WHERE UserSeq = Seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
