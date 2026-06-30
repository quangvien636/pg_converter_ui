-- ─── FUNCTION: vacation_getusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_getusers(character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_getusers(
    p_id character varying DEFAULT '',
    p_lang character varying DEFAULT 'KO'
) RETURNS TABLE(
    userid text,
    name text
)
AS $function$
BEGIN



				RETURN QUERY
				SELECT 
					  U.UserID
					  ,u.Name
				FROM   Organization_Users u
				where ',' || p_id || ',' ILIKE '%,' || CONVERT(VARCHAR(50),u.UserNo)+',%';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
