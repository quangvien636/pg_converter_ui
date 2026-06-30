-- ─── PROCEDURE→FUNCTION: contacts_setdays ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_setdays(integer, integer, smallint, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setdays(
    IN reguserno integer,
    IN userseq integer,
    IN type smallint,
    IN typename character varying,
    IN value character varying,
    IN isdefault character varying
) RETURNS void
AS $function$
BEGIN
	
	INSERT INTO ContactsDays(RegUserNo,UserSeq,Type,TypeName,Value,IsDefault,SolarLunar)
	VALUES(RegUserNo,UserSeq,Type,TypeName,Value,IsDefault,SolarLunar);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
