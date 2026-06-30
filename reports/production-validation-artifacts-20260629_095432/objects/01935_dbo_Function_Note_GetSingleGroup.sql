-- ─── FUNCTION: note_getsinglegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getsinglegroup(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_getsinglegroup(
    groupno uuid,
    userno integer
) RETURNS TABLE(
    listno uuid,
    name character varying(250),
    groupno uuid,
    userno integer,
    description text,
    latitude double precision,
    longitude double precision,
    daycreate timestamp without time zone,
    dayedit timestamp without time zone,
    show integer,
    notetimezonecreate double precision,
    notetimezoneedit double precision,
    favoritetype integer,
    readdate timestamp without time zone,
    notetimezoneread double precision
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM Note_Group
	WHERE GroupNo=note_getsinglegroup.groupno AND UserNo=note_getsinglegroup.userno AND Show=1

	RETURN QUERY
	SELECT * FROM Note_List
	WHERE GroupNo=note_getsinglegroup.groupno AND UserNo=note_getsinglegroup.userno AND Show=1	
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
