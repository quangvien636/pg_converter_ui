-- ─── PROCEDURE→FUNCTION: integrated_setuseyntreeitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.integrated_setuseyntreeitem(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_setuseyntreeitem(
    IN id integer,
    IN parentid integer,
    IN regid character varying
) RETURNS void
AS $function$
BEGIN


	update Integrated_TreeItem 
	UseYn := '',;
	RegID=integrated_setuseyntreeitem.regid
	where ParentID=integrated_setuseyntreeitem.parentid 


	update  Integrated_TreeItem
	UseYn := 'Y',;
	RegID=integrated_setuseyntreeitem.regid,
	ModDate=NOW()
	where ID=integrated_setuseyntreeitem.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
