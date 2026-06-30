-- ─── PROCEDURE→FUNCTION: note_lupdatedatereadofnote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_lupdatedatereadofnote(uuid, integer, timestamp without time zone, double precision);
CREATE OR REPLACE FUNCTION public.note_lupdatedatereadofnote(
    IN noteno uuid,
    IN userno integer,
    IN dateread timestamp without time zone,
    IN timezoneoffsetofdateread double precision
) RETURNS void
AS $function$
BEGIN


	IF (SELECT UserNo FROM Note_LNotes WHERE NoteNo = note_lupdatedatereadofnote.noteno) = note_lupdatedatereadofnote.userno THEN
	
		UPDATE Note_List SET ReadDate = note_lupdatedatereadofnote.dateread, NoteTimeZoneRead = note_lupdatedatereadofnote.timezoneoffsetofdateread
		WHERE ListNo = note_lupdatedatereadofnote.noteno

	END IF;

	ELSIF (SELECT COUNT(*) FROM Note_LSharers WHERE NoteNo = note_lupdatedatereadofnote.noteno AND UserShare = note_lupdatedatereadofnote.userno) != 0 THEN

		UPDATE Note_Share SET IsRead = TRUE, ReadDate = note_lupdatedatereadofnote.dateread, timeOffset = note_lupdatedatereadofnote.timezoneoffsetofdateread
		WHERE ListNo = note_lupdatedatereadofnote.noteno AND UserShare = note_lupdatedatereadofnote.userno

	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
