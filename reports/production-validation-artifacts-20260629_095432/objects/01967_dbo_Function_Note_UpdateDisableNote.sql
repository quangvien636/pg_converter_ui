-- ─── FUNCTION: note_updatedisablenote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_updatedisablenote(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_updatedisablenote(
    groupno uuid,
    userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_List
	SET Show=2
	WHERE GroupNo=note_updatedisablenote.groupno AND UserNo=note_updatedisablenote.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
