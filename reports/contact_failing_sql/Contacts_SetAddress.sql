-- ─── PROCEDURE→FUNCTION: contacts_setaddress ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_setaddress(integer, integer, smallint, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setaddress(
    IN reguserno integer,
    IN userseq integer,
    IN type smallint,
    IN typename character varying,
    IN zipcode1 character varying,
    IN zipcode2 character varying,
    IN address character varying
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	IF Address IS NOT NULL THEN
		IF LEN(Address) > 0 THEN
			INSERT INTO ContactsAddress(RegUserNo,UserSeq,Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault)
			VALUES(RegUserNo,UserSeq,Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault);;
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.