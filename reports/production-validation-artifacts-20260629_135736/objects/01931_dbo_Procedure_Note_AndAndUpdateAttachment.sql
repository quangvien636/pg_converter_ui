-- ─── PROCEDURE→FUNCTION: note_andandupdateattachment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_andandupdateattachment(uuid, integer, character varying, uuid, character varying, integer, timestamp without time zone, boolean, character varying, character varying, double precision, character varying);
CREATE OR REPLACE FUNCTION public.note_andandupdateattachment(
    IN attachmentno uuid,
    IN userno integer,
    IN fileurl character varying,
    IN listno uuid,
    IN typefile character varying,
    IN type integer,
    IN daycreate timestamp without time zone,
    IN isavatar boolean,
    IN fileuri character varying DEFAULT '',
    IN realpath character varying DEFAULT '',
    IN attachtimezone double precision DEFAULT 0,
    IN filesize character varying DEFAULT '0'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Type=1 THEN

			IF IsAvatar = TRUE THEN;
				UPDATE Note_Attachment
				IsAvatar := 0;
				WHERE  UserNo=note_andandupdateattachment.userno AND ListNo=note_andandupdateattachment.listno
			END IF;

			INSERT INTO Note_Attachment(AttachmentNo,UserNo,FileUrl,ListNo,TypeFile,DayCreate,DayEdit,fileURI,RealPath,IsAvatar, AttachTimeZone, FileSize)
			VALUES (AttachmentNo,UserNo,FileUrl,ListNo,TypeFile,DayCreate,DayCreate,fileURI,RealPath,IsAvatar,AttachTimeZone, FileSize)

			UPDATE Note_List SET DayEdit = note_andandupdateattachment.daycreate WHERE ListNo=note_andandupdateattachment.listno
			RETURN QUERY
			select 1
		END IF;
	IF Type=2 THEN
			IF IsAvatar = TRUE THEN;
				UPDATE Note_Attachment
				IsAvatar := 0;
				WHERE UserNo=note_andandupdateattachment.userno AND ListNo=note_andandupdateattachment.listno
			END IF;

			UPDATE Note_Attachment
			FileUrl := note_andandupdateattachment.fileurl,ListNo=note_andandupdateattachment.listno,TypeFile=note_andandupdateattachment.typefile,DayEdit=note_andandupdateattachment.daycreate,fileURI=note_andandupdateattachment.fileuri,RealPath=note_andandupdateattachment.realpath,IsAvatar=note_andandupdateattachment.isavatar, AttachTimeZone = note_andandupdateattachment.attachtimezone, FileSize = note_andandupdateattachment.filesize;
			WHERE AttachmentNo=note_andandupdateattachment.attachmentno
			RETURN QUERY
			select 1
		END IF;
	IF Type=3 THEN

		SELECT ListNo INTO notetemp FROM Note_Attachment WHERE AttachmentNo = note_andandupdateattachment.attachmentno
		SELECT UserNo INTO usertemp FROM Note_List WHERE  ListNo=Notetemp

		DELETE FROM Note_Attachment
		WHERE AttachmentNo=note_andandupdateattachment.attachmentno And (UserNo=note_andandupdateattachment.userno Or Usertemp=note_andandupdateattachment.userno)

		RETURN QUERY
		SELECT 1
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
