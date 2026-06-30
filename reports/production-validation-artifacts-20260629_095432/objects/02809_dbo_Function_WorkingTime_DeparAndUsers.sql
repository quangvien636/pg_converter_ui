-- ─── FUNCTION: workingtime_deparandusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_deparandusers(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_deparandusers(
    p_uids character varying DEFAULT '',
    p_dids character varying DEFAULT '',
    p_lang character varying DEFAULT 'KO'
) RETURNS TABLE(
    iid text,
    id text,
    name text,
    ltype text
)
AS $function$
BEGIN

		RETURN QUERY
		SELECT 
				u.UserNo as iid
				, CAST(u.UserNo as varchar) as id
				,u.Name 
				,'user' as ltype
		FROM   Organization_Users u
		where ',' || p_uids || ',' ILIKE '%,' || CONVERT(VARCHAR(50),u.UserNo)+',%'
		union all
		RETURN QUERY
		SELECT 
				d.DepartNo as iid
				, CAST(d.DepartNo as varchar) as id
				,d.Name 
				,'depart' as ltype
		FROM   Organization_Departments d
		where ',' || p_dids || ',' ILIKE '%,' || CONVERT(VARCHAR(50),d.DepartNo)+',%';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
