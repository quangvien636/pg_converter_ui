-- ─── FUNCTION: contacts_getallhomepage ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getallhomepage(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallhomepage(
    reguserno integer
) RETURNS TABLE(
    seq serial,
    reguserno integer,
    userseq integer,
    type smallint,
    typename character varying(50),
    value character varying(500),
    isdefault character(1),
    regdate timestamp without time zone,
    moddate timestamp without time zone
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_getallhomepage.reguserno
	ORDER BY Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
