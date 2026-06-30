-- ─── FUNCTION: contacts_getalldays ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getalldays(integer);
CREATE OR REPLACE FUNCTION public.contacts_getalldays(
    reguserno integer
) RETURNS TABLE(
    seq serial,
    reguserno integer,
    userseq integer,
    type smallint,
    typename character varying(50),
    value character varying(50),
    isdefault character(1),
    solarlunar character(1),
    regdate timestamp without time zone,
    moddate timestamp without time zone
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsDays WHERE RegUserNo=contacts_getalldays.reguserno
	ORDER BY Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
