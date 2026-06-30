-- ─── PROCEDURE→FUNCTION: contacts_setsns ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_setsns(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setsns(
    IN reguserno integer,
    IN userseq integer,
    IN value character varying
) RETURNS void
AS $function$
BEGIN
	
	INSERT INTO ContactsSns(RegUserNo,UserSeq,Value,IsDefault)
	VALUES(RegUserNo,UserSeq,Value,IsDefault);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
