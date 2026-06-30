-- ─── FUNCTION: note_setreadnote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_setreadnote(boolean);
CREATE OR REPLACE FUNCTION public.note_setreadnote(
    isread boolean
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    chknotenolist character varying;
    tempnoteno character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SET ChkNoteNoList = REPLACE(NoteNoList,',','')
	
	IF LEN(ChkNoteNoList) > 0
	BEGIN
		SET NoteNoList = NoteNoList || ','
		
		WHILE STRPOS(',NoteNoList, ') > 0
		BEGIN

			SET TempNoteNo = SUBSTRING(NoteNoList,0,STRPOS(',NoteNoList, '))
			
			UPDATE NoteList
			SET
				IsRead = note_setreadnote.isread,
				ReadDate = CASE WHEN IsRead = TRUE THEN NOW() ELSE '1900-01-01 00:00:00' END
			WHERE NoteNo = CONVERT(INT,TempNoteNo)
	
	
			SET NoteNoList = SUBSTRING(NoteNoList,STRPOS(',NoteNoList, ')+1,LEN(NoteNoList))
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
