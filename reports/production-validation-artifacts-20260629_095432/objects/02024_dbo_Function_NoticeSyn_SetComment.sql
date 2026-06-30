-- ─── FUNCTION: noticesyn_setcomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_setcomment(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_setcomment(
    commentno integer,
    noticeno integer,
    reguserno integer,
    content character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    rtn integer;
BEGIN


	IF Mode = '0'
	BEGIN;
		INSERT INTO NoticeSyn_Comments(NoticeNo,RegUserNo,RegDate,Content,ModUserNo,ModDate)
		VALUES(NoticeNo,RegUserNo,NOW(),Content,RegUserNo,NOW())
		SET RTN = lastval()
	END
	ELSE IF Mode = '1'
	BEGIN;
		UPDATE NoticeSyn_Comments SET Content=noticesyn_setcomment.content,ModUserNo=noticesyn_setcomment.reguserno,ModDate=NOW() WHERE CommentNo=noticesyn_setcomment.commentno
		SET RTN = @ERROR
	END
	ELSE
	BEGIN;
		DELETE FROM NoticeSyn_Comments WHERE CommentNo=noticesyn_setcomment.commentno
		SET RTN = @ERROR
	END
	
	RETURN QUERY
	SELECT RTN
END;
--------------------//////////////////---------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
