-- ─── PROCEDURE→FUNCTION: contacts_setcompany ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_setcompany(integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setcompany(
    IN reguserno integer,
    IN userseq integer,
    IN company character varying,
    IN depart character varying,
    IN position character varying
) RETURNS void
AS $function$
BEGIN
	
	IF Company IS NOT NULL OR Depart IS NOT NULL OR Position IS NOT NULL THEN
		INSERT INTO ContactsCompany(RegUserNo,UserSeq,Company,Depart,Position,IsDefault)
		VALUES(RegUserNo,UserSeq,Company,Depart,Position,IsDefault);;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.