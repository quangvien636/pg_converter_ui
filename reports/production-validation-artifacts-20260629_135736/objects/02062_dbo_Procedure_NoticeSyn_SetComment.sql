-- ─── PROCEDURE→FUNCTION: noticesyn_setcomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_setcomment(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_setcomment(
    IN commentno integer,
    IN noticeno integer,
    IN reguserno integer,
    IN content character varying
) RETURNS SETOF record
AS $function$
DECLARE
    rtn integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Mode = '0' THEN;
		INSERT INTO NoticeSyn_Comments(NoticeNo,RegUserNo,RegDate,Content,ModUserNo,ModDate)
		VALUES(NoticeNo,RegUserNo,NOW(),Content,RegUserNo,NOW())
		RTN := lastval();
	END IF;
	ELSIF Mode = '1' THEN;
		UPDATE NoticeSyn_Comments SET Content=noticesyn_setcomment.content,ModUserNo=noticesyn_setcomment.reguserno,ModDate=NOW() WHERE CommentNo=noticesyn_setcomment.commentno
		RTN := @ERROR;
	END IF;
	ELSE;
		DELETE FROM NoticeSyn_Comments WHERE CommentNo=noticesyn_setcomment.commentno
		RTN := @ERROR;
	END IF;
	
	RETURN QUERY
	SELECT RTN
END;
--------------------//////////////////---------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
