-- ─── FUNCTION: contacts_checknumber ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_checknumber(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_checknumber(
    reguserno integer,
    value character varying,
    type integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
IF Type = 0
	RETURN QUERY
	SELECT COUNT(*) cnt FROM ContactsNumber N
	INNER JOIN ContactsUser U ON U.Seq = N.UserSeq AND U.UseYn='Y'
	WHERE N.RegUserNo = contacts_checknumber.reguserno 
	AND REPLACE(N.Value,'-','') = REPLACE(Value,'-','')
ELSE
	RETURN QUERY
	SELECT COUNT(*) cnt FROM ContactsEmail E 
	INNER JOIN ContactsUser U ON U.Seq = E.UserSeq AND U.UseYn='Y'
	WHERE E.RegUserNo = contacts_checknumber.reguserno AND E.Value = contacts_checknumber.value;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
