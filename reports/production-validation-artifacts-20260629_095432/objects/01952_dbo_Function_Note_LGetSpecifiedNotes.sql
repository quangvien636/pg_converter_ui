-- ─── FUNCTION: note_lgetspecifiednotes ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lgetspecifiednotes(integer);
CREATE OR REPLACE FUNCTION public.note_lgetspecifiednotes(
    userno integer
) RETURNS TABLE(
    noteno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    notenos table (
		noteno uniqueidentifier
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SET oPos = 1
	SET nPos = 1

	WHILE (nPos > 0) BEGIN
	
		SET nPos = STRPOS(ListOfNoteNos, oPos, ';')

		IF (nPos = 0)
			SET TmpVar = RIGHT(ListOfNoteNos, LEN(ListOfNoteNos) - oPos + 1)
		ELSE
			SET TmpVar = SUBSTRING(ListOfNoteNos, oPos, nPos - oPos)

		IF (LEN(TmpVar) > 0);
			INSERT INTO NoteNos VALUES (TmpVar)
			
		SET oPos = nPos + 1

	END


		NoteNo UNIQUEIDENTIFIER,
		Name NVARCHAR(250),
		GroupNo UNIQUEIDENTIFIER,
		UserNo INT,
		Description NTEXT,
		Latitude FLOAT,
		Longitude FLOAT,
		Address NTEXT,
		DateCreated DATETIME,
		DateChanged DATETIME,
		TimeZoneOffsetOfDateCreated FLOAT,
		TimeZoneOffsetOfDateChanged FLOAT,
		IsFavorite INT,
		DateRead DATETIME,
		TimeZoneOffsetOfDateRead FLOAT
	)

	INSERT INTO ListOfNotes
	RETURN QUERY
	SELECT NoteNo, Name, GroupNo, UserNo, Description, Latitude, Longitude,
		CASE WHEN Latitude != 0 AND Longitude != 0 THEN Description ELSE '' END AS Address,
		DateCreated, DateChanged, TimeZoneOffsetOfDateCreated, TimeZoneOffsetOfDateChanged, 
		IsFavorite, DateRead, TimeZoneOffsetOfDateRead
	FROM Note_LNotes
	WHERE NoteNo IN (SELECT NoteNo FROM NoteNos)

	RETURN QUERY
	SELECT * FROM ListOfNotes

	RETURN QUERY
	SELECT AttachmentNo, UserNo, FileUrl, NoteNo, TypeFile, DateCreated, DateChanged, FileURI, RealPath,
		IsRepresentative, TimeZoneOffsetOfDateCreated, TimeZoneOffsetOfDateCreated AS TimeZoneOffsetOfDateChanged, FileSize, FileName
	FROM Note_LAttachments
	WHERE NoteNo IN (SELECT NoteNo FROM ListOfNotes)


		CommentNo UNIQUEIDENTIFIER,
		NoteNo UNIQUEIDENTIFIER,
		UserNo INT,
		DateCreated DATETIME,
		ModUserNo INT,
		DateChanged DATETIME,
		Content text,
		TimeZoneOffsetOfDateCreated FLOAT,
		TimeZoneOffsetOfDateChanged FLOAT,
		ParentNo UNIQUEIDENTIFIER
	)

	INSERT INTO ListOfComments
	RETURN QUERY
	SELECT CommentNo, NoteNo, UserNo, DateCreated, ModUserNo, DateChanged, Content,
		TimeZoneOffsetOfDateCreated, TimeZoneOffsetOfDateChanged, ParentNo
	FROM Note_LComments
	WHERE NoteNo IN (SELECT NoteNo FROM ListOfNotes)

	RETURN QUERY
	SELECT * FROM ListOfComments

	RETURN QUERY
	SELECT AttachmentNo, UserNo, FileUrl, NoteNo, TypeFile, DateCreated, DateChanged, FileURI, RealPath,
		IsRepresentative, TimeZoneOffsetOfDateCreated, TimeZoneOffsetOfDateCreated AS TimeZoneOffsetOfDateChanged, FileSize, FileName
	FROM Note_LAttachments
	WHERE NoteNo IN (SELECT CommentNo FROM ListOfComments)

	RETURN QUERY
	SELECT ShareNo, UserShare AS UserNo, NoteNo, DateCreated, DateChanged, GroupNo, IsRead, DateRead, IsReads, IsFavorite,
		ShareType, TimeZoneOffsetOfDateRead, CompanyNo, ShareCompanyNo
	FROM Note_LSharers
	WHERE NoteNo IN (SELECT NoteNo FROM ListOfNotes);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
