-- ─── PROCEDURE→FUNCTION: note_addandupdatecomments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_addandupdatecomments(uuid, uuid, integer, character varying, timestamp without time zone, uuid);
CREATE OR REPLACE FUNCTION public.note_addandupdatecomments(
    IN commentno uuid,
    IN listno uuid,
    IN userno integer,
    IN content character varying,
    IN date timestamp without time zone DEFAULT 'GETUTCDATE',
    IN parentid uuid DEFAULT '00000000-0000-0000-0000-000000000000'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT CommentNo INTO checkcommentno FROM Note_Comments WHERE CommentNo = note_addandupdatecomments.commentno
	
	RETURN QUERY
	SELECT CheckCommentNo

	IF CheckCommentNo = '00000000-0000-0000-0000-000000000000' THEN

		INSERT INTO Note_Comments( CommentNo, ListNo, RegUserNo, RegDate, ModUserNo, ModDate,Content, ParentID)
						 VALUES  (CommentNo,ListNo,UserNo,Date,UserNo,Date,Content,ParentID)

    END IF;
	ELSE;
		UPDATE Note_Comments
		   ModUserNo := note_addandupdatecomments.userno;
			  ,ModDate = note_addandupdatecomments.date
			  ,Content = note_addandupdatecomments.content
			  ,ReadUserList = ''
		 WHERE CommentNo = note_addandupdatecomments.commentno
	END IF;

	UPDATE Note_List SET DayEdit = note_addandupdatecomments.date WHERE ListNo = note_addandupdatecomments.listno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
