-- ─── FUNCTION: sp_renamediagram ───────────────────────────────
DROP FUNCTION IF EXISTS public.sp_renamediagram(sysname, integer);
CREATE OR REPLACE FUNCTION public.sp_renamediagram(
    diagramname sysname,
    owner_id integer DEFAULT NULL
) RETURNS TABLE(
    col1 text
)
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
AS $function$
DECLARE
    theid integer;
    isdbo integer;
    uidfound integer;
    diagid integer;
    diagidtarg integer;
    u_name sysname;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		if((diagramname is null) or (new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select theId = DATABASE_PRINCIPAL_ID();
		select IsDbo = IS_MEMBER('db_owner'); 
		if(owner_id is null)
			select owner_id = theId;
		REVERT;
	
		select u_name = USER_NAME(owner_id)
	
		select DiagId = diagram_id, UIDFound = principal_id from public."sysdiagrams" where principal_id = sp_renamediagram.owner_id and name = sp_renamediagram.diagramname 
		if(DiagId IS NULL or (IsDbo = FALSE and UIDFound <> theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((u_name is not null) and (new_diagramname = diagramname))	-- nothing will change
		--	return 0;
	
		if(u_name is null)
			select DiagIdTarg = diagram_id from public."sysdiagrams" where principal_id = theId and name = new_diagramname
		else
			select DiagIdTarg = diagram_id from public."sysdiagrams" where principal_id = sp_renamediagram.owner_id and name = new_diagramname
	
		if((DiagIdTarg is not null) and  DiagId <> DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(u_name is null);
			update public."sysdiagrams" set name = new_diagramname, principal_id = theId where diagram_id = DiagId
		else;
			update public."sysdiagrams" set name = new_diagramname where diagram_id = DiagId
		return 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
