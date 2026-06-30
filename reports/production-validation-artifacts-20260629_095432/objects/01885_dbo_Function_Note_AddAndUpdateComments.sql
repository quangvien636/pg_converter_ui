-- ─── FUNCTION: note_addandupdatecomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_addandupdatecomments(uuid, uuid, integer, character varying, timestamp without time zone, uuid);
CREATE OR REPLACE FUNCTION public.note_addandupdatecomments(
    commentno uuid,
    listno uuid,
    userno integer,
    content character varying,
    date timestamp without time zone DEFAULT 'GETUTCDATE',
    parentid uuid DEFAULT '00000000-0000-0000-0000-000000000000'
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN



	SELECT CheckCommentNo = note_addandupdatecomments.commentno FROM Note_Comments WHERE CommentNo = note_addandupdatecomments.commentno
	
	RETURN QUERY
	SELECT CheckCommentNo

	IF CheckCommentNo = '00000000-0000-0000-0000-000000000000'
	BEGIN

		INSERT INTO Note_Comments( CommentNo, ListNo, RegUserNo, RegDate, ModUserNo, ModDate,Content, ParentID)
						 VALUES  (CommentNo,ListNo,UserNo,Date,UserNo,Date,Content,ParentID)

    END
	ELSE
	BEGIN;
		UPDATE Note_Comments
		   SET ModUserNo = note_addandupdatecomments.userno
			  ,ModDate = note_addandupdatecomments.date
			  ,Content = note_addandupdatecomments.content
			  ,ReadUserList = ''
		 WHERE CommentNo = note_addandupdatecomments.commentno
	END

	UPDATE Note_List SET DayEdit = note_addandupdatecomments.date WHERE ListNo = note_addandupdatecomments.listno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
