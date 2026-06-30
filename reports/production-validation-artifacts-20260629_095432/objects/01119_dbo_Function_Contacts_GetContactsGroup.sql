-- ─── FUNCTION: contacts_getcontactsgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getcontactsgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getcontactsgroup(
    reguserno integer,
    pgroupno integer
) RETURNS TABLE(
    groupno serial,
    groupname text,
    reguserno integer,
    regdate timestamp without time zone,
    memo character varying(500),
    parentgno integer,
    sort integer,
    isdefault character(1),
    useyn character(1)
)
AS $function$
BEGIN

	IF PGroupNo = -1
	BEGIN
		RETURN QUERY
		SELECT * FROM ContactsGroup WHERE RegUserNo=contacts_getcontactsgroup.reguserno ORDER BY ParentGNo,Sort
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT * FROM ContactsGroup WHERE RegUserNo=contacts_getcontactsgroup.reguserno AND ParentGNo=contacts_getcontactsgroup.pgroupno ORDER BY Sort
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
