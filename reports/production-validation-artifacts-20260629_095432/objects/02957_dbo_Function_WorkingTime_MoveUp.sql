-- ─── FUNCTION: workingtime_moveup ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_moveup();
CREATE OR REPLACE FUNCTION public.workingtime_moveup(
) RETURNS TABLE(
    no serial,
    name character varying(200),
    sort double precision
)
AS $function$
BEGIN

	With cte As
	(
		SELECT Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, No ASC) AS RN
		FROM WorkingTime_BoxUses 
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE WorkingTime_BoxUses set Sort = Sort - 1.01 Where No =  p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
