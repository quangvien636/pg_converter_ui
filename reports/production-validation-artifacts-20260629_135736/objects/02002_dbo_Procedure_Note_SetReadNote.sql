-- ─── PROCEDURE→FUNCTION: note_setreadnote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.note_setreadnote(boolean);
CREATE OR REPLACE FUNCTION public.note_setreadnote(
    IN isread boolean
) RETURNS void
AS $function$
DECLARE
    chknotenolist character varying;
    tempnoteno character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	ChkNoteNoList := REPLACE(NoteNoList,',','');
	IF LEN(ChkNoteNoList) > 0 THEN
		NoteNoList := NoteNoList || ',';
		WHILE STRPOS(',NoteNoList, ') > 0 LOOP

			TempNoteNo := SUBSTRING(NoteNoList,0,STRPOS(',NoteNoList, '));;
			UPDATE NoteList
			IsRead := note_setreadnote.isread,;
				ReadDate = CASE WHEN IsRead = TRUE THEN NOW() ELSE '1900-01-01 00:00:00' END
			WHERE NoteNo = CONVERT(INT,TempNoteNo)
	
	
			NoteNoList := SUBSTRING(NoteNoList,STRPOS(',NoteNoList, ')+1,LEN(NoteNoList));
		END LOOP;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
