-- ─── PROCEDURE→FUNCTION: note_deletenote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.note_deletenote();
CREATE OR REPLACE FUNCTION public.note_deletenote(
) RETURNS void
AS $function$
DECLARE
    chknotenolist character varying;
    tempnotenolist character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	ChkNoteNoList := REPLACE(NoteNoList,',','');
	IF LEN(ChkNoteNoList) > 0 THEN
		NoteNoList := NoteNoList || ',';
		WHILE STRPOS(',NoteNoList, ') > 0 LOOP

			TempNoteNoList := SUBSTRING(NoteNoList,0,STRPOS(',NoteNoList, '));;
			DELETE FROM NoteReceiveUser WHERE NoteNo = TempNoteNoList;
			DELETE FROM NoteList WHERE NoteNo = TempNoteNoList
			
			NoteNoList := SUBSTRING(NoteNoList,STRPOS(',NoteNoList, ')+1,LEN(NoteNoList));
		END LOOP;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
