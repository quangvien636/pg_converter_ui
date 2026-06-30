-- ─── PROCEDURE→FUNCTION: integrated_updatetreeitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_updatetreeitem(integer, integer, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_updatetreeitem(
    IN id integer,
    IN parentid integer,
    IN name character varying,
    IN treeid integer,
    IN regid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	update  Integrated_TreeItem
	Name := integrated_updatetreeitem.name,;
	RegID=integrated_updatetreeitem.regid,
	ModDate=NOW()
	where ID=integrated_updatetreeitem.id



	RETURN QUERY
	SELECT *	
	FROM 	Integrated_TreeItem
	WHERE	PARENTID = integrated_updatetreeitem.parentid
	AND		TreeID = integrated_updatetreeitem.treeid
	ORDER BY SortOrd asc, RegDate desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
