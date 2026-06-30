-- ─── PROCEDURE→FUNCTION: note_movenote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.note_movenote(character varying);
CREATE OR REPLACE FUNCTION public.note_movenote(
    IN notenolist character varying
) RETURNS SETOF record
AS $function$
DECLARE
    chknotenolist character varying;
    tempnoteno character varying;
    noteboxno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	ChkNoteNoList := REPLACE(NoteNoList,',','');
	IF LEN(ChkNoteNoList) > 0 THEN
		NoteNoList := note_movenote.notenolist || ',';
		WHILE STRPOS(',NoteNoList, ') > 0 LOOP


			TempNoteNo := SUBSTRING(NoteNoList,0,STRPOS(',NoteNoList, '));
			SELECT NoteBoxNo INTO noteboxno FROM NoteBox
			WHERE UserNo = UserNo
			AND BoxType = BoxType
			
			UPDATE NoteList
			NoteBoxNo := NoteBoxNo;
			WHERE NoteNo = CONVERT(INT,TempNoteNo)
			
			NoteNoList := SUBSTRING(NoteNoList,STRPOS(',NoteNoList, ')+1,LEN(NoteNoList));
		END LOOP;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
