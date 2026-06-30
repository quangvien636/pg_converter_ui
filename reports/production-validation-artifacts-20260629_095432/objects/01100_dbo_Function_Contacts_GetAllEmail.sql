-- ─── FUNCTION: contacts_getallemail ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getallemail(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallemail(
    reguserno integer
) RETURNS TABLE(
    seq serial,
    reguserno integer,
    userseq integer,
    value character varying(50),
    isdefault character(1),
    regdate timestamp without time zone,
    moddate timestamp without time zone
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_getallemail.reguserno
	ORDER BY Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
