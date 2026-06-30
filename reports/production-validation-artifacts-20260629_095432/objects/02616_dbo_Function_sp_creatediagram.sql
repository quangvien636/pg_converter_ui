-- ─── FUNCTION: sp_creatediagram ───────────────────────────────
DROP FUNCTION IF EXISTS public.sp_creatediagram(sysname, integer, integer);
CREATE OR REPLACE FUNCTION public.sp_creatediagram(
    diagramname sysname,
    version integer,
    owner_id integer DEFAULT NULL
) RETURNS TABLE(
    col1 text,
    col2 text
)
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
AS $function$
DECLARE
    theid integer;
    retval integer;
    isdbo integer;
    username sysname;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		if(version is null or diagramname is null)
		begin
			RAISERROR ('E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select theId = DATABASE_PRINCIPAL_ID(); 
		select IsDbo = IS_MEMBER('db_owner');
		revert; 
		
		if owner_id is null
		begin
			select owner_id = theId;
		end
		else
		begin
			if theId <> sp_creatediagram.owner_id
			begin
				if IsDbo = FALSE
				begin
					RAISERROR ('E_INVALIDARG', 16, 1);
					return -1
				end
				select theId = sp_creatediagram.owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from public."sysdiagrams" where principal_id = theId and name = sp_creatediagram.diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into public."sysdiagrams"(name, principal_id , version, definition)
				VALUES(diagramname, theId, version, definition) ;
		
		select retval = @IDENTITY 
		return retval;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
