-- ─── FUNCTION: contacts_getusernumber ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getusernumber(integer);
CREATE OR REPLACE FUNCTION public.contacts_getusernumber(
    reguserno integer
) RETURNS TABLE(
    seq serial,
    reguserno integer,
    userseq integer,
    type smallint,
    typename character varying(50),
    value character varying(50),
    isdefault character(1),
    regdate timestamp without time zone,
    moddate timestamp without time zone,
    setcall integer
)
AS $function$
BEGIN
RETURN QUERY
SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_getusernumber.reguserno AND UserSeq=UserSeq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
