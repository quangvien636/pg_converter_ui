-- ─── PROCEDURE→FUNCTION: integrated_gettreeitemlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.integrated_gettreeitemlist(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_gettreeitemlist(
    IN parentid integer,
    IN treeid integer,
    IN useyn character varying
) RETURNS SETOF record
AS $function$
DECLARE
    tempid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	TempId := 0;
	IF(UseYn='Y') BEGIN
		RETURN QUERY
		select /* TOP 1 */ TempId= ID from Integrated_TreeItem where UseYn=integrated_gettreeitemlist.useyn and ParentID=integrated_gettreeitemlist.parentid
		RETURN QUERY
		SELECT *	
		FROM 	Integrated_TreeItem
		WHERE	PARENTID = TempId	
		and TreeID	=	integrated_gettreeitemlist.treeid
		ORDER BY SortOrd asc, RegDate desc	
		END;
	ELSE
	RETURN QUERY
	SELECT *	
		FROM Integrated_TreeItem
		WHERE	PARENTID = integrated_gettreeitemlist.parentid	
		and TreeID	=	integrated_gettreeitemlist.treeid
		ORDER BY SortOrd asc, RegDate desc
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
