-- ─── FUNCTION: organization_updateinfoaddfield_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateinfoaddfield_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updateinfoaddfield_sortno(
    no integer,
    moduserno integer,
    moddate timestamp without time zone,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Users_InfoAddfield SET
		ModUserNo = organization_updateinfoaddfield_sortno.moduserno,
		ModDate = organization_updateinfoaddfield_sortno.moddate,
		SortNo = organization_updateinfoaddfield_sortno.sortno
	WHERE No = organization_updateinfoaddfield_sortno.no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
