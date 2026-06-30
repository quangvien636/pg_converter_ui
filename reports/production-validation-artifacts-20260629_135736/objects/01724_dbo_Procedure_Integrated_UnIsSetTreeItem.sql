-- ─── PROCEDURE→FUNCTION: integrated_unissettreeitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.integrated_unissettreeitem(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_unissettreeitem(
    IN id integer,
    IN parentid integer,
    IN regid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	update  Integrated_TreeItem
	IsSet := '',;
	RegID=integrated_unissettreeitem.regid,
	ModDate=NOW()
	where ID=integrated_unissettreeitem.id



	RETURN QUERY
	SELECT /* TOP 1 */ *	
	FROM 	Integrated_TreeItem
	WHERE	ParentID=integrated_unissettreeitem.parentid and UseYn='Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
