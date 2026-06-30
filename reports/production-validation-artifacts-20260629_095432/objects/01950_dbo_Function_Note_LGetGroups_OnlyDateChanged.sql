-- ─── FUNCTION: note_lgetgroups_onlydatechanged ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lgetgroups_onlydatechanged(integer);
CREATE OR REPLACE FUNCTION public.note_lgetgroups_onlydatechanged(
    userno integer
) RETURNS TABLE(
    groupno text,
    datechanged text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT GroupNo, DateChanged
	FROM Note_LGroups
	WHERE UserNo = note_lgetgroups_onlydatechanged.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
