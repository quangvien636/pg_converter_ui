-- ─── PROCEDURE→FUNCTION: contacts_setemail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_setemail(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setemail(
    IN reguserno integer,
    IN userseq integer,
    IN value character varying
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	IF Value IS NOT NULL THEN
		IF LEN(Value) > 0 THEN;
			INSERT INTO ContactsEmail(RegUserNo,UserSeq,Value,IsDefault)
			VALUES(RegUserNo,UserSeq,Value,IsDefault)
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
