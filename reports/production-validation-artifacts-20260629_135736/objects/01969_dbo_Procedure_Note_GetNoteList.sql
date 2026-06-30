-- ─── PROCEDURE→FUNCTION: note_getnotelist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getnotelist(character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.note_getnotelist(
    IN boxtype character varying,
    IN currpage integer,
    IN pagesize integer,
    IN isread boolean DEFAULT TRUE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT *
	FROM
	(
		SELECT 
			ROW_NUMBER() OVER(ORDER BY SendDate DESC) AS RowNum,
			N.NoteNo,
			N.SendNoteNo,
			N.UserNo,
			N.SendUserNo,
			CASE WHEN B.BoxType <> 'O' THEN public."COMNGetUserName"(N.SendUserNo) 
			ELSE (SELECT STUFF((
				SELECT ',' || CASE WHEN UserNo <> 0 THEN public."COMNGetUserName"(UserNo)
						 WHEN DepartNo <> 0 THEN (SELECT Name FROM Organization_Departments D WHERE D.DepartNo = R.DepartNo)
						 END;
				 FROM NoteReceiveUser R
				WHERE R.NoteNo = N.NoteNo
				FOR XML PATH('')),1,1,''))
			 END AS SendUserName,
			N.SendDate,
			N.Contents,
			N.IsRead,
			N.ReadDate,
			CASE WHEN SendNoteNo = 0 THEN (SELECT COUNT(SendNoteNo) FROM NoteList L WHERE L.SendNoteNo = N.NoteNo AND IsRead = TRUE ) ELSE 0 END ReadCnt,
			CASE WHEN SendNoteNo = 0 THEN (SELECT COUNT(SendNoteNo) FROM NoteList L WHERE L.SendNoteNo = N.NoteNo) ELSE 0 END TotalCnt
		FROM NoteList N
		INNER JOIN NoteBox B ON N.UserNo = B.UserNo AND N.NoteBoxNo = B.NoteBoxNo
		WHERE N.UserNo = UserNo
		AND B.BoxType = note_getnotelist.boxtype
		AND (N.IsRead = note_getnotelist.isread OR 1=note_getnotelist.isread)
	) A
	WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
