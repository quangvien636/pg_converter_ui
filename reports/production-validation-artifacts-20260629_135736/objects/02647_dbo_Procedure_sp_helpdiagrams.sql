-- ─── PROCEDURE→FUNCTION: sp_helpdiagrams ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sp_helpdiagrams(character varying(128));
CREATE OR REPLACE FUNCTION public.sp_helpdiagrams(
    IN diagramname character varying(128) DEFAULT NULL
) RETURNS SETOF record
AS $function$
DECLARE
    user character varying(128);
    dbologin boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		PERFORM as(CALLER);
			user := USER_NAME();
			dboLogin := CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		RETURN QUERY
		SELECT
			Database = DB_NAME(),
			Name = name,
			ID = diagram_id,
			Owner = USER_NAME(principal_id),
			OwnerID = principal_id
		FROM
			sysdiagrams
		WHERE
			(dboLogin = 1 OR USER_NAME(principal_id) = user) AND
			(diagramname IS NULL OR name = sp_helpdiagrams.diagramname) AND
			(owner_id IS NULL OR principal_id = owner_id)
		ORDER BY
			4, 5, 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
