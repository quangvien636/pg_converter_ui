-- ─── FUNCTION: contacts_getalladdress ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getalladdress(integer);
CREATE OR REPLACE FUNCTION public.contacts_getalladdress(
    reguserno integer
) RETURNS TABLE(
    seq serial,
    reguserno integer,
    userseq integer,
    type smallint,
    typename character varying(50),
    zipcode1 character varying(5),
    zipcode2 character varying(5),
    address character varying(500),
    isdefault character(1),
    regdate timestamp without time zone,
    moddate timestamp without time zone,
    latitude double precision,
    longitude double precision
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_getalladdress.reguserno
	ORDER BY Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
