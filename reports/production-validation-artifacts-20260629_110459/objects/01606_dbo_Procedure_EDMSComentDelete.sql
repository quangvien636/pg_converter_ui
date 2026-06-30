-- ─── PROCEDURE→FUNCTION: edmscomentdelete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmscomentdelete();
CREATE OR REPLACE FUNCTION public.edmscomentdelete(
) RETURNS void
AS $function$
DECLARE
    id integer;
BEGIN
/*	
sp_columns edmscoment

Id := (--*/);;
	update	EDMSComent
	isDelete := 'Y';
	where	id		= id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
