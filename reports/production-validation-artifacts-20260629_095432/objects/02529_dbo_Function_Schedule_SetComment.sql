-- ─── FUNCTION: schedule_setcomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_setcomment(integer, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_setcomment(
    commentno integer,
    scheduleno integer,
    reguserno integer,
    content character varying,
    mode integer
) RETURNS TABLE(
    rtn text
)
AS $function$
DECLARE
    rtn integer;
BEGIN


	IF Mode = 0
	BEGIN;
		INSERT INTO Schedule_Comments(ScheduleNo,RegUserNo,RegDate,Content,ModUserNo,ModDate)
		VALUES(ScheduleNo,RegUserNo,NOW(),Content,RegUserNo,NOW())
		SET RTN = lastval()
	END
	ELSE IF Mode = 1
	BEGIN;
		UPDATE Schedule_Comments SET 
			Content = schedule_setcomment.content
			, ModUserNo = schedule_setcomment.reguserno
			, ModDate = NOW() 
		WHERE CommentNo = schedule_setcomment.commentno

		SET RTN = @ERROR
	END
	ELSE
	BEGIN;
		DELETE FROM Schedule_Comments 
		WHERE CommentNo = schedule_setcomment.commentno
		SET RTN = @ERROR
	END
	
	RETURN QUERY
	SELECT RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
