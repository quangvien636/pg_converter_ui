-- ─── PROCEDURE→FUNCTION: sp_alterdiagram ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sp_alterdiagram(character varying(128), integer, integer);
CREATE OR REPLACE FUNCTION public.sp_alterdiagram(
    IN diagramname character varying(128),
    IN version integer,
    IN owner_id integer DEFAULT NULL
) RETURNS SETOF record
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
			RAISE EXCEPTION 'Invalid ARG'
			return -1
		END;
	
		PERFORM as(caller);
		theId := (DATABASE_PRINCIPAL_ID());
		IsDbo := (IS_MEMBER('db_owner'));
		if(owner_id is null)
			owner_id := (theId);
		revert;
	
		ShouldChangeUID := (0);
		SELECT diagram_id, principal_id INTO diagid, uidfound from public."sysdiagrams" where principal_id = sp_alterdiagram.owner_id and name = sp_alterdiagram.diagramname 
		
		if(DiagId IS NULL or (IsDbo = FALSE and theId <> UIDFound))
		begin
			RAISE EXCEPTION 'Diagram does not exist or you do not have permission.';
			return -3
		END;
	
		if(IsDbo <> 0)
		begin
			if(UIDFound is null or USER_NAME(UIDFound) is null) -- invalid principal_id
			begin
				ShouldChangeUID := (1);
			END;
		END;

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
