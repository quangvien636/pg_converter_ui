-- ─── FUNCTION: note_movenote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_movenote(character varying);
CREATE OR REPLACE FUNCTION public.note_movenote(
    notenolist character varying
) RETURNS TABLE(
    col1 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    chknotenolist character varying;
    tempnoteno character varying;
    noteboxno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SET ChkNoteNoList = REPLACE(NoteNoList,',','')
	
	IF LEN(ChkNoteNoList) > 0
	BEGIN
		SET NoteNoList = note_movenote.notenolist || ','
		
		WHILE STRPOS(',NoteNoList, ') > 0
		BEGIN


			SET TempNoteNo = SUBSTRING(NoteNoList,0,STRPOS(',NoteNoList, '))
			
			SELECT NoteBoxNo = NoteBoxNo FROM NoteBox
			WHERE UserNo = UserNo
			AND BoxType = BoxType
			
			UPDATE NoteList
			SET
				NoteBoxNo = NoteBoxNo
			WHERE NoteNo = CONVERT(INT,TempNoteNo)
			
			SET NoteNoList = SUBSTRING(NoteNoList,STRPOS(',NoteNoList, ')+1,LEN(NoteNoList))
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
