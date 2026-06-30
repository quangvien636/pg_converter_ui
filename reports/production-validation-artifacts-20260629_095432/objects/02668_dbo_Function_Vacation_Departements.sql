-- ─── FUNCTION: vacation_departements ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_departements(character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_departements(
    p_id character varying DEFAULT '',
    p_lang character varying DEFAULT 'KO'
) RETURNS TABLE(
    departno text,
    id text,
    text text
)
AS $function$
BEGIN



				RETURN QUERY
				SELECT 
					  d.DepartNo
					  , CAST(d.DepartNo as nvarchar) as id
					  ,d.Name as text
				FROM   Organization_Departments d
				where ',' || p_id || ',' ILIKE '%,' || CONVERT(VARCHAR(50),d.DepartNo)+',%';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
