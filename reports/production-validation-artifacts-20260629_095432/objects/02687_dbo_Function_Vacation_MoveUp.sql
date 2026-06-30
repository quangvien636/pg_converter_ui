-- ─── FUNCTION: vacation_moveup ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_moveup(integer);
CREATE OR REPLACE FUNCTION public.vacation_moveup(
    p_typeid integer
) RETURNS TABLE(
    typeid serial,
    userno integer,
    name character varying(4000),
    typei integer,
    time integer,
    timedis double precision,
    datecreate timestamp without time zone,
    statusr integer,
    note character varying(4000),
    sort double precision,
    offtype integer,
    special integer
)
AS $function$
BEGIN


	With cte As
	(
		SELECT TypeId,Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, DateCreate ASC) AS RN
		FROM Vacation_Types 
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE Vacation_Types set Sort = Sort - 1.01 Where TypeId =  vacation_moveup.p_typeid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
