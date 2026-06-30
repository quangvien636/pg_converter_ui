-- ─── PROCEDURE→FUNCTION: sp_renamediagram ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sp_renamediagram(character varying(128), integer);
CREATE OR REPLACE FUNCTION public.sp_renamediagram(
    IN diagramname character varying(128),
    IN owner_id integer DEFAULT NULL
) RETURNS SETOF record
AS $function$
DECLARE
    theid integer;
    isdbo integer;
    uidfound integer;
    diagid integer;
    diagidtarg integer;
    u_name character varying(128);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		if((diagramname is null) or (new_diagramname is null))
		begin
			RAISE EXCEPTION 'Invalid value';
			return -1
		END;
	
		PERFORM as(CALLER);
		theId := (DATABASE_PRINCIPAL_ID());
		IsDbo := (IS_MEMBER('db_owner'));
		if(owner_id is null)
			owner_id := (theId);
		REVERT;
	
		u_name := (USER_NAME(owner_id));
		SELECT diagram_id, principal_id INTO diagid, uidfound from public."sysdiagrams" where principal_id = sp_renamediagram.owner_id and name = sp_renamediagram.diagramname 
		if(DiagId IS NULL or (IsDbo = FALSE and UIDFound <> theId))
		begin
			RAISE EXCEPTION 'Diagram does not exist or you do not have permission.'
			return -3
		END;
	
		-- if((u_name is not null) and (new_diagramname = diagramname))	-- nothing will change
		--	return 0;
	
		if(u_name is null)
			SELECT diagram_id INTO diagidtarg from public."sysdiagrams" where principal_id = theId and name = new_diagramname
		ELSE
			SELECT diagram_id INTO diagidtarg from public."sysdiagrams" where principal_id = sp_renamediagram.owner_id and name = new_diagramname
	
		if((DiagIdTarg is not null) and  DiagId <> DiagIdTarg)
			RAISE EXCEPTION 'The name is already used.';
			return -2
		END IF;
	
		if(u_name is null);
			update public."sysdiagrams" set name = new_diagramname, principal_id = theId where diagram_id = DiagId
		ELSE;
			update public."sysdiagrams" set name = new_diagramname where diagram_id = DiagId
		return 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
