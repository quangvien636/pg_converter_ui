-- ─── FUNCTION: contacts_gettrashcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_gettrashcount(integer);
CREATE OR REPLACE FUNCTION public.contacts_gettrashcount(
    reguserno integer
) RETURNS TABLE(
    cnt text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT COUNT(*) AS CNT FROM ContactsUser
	WHERE UseYn = '' AND RegUserNo = contacts_gettrashcount.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
