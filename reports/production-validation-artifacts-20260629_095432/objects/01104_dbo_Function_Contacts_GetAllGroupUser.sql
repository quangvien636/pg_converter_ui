-- ─── FUNCTION: contacts_getallgroupuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getallgroupuser(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallgroupuser(
    reguserno integer
) RETURNS TABLE(
    seq serial,
    groupno integer,
    userseq integer,
    reguserno integer,
    regdate timestamp without time zone,
    moddate timestamp without time zone
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsGroupUser WHERE RegUserNo=contacts_getallgroupuser.reguserno
	ORDER BY Seq ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
