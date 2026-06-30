-- ─── FUNCTION: sp_alterdiagram ───────────────────────────────
DROP FUNCTION IF EXISTS public.sp_alterdiagram(sysname, integer, integer);
CREATE OR REPLACE FUNCTION public.sp_alterdiagram(
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
    uidfound integer;
    diagid integer;
    shouldchangeuid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		if(diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select theId = DATABASE_PRINCIPAL_ID();	 
		select IsDbo = IS_MEMBER('db_owner'); 
		if(owner_id is null)
			select owner_id = theId;
		revert;
	
		select ShouldChangeUID = 0
		select DiagId = diagram_id, UIDFound = principal_id from public."sysdiagrams" where principal_id = sp_alterdiagram.owner_id and name = sp_alterdiagram.diagramname 
		
		if(DiagId IS NULL or (IsDbo = FALSE and theId <> UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(IsDbo <> 0)
		begin
			if(UIDFound is null or USER_NAME(UIDFound) is null) -- invalid principal_id
			begin
				select ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			;
		update public."sysdiagrams" set definition = definition where diagram_id = DiagId ;

		-- change owner
		if(ShouldChangeUID = 1);
			update public."sysdiagrams" set principal_id = theId where diagram_id = DiagId ;

		-- update dds version
		if(version is not null);
			update public."sysdiagrams" set version = sp_alterdiagram.version where diagram_id = DiagId ;

		return 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
