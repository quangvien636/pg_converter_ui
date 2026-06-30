-- ─── FUNCTION: sp_helpdiagrams ───────────────────────────────
DROP FUNCTION IF EXISTS public.sp_helpdiagrams(sysname);
CREATE OR REPLACE FUNCTION public.sp_helpdiagrams(
    diagramname sysname DEFAULT NULL
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    col4 text,
    col5 text
)
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
AS $function$
DECLARE
    user sysname;
    dbologin boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		EXECUTE AS CALLER;
			SET user = USER_NAME();
			SET dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
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
