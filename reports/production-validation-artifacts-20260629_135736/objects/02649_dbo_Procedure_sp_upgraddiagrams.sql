-- ─── PROCEDURE→FUNCTION: sp_upgraddiagrams ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sp_upgraddiagrams();
CREATE OR REPLACE FUNCTION public.sp_upgraddiagrams(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		IF OBJECT_ID('public."sysdiagrams"') IS NOT NULL THEN
			return 0;
	
		CREATE TABLE public."sysdiagrams"
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID('public."sysdiagram_properties"') IS NULL THEN
			CREATE TABLE public."sysdiagram_properties"
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END IF;
		*/

		IF OBJECT_ID('public."dtproperties"') IS NOT NULL THEN;
			insert into public."sysdiagrams"
			(
				name,
				principal_id,
				version,
				definition
			)
			RETURN QUERY
			select	 
				convert(sysname, dgnm.uvalue),
				DATABASE_PRINCIPAL_ID('dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.version,
				dgdef.lvalue
			from public."dtproperties" dgnm
				inner join public."dtproperties" dggd on dggd.property = 'DtgSchemaGUID' and dggd.objectid = dgnm.objectid	
				inner join public."dtproperties" dgdef on dgdef.property = 'DtgSchemaDATA' and dgdef.objectid = dgnm.objectid
				
			where dgnm.property = 'DtgSchemaNAME' and dggd.uvalue ILIKE '_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		END IF;
		return 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
