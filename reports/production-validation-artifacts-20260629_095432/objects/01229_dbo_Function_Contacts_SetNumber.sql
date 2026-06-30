-- ─── FUNCTION: contacts_setnumber ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setnumber(integer, integer, smallint, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setnumber(
    reguserno integer,
    userseq integer,
    type smallint,
    typename character varying,
    value character varying
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	

	IF Value IS NOT NULL
	BEGIN
		IF LEN(Value) > 0
		BEGIN;
			INSERT INTO ContactsNumber(RegUserNo,UserSeq,Type,TypeName,Value,IsDefault)
			VALUES(RegUserNo,UserSeq,Type,TypeName,Value,IsDefault)
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
