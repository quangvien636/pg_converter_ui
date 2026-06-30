-- ─── FUNCTION: note_getgroupofuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getgroupofuser(integer);
CREATE OR REPLACE FUNCTION public.note_getgroupofuser(
    userno integer
) RETURNS TABLE(
    groupno uuid,
    name character varying(250),
    orderpostion integer,
    daycreate timestamp without time zone,
    dayedit timestamp without time zone,
    userno integer,
    show integer,
    icon character varying(250),
    checkdelete integer
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM Note_Group
	WHERE UserNo=note_getgroupofuser.userno AND Show=1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
