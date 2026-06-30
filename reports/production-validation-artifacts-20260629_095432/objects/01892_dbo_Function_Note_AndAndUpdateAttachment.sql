-- ─── FUNCTION: note_andandupdateattachment ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_andandupdateattachment(uuid, integer, character varying, uuid, character varying, integer, timestamp without time zone, boolean, character varying, character varying, double precision, character varying);
CREATE OR REPLACE FUNCTION public.note_andandupdateattachment(
    attachmentno uuid,
    userno integer,
    fileurl character varying,
    listno uuid,
    typefile character varying,
    type integer,
    daycreate timestamp without time zone,
    isavatar boolean,
    fileuri character varying DEFAULT '',
    realpath character varying DEFAULT '',
    attachtimezone double precision DEFAULT 0,
    filesize character varying DEFAULT '0'
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	IF Type=1
		BEGIn

			if (IsAvatar = TRUE)
			BEGIN;
				UPDATE Note_Attachment
				SET IsAvatar = FALSE
				WHERE  UserNo=note_andandupdateattachment.userno AND ListNo=note_andandupdateattachment.listno
			END

			INSERT INTO Note_Attachment(AttachmentNo,UserNo,FileUrl,ListNo,TypeFile,DayCreate,DayEdit,fileURI,RealPath,IsAvatar, AttachTimeZone, FileSize)
			VALUES (AttachmentNo,UserNo,FileUrl,ListNo,TypeFile,DayCreate,DayCreate,fileURI,RealPath,IsAvatar,AttachTimeZone, FileSize)

			UPDATE Note_List SET DayEdit = note_andandupdateattachment.daycreate WHERE ListNo=note_andandupdateattachment.listno
			RETURN QUERY
			select 1
		END
	IF Type=2
		BEGIN
			if (IsAvatar = TRUE)
			BEGIN;
				UPDATE Note_Attachment
				SET IsAvatar = FALSE
				WHERE UserNo=note_andandupdateattachment.userno AND ListNo=note_andandupdateattachment.listno
			END

			UPDATE Note_Attachment
			SET FileUrl=note_andandupdateattachment.fileurl,ListNo=note_andandupdateattachment.listno,TypeFile=note_andandupdateattachment.typefile,DayEdit=note_andandupdateattachment.daycreate,fileURI=note_andandupdateattachment.fileuri,RealPath=note_andandupdateattachment.realpath,IsAvatar=note_andandupdateattachment.isavatar, AttachTimeZone = note_andandupdateattachment.attachtimezone, FileSize = note_andandupdateattachment.filesize
			WHERE AttachmentNo=note_andandupdateattachment.attachmentno
			RETURN QUERY
			select 1
		END
	IF Type=3
		BEGIN

		SELECT Notetemp = note_andandupdateattachment.listno FROM Note_Attachment WHERE AttachmentNo = note_andandupdateattachment.attachmentno
		SELECT Usertemp=note_andandupdateattachment.userno FROM Note_List WHERE  ListNo=Notetemp

		DELETE FROM Note_Attachment
		WHERE AttachmentNo=note_andandupdateattachment.attachmentno And (UserNo=note_andandupdateattachment.userno Or Usertemp=note_andandupdateattachment.userno)

		RETURN QUERY
		SELECT 1
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
