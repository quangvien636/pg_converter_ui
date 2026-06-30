-- ─── FUNCTION: contacts_setdays ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setdays(integer, integer, smallint, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setdays(
    reguserno integer,
    userseq integer,
    type smallint,
    typename character varying,
    value character varying,
    isdefault character varying
) RETURNS void
AS $function$
BEGIN
	
	INSERT INTO ContactsDays(RegUserNo,UserSeq,Type,TypeName,Value,IsDefault,SolarLunar)
	VALUES(RegUserNo,UserSeq,Type,TypeName,Value,IsDefault,SolarLunar);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
