-- ─── PROCEDURE→FUNCTION: note_getnote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.note_getnote();
CREATE OR REPLACE FUNCTION public.note_getnote(
) RETURNS SETOF record
AS $function$
DECLARE
    isread boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT IsRead INTO isread FROM NoteList WHERE NoteNo = NoteNo
	-- 해당 쪽지가 안읽음이면, 읽음으로 업데이트 처리
	IF IsRead = FALSE THEN;
		UPDATE NoteList
		IsRead := 1,;
			ReadDate = NOW()
		WHERE NoteNo = NoteNo	
	END IF;
	-- 해당 쪽지 정보를 조회 한다.
	RETURN QUERY
	SELECT
		COALESCE((SELECT /* TOP 1 */ NoteNo 
				FROM NoteList 
				WHERE NoteNo = (SELECT MAX(NoteNo) 
								FROM NoteList 
								WHERE NoteNo < L.NoteNo 
								AND UserNo = L.UserNo 
								AND NoteBoxNo = L.NoteBoxNo )),-1) 
		AS PrevNo,
		COALESCE((SELECT /* TOP 1 */ NoteNo 
				FROM NoteList 
				WHERE NoteNo = (SELECT MIN(NoteNo) 
								FROM NoteList 
								WHERE NoteNo > L.NoteNo 
								AND UserNo = L.UserNo 
								AND NoteBoxNo = L.NoteBoxNo )),-1) 
		AS NextNo,
		L.NoteNo,
		L.SendNoteNo,
		L.UserNo,
		public."COMNGetUserName"(L.UserNo) AS UserName,
		L.SendUserNo,
		public."COMNGetUserName"(SendUserNo) As SendUserName,
		L.SendDate,
		L.Contents,
		L.NoteBoxNo,
		B.BoxType,
		B.BoxName,
		L.IsRead,
		L.ReadDate
	FROM NoteList L
	JOIN NoteBox B ON L.NoteBoxNo = B.NoteBoxNo
	WHERE L.NoteNo = NoteNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
