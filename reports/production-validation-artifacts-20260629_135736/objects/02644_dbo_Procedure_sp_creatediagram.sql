-- ─── PROCEDURE→FUNCTION: sp_creatediagram ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sp_creatediagram(character varying(128), integer, integer);
CREATE OR REPLACE FUNCTION public.sp_creatediagram(
    IN diagramname character varying(128),
    IN version integer,
    IN owner_id integer DEFAULT NULL
) RETURNS SETOF record
AS $function$
DECLARE
    theid integer;
    retval integer;
    isdbo integer;
    username character varying(128);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		if(version is null or diagramname is null)
		begin
			RAISE EXCEPTION 'E_INVALIDARG';
			return -1
		END;
	
		PERFORM as(caller);
		theId := (DATABASE_PRINCIPAL_ID());
		IsDbo := (IS_MEMBER('db_owner'));
		revert; 
		
		IF owner_id is null THEN
			owner_id := (theId);
		END IF;
		ELSE
			IF theId <> sp_creatediagram.owner_id THEN
				IF IsDbo = FALSE THEN
					RAISE EXCEPTION 'E_INVALIDARG';
					return -1
				END IF;
				theId := (owner_id);
			END IF;
		END IF;
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from public."sysdiagrams" where principal_id = theId and name = sp_creatediagram.diagramname)
		begin
			RAISE EXCEPTION 'The name is already used.';
			return -2
		END;
	
		insert into public."sysdiagrams"(name, principal_id , version, definition)
				VALUES(diagramname, theId, version, definition) ;
		
		retval := (@IDENTITY);
		return retval;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
