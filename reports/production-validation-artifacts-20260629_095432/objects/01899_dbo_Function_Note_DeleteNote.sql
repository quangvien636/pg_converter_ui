-- ─── FUNCTION: note_deletenote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_deletenote();
CREATE OR REPLACE FUNCTION public.note_deletenote(
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    chknotenolist character varying;
    tempnotenolist character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SET ChkNoteNoList = REPLACE(NoteNoList,',','')
	
	IF LEN(ChkNoteNoList) > 0
	BEGIN
		SET NoteNoList = NoteNoList || ','
		
		WHILE STRPOS(',NoteNoList, ') > 0
		BEGIN

			SET TempNoteNoList = SUBSTRING(NoteNoList,0,STRPOS(',NoteNoList, '))
			
			DELETE FROM NoteReceiveUser WHERE NoteNo = TempNoteNoList;
			DELETE FROM NoteList WHERE NoteNo = TempNoteNoList
			
			SET NoteNoList = SUBSTRING(NoteNoList,STRPOS(',NoteNoList, ')+1,LEN(NoteNoList))
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
