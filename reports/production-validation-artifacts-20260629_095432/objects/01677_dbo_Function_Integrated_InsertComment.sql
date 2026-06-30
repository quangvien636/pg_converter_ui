-- ─── FUNCTION: integrated_insertcomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_insertcomment(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_insertcomment(
    commentno integer,
    integratedno integer,
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
		INSERT INTO Integrated_Comments(IntegratedNo,RegUserNo,RegDate,Content,ModUserNo,ModDate)
		VALUES(IntegratedNo,RegUserNo,NOW(),Content,RegUserNo,NOW())
		SET RTN = lastval()
	END
	ELSE IF Mode = '1'
	BEGIN;
		UPDATE Integrated_Comments SET Content=integrated_insertcomment.content,ModUserNo=integrated_insertcomment.reguserno,ModDate=NOW() WHERE CommentNo=integrated_insertcomment.commentno
		SET RTN = @ERROR
	END
	ELSE
	BEGIN;
		DELETE FROM Integrated_Comments WHERE CommentNo=integrated_insertcomment.commentno
		SET RTN = @ERROR
	END
	
	RETURN QUERY
	SELECT RTN
END;

-------------------------------//////////////////////---------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
