-- ─── FUNCTION: note_lgetgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lgetgroup(uuid);
CREATE OR REPLACE FUNCTION public.note_lgetgroup(
    groupno uuid
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
	WHERE GroupNo = note_lgetgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
