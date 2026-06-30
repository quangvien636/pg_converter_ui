-- ─── FUNCTION: contacts_getalluser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getalluser(integer);
CREATE OR REPLACE FUNCTION public.contacts_getalluser(
    reguserno integer
) RETURNS TABLE(
    seq serial,
    firstname character varying(100),
    lastname character varying(100),
    reguserno integer,
    memo character varying(500),
    regdate timestamp without time zone,
    photo character varying(500),
    moddate timestamp without time zone,
    checkdate timestamp without time zone,
    share character varying(50),
    useyn character varying(1),
    deldate timestamp without time zone,
    important integer,
    callname character varying(20),
    viewcount integer,
    grouplist character varying(250)
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsUser WHERE RegUserNo=contacts_getalluser.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
