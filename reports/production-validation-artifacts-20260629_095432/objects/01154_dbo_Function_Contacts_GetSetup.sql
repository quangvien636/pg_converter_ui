-- ─── FUNCTION: contacts_getsetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getsetup();
CREATE OR REPLACE FUNCTION public.contacts_getsetup(
) RETURNS TABLE(
    userno integer,
    regdate timestamp without time zone,
    reguserno integer,
    moddate timestamp without time zone,
    moduserno integer,
    pagesize integer,
    startcontactboxno bigint,
    isfolderexpanded boolean
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsSetup
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
