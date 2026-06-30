-- ─── FUNCTION: note_lupdatedatereadofnote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lupdatedatereadofnote(uuid, integer, timestamp without time zone, double precision);
CREATE OR REPLACE FUNCTION public.note_lupdatedatereadofnote(
    noteno uuid,
    userno integer,
    dateread timestamp without time zone,
    timezoneoffsetofdateread double precision
) RETURNS void
AS $function$
BEGIN


	IF ((SELECT UserNo FROM Note_LNotes WHERE NoteNo = note_lupdatedatereadofnote.noteno) = note_lupdatedatereadofnote.userno) BEGIN
	
		UPDATE Note_List SET ReadDate = note_lupdatedatereadofnote.dateread, NoteTimeZoneRead = note_lupdatedatereadofnote.timezoneoffsetofdateread
		WHERE ListNo = note_lupdatedatereadofnote.noteno

	END

	ELSE IF ((SELECT COUNT(*) FROM Note_LSharers WHERE NoteNo = note_lupdatedatereadofnote.noteno AND UserShare = note_lupdatedatereadofnote.userno) != 0) BEGIN

		UPDATE Note_Share SET IsRead = TRUE, ReadDate = note_lupdatedatereadofnote.dateread, timeOffset = note_lupdatedatereadofnote.timezoneoffsetofdateread
		WHERE ListNo = note_lupdatedatereadofnote.noteno AND UserShare = note_lupdatedatereadofnote.userno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
