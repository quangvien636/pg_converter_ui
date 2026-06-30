-- ─── FUNCTION: note_getsingleshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getsingleshare(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_getsingleshare(
    shareno uuid,
    userno integer
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
	WHERE ShareNo=note_getsingleshare.shareno AND UserNo=note_getsingleshare.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
