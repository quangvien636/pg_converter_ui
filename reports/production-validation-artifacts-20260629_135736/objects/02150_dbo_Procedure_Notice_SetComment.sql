-- ─── PROCEDURE→FUNCTION: notice_setcomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_setcomment(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.notice_setcomment(
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
		INSERT INTO NoticeComments(NoticeNo,RegUserNo,RegDate,Content,ModUserNo,ModDate)
		VALUES(NoticeNo,RegUserNo,NOW(),Content,RegUserNo,NOW())
		RTN := lastval();
	END IF;
	ELSIF Mode = '1' THEN;
		UPDATE NoticeComments SET Content=notice_setcomment.content,ModUserNo=notice_setcomment.reguserno,ModDate=NOW() WHERE CommentNo=notice_setcomment.commentno
		RTN := @ERROR;
	END IF;
	ELSE;
		DELETE FROM NoticeComments WHERE CommentNo=notice_setcomment.commentno
		RTN := @ERROR;
	END IF;
	
	RETURN QUERY
	SELECT RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
