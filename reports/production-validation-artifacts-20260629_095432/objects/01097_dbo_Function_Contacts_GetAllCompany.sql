-- ─── FUNCTION: contacts_getallcompany ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getallcompany(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallcompany(
    reguserno integer
) RETURNS TABLE(
    seq serial,
    reguserno integer,
    userseq integer,
    company character varying(50),
    depart character varying(50),
    position character varying(50),
    isdefault character(1),
    regdate timestamp without time zone,
    moddate timestamp without time zone
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_getallcompany.reguserno
	ORDER BY Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
