-- ─── FUNCTION: contacts_getsharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getsharers(integer);
CREATE OR REPLACE FUNCTION public.contacts_getsharers(
    seq integer DEFAULT 7914
) RETURNS TABLE(
    seq integer,
    departno integer,
    departname character varying(100),
    ischild character(1)
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsSharers WHERE Seq = contacts_getsharers.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
