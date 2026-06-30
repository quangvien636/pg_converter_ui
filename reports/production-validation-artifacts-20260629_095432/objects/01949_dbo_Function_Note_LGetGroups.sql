-- ─── FUNCTION: note_lgetgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lgetgroups(integer);
CREATE OR REPLACE FUNCTION public.note_lgetgroups(
    userno integer
) RETURNS TABLE(
    groupno text,
    userno text,
    name text,
    datecreated text,
    datechanged text,
    isdefault text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT GroupNo, UserNo, Name, DateCreated,DateChanged, IsDefault
	FROM Note_LGroups
	WHERE UserNo = note_lgetgroups.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
