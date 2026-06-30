-- ─── PROCEDURE→FUNCTION: schedule_setcomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_setcomment(integer, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_setcomment(
    IN commentno integer,
    IN scheduleno integer,
    IN reguserno integer,
    IN content character varying,
    IN mode integer
) RETURNS SETOF record
AS $function$
DECLARE
    rtn integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Mode = 0 THEN;
		INSERT INTO Schedule_Comments(ScheduleNo,RegUserNo,RegDate,Content,ModUserNo,ModDate)
		VALUES(ScheduleNo,RegUserNo,NOW(),Content,RegUserNo,NOW())
		RTN := lastval();
	END IF;
	ELSIF Mode = 1 THEN;
		UPDATE Schedule_Comments SET 
			Content = schedule_setcomment.content
			, ModUserNo = schedule_setcomment.reguserno
			, ModDate = NOW() 
		WHERE CommentNo = schedule_setcomment.commentno

		RTN := @ERROR;
	END IF;
	ELSE;
		DELETE FROM Schedule_Comments 
		WHERE CommentNo = schedule_setcomment.commentno
		RTN := @ERROR;
	END IF;
	
	RETURN QUERY
	SELECT RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
