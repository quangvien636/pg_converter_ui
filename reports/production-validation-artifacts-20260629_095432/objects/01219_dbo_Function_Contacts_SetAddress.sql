-- ─── FUNCTION: contacts_setaddress ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setaddress(integer, integer, smallint, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setaddress(
    reguserno integer,
    userseq integer,
    type smallint,
    typename character varying,
    zipcode1 character varying,
    zipcode2 character varying,
    address character varying
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	IF Address IS NOT NULL
	BEGIN
		IF LEN(Address) > 0
		BEGIN ;
			INSERT INTO ContactsAddress(RegUserNo,UserSeq,Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault)
			VALUES(RegUserNo,UserSeq,Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault)
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
