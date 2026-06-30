-- ─── FUNCTION: contacts_setsns ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setsns(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setsns(
    reguserno integer,
    userseq integer,
    value character varying
) RETURNS void
AS $function$
BEGIN
	
	INSERT INTO ContactsSns(RegUserNo,UserSeq,Value,IsDefault)
	VALUES(RegUserNo,UserSeq,Value,IsDefault);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
