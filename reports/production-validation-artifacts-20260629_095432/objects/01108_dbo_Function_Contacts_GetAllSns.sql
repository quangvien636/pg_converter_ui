-- ─── FUNCTION: contacts_getallsns ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getallsns(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallsns(
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
	SELECT * FROM ContactsSns WHERE RegUserNo=contacts_getallsns.reguserno
	ORDER BY Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
