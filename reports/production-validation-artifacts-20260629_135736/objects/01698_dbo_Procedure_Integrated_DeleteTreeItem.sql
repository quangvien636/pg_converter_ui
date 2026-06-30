-- ─── PROCEDURE→FUNCTION: integrated_deletetreeitem ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.integrated_deletetreeitem(integer);
CREATE OR REPLACE FUNCTION public.integrated_deletetreeitem(
    IN id integer
) RETURNS void
AS $function$
BEGIN
	
	Delete from Integrated_TreeItem WHERE	ID = integrated_deletetreeitem.id	
	END;


----------------------------///////////-----------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
