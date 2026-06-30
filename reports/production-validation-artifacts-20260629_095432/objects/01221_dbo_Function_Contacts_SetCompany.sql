-- ─── FUNCTION: contacts_setcompany ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setcompany(integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setcompany(
    reguserno integer,
    userseq integer,
    company character varying,
    depart character varying,
    position character varying
) RETURNS void
AS $function$
BEGIN
	
	IF Company IS NOT NULL OR Depart IS NOT NULL OR Position IS NOT NULL
	BEGIN ;
		INSERT INTO ContactsCompany(RegUserNo,UserSeq,Company,Depart,Position,IsDefault)
		VALUES(RegUserNo,UserSeq,Company,Depart,Position,IsDefault)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
