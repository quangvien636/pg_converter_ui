-- ─── FUNCTION: notice_setcomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_setcomment(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.notice_setcomment(
    commentno integer,
    noticeno integer,
    reguserno integer,
    content character varying
) RETURNS TABLE(
    rtn text
)
AS $function$
DECLARE
    rtn integer;
BEGIN


	IF Mode = '0'
	BEGIN;
		INSERT INTO NoticeComments(NoticeNo,RegUserNo,RegDate,Content,ModUserNo,ModDate)
		VALUES(NoticeNo,RegUserNo,NOW(),Content,RegUserNo,NOW())
		SET RTN = lastval()
	END
	ELSE IF Mode = '1'
	BEGIN;
		UPDATE NoticeComments SET Content=notice_setcomment.content,ModUserNo=notice_setcomment.reguserno,ModDate=NOW() WHERE CommentNo=notice_setcomment.commentno
		SET RTN = @ERROR
	END
	ELSE
	BEGIN;
		DELETE FROM NoticeComments WHERE CommentNo=notice_setcomment.commentno
		SET RTN = @ERROR
	END
	
	RETURN QUERY
	SELECT RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
