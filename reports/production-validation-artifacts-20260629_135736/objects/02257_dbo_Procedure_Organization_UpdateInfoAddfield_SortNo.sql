-- ─── PROCEDURE→FUNCTION: organization_updateinfoaddfield_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateinfoaddfield_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updateinfoaddfield_sortno(
    IN no integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN sortno integer
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
