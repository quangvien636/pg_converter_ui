-- ─── PROCEDURE→FUNCTION: integrated_issettreeitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_issettreeitem(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_issettreeitem(
    IN id integer,
    IN parentid integer,
    IN regid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	update Integrated_TreeItem 
	IsSet := '',;
	RegID=integrated_issettreeitem.regid
	where ParentID=integrated_issettreeitem.parentid 


	update  Integrated_TreeItem
	IsSet := 'Y',;
	RegID=integrated_issettreeitem.regid,
	ModDate=NOW()
	where ID=integrated_issettreeitem.id



	RETURN QUERY
	SELECT *	
	FROM 	Integrated_TreeItem
	WHERE	ID = integrated_issettreeitem.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
