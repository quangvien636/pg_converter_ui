-- ─── PROCEDURE→FUNCTION: contacts_setnumber ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_setnumber(integer, integer, smallint, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setnumber(
    IN reguserno integer,
    IN userseq integer,
    IN type smallint,
    IN typename character varying,
    IN value character varying
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	

	IF Value IS NOT NULL THEN
		IF LEN(Value) > 0 THEN;
			INSERT INTO ContactsNumber(RegUserNo,UserSeq,Type,TypeName,Value,IsDefault)
			VALUES(RegUserNo,UserSeq,Type,TypeName,Value,IsDefault)
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
