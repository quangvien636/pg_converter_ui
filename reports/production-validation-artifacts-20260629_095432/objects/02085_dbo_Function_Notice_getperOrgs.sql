-- ─── FUNCTION: notice_getperorgs ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getperorgs();
CREATE OR REPLACE FUNCTION public.notice_getperorgs(
) RETURNS TABLE(
    id text,
    deparno text,
    col3 text,
    name text,
    name_en text,
    name_ch text,
    name_jp text,
    name_vn text
)
AS $function$
BEGIN

	-- Get list departments include all childs

			RETURN QUERY
			SELECT 

				P.Id, 
				P.DeparNo,
				COALESCE(P.ViewEndDate,1) ViewEndDate,
				D.Name, 
				D.Name_EN, 
				D.Name_CH, 
				D.Name_JP, 
				D.Name_VN 
				

			FROM NoticePermissions P
				INNER JOIN Organization_Departments D ON P.DeparNo = D.DepartNo 
			WHERE P.DeparNo IS NOT NULL ORDER BY P.Id DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
