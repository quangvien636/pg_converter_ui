-- ─── PROCEDURE→FUNCTION: sp_helpdiagramdefinition ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sp_helpdiagramdefinition(character varying(128));
CREATE OR REPLACE FUNCTION public.sp_helpdiagramdefinition(
    IN diagramname character varying(128)
) RETURNS SETOF record
AS $function$
DECLARE
    theid integer;
    isdbo integer;
    diagid integer;
    uidfound integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		if(diagramname is null)
		begin
			RAISE EXCEPTION 'E_INVALIDARG';
			return -1
		END;
	
		PERFORM as(caller);
		theId := (DATABASE_PRINCIPAL_ID());
		IsDbo := (IS_MEMBER('db_owner'));
		if(owner_id is null)
			owner_id := (theId);
		revert; 
	
		SELECT diagram_id, principal_id INTO diagid, uidfound from public."sysdiagrams" where principal_id = owner_id and name = sp_helpdiagramdefinition.diagramname;
		if(DiagId IS NULL or (IsDbo = FALSE and UIDFound <> theId ))
		begin
			RAISE EXCEPTION 'Diagram does not exist or you do not have permission.';
			return -3
		END;

		RETURN QUERY
		select version, definition FROM public."sysdiagrams" where diagram_id = DiagId ; 
		return 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
