-- ─── FUNCTION: contacts_getaddressinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getaddressinfo();
CREATE OR REPLACE FUNCTION public.contacts_getaddressinfo(
) RETURNS TABLE(
    no serial,
    sharegroupno integer,
    userseq integer,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    isdelete boolean
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
	SELECT * FROM ContactsGroupUser WHERE UserSeq = Seq
	RETURN QUERY
	SELECT * FROM Contact_PublicGroupUser WHERE UserSeq = Seq AND IsDelete= FALSE
	RETURN QUERY
	SELECT * FROM Contact_ShareGroupUser WHERE UserSeq = Seq AND IsDelete= FALSE;
	UPDATE ContactsUser 
	SET
		ViewCount = ViewCount+1
	WHERE Seq = Seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
