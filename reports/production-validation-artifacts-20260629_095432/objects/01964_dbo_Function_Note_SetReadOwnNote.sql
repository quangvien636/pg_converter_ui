-- ─── FUNCTION: note_setreadownnote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_setreadownnote(uuid, integer, double precision);
CREATE OR REPLACE FUNCTION public.note_setreadownnote(
    listno uuid,
    userno integer,
    notetimezoneread double precision DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_List
	SET ReadDate=GETUTCDATE(), NoteTimeZoneRead = note_setreadownnote.notetimezoneread
	WHERE ListNo=note_setreadownnote.listno AND UserNo = note_setreadownnote.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
