-- ─── FUNCTION: note_getsinglenotesmaps ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getsinglenotesmaps(uuid);
CREATE OR REPLACE FUNCTION public.note_getsinglenotesmaps(
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

	RETURN QUERY
	SELECT * FROM Note_Share
	WHERE ListNo=note_getsinglenotesmaps.listno
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
