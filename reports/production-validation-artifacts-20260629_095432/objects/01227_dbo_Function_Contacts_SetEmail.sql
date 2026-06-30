-- ─── FUNCTION: contacts_setemail ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setemail(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setemail(
    reguserno integer,
    userseq integer,
    value character varying
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	IF Value IS NOT NULL
	BEGIN
		IF LEN(Value) > 0
		BEGIN ;
			INSERT INTO ContactsEmail(RegUserNo,UserSeq,Value,IsDefault)
			VALUES(RegUserNo,UserSeq,Value,IsDefault)
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
