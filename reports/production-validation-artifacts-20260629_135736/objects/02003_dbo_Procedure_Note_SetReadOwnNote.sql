-- ─── PROCEDURE→FUNCTION: note_setreadownnote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_setreadownnote(uuid, integer, double precision);
CREATE OR REPLACE FUNCTION public.note_setreadownnote(
    IN listno uuid,
    IN userno integer,
    IN notetimezoneread double precision DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_List
	ReadDate := GETUTCDATE(), NoteTimeZoneRead = note_setreadownnote.notetimezoneread;
	WHERE ListNo=note_setreadownnote.listno AND UserNo = note_setreadownnote.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
