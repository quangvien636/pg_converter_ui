-- ─── FUNCTION: note_getlistshares ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getlistshares(uuid);
CREATE OR REPLACE FUNCTION public.note_getlistshares(
    listno uuid
) RETURNS TABLE(
    shareno uuid,
    userno integer,
    listno uuid,
    daycreate timestamp without time zone,
    dayedit timestamp without time zone,
    usershare integer,
    groupno uuid,
    isread boolean,
    readdate timestamp without time zone,
    isreads integer,
    favoritetype integer,
    sharetype integer,
    timeoffset double precision,
    companyno integer,
    sharecompanyno integer
)
AS $function$
BEGIN

	WITH CTE AS(
		SELECT *,RN = ROW_NUMBER()OVER(PARTITION BY ListNo, UserShare, ShareType ORDER BY UserShare)
		  FROM Note_Share
		  WHERE ListNo = note_getlistshares.listno
	)
	RETURN QUERY
	Select * FROM CTE WHERE RN = 1

END

RETURN QUERY
select * from Note_Share where ListNo = '00000000-0000-0000-0000-000000000000';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
