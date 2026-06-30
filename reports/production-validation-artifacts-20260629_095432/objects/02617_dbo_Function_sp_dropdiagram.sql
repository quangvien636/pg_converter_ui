-- ─── FUNCTION: sp_dropdiagram ───────────────────────────────
DROP FUNCTION IF EXISTS public.sp_dropdiagram(sysname);
CREATE OR REPLACE FUNCTION public.sp_dropdiagram(
    diagramname sysname
) RETURNS TABLE(
    col1 text,
    col2 text
)
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
AS $function$
DECLARE
    theid integer;
    isdbo integer;
    uidfound integer;
    diagid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		if(diagramname is null)
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
		
		select DiagId = diagram_id, UIDFound = principal_id from public."sysdiagrams" where principal_id = owner_id and name = sp_dropdiagram.diagramname 
		if(DiagId IS NULL or (IsDbo = FALSE and UIDFound <> theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from public."sysdiagrams" where diagram_id = DiagId;
	
		return 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
