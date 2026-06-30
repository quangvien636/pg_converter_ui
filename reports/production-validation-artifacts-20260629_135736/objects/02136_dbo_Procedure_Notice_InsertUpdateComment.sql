-- ─── PROCEDURE→FUNCTION: notice_insertupdatecomment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_insertupdatecomment(integer, integer, integer, character varying, integer, character varying, integer, character varying, integer, character varying, bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_insertupdatecomment(
    IN commentno integer,
    IN noticeno integer,
    IN reguserno integer,
    IN content character varying,
    IN mode integer,
    IN modusername character varying,
    IN modpositionno integer,
    IN modpositionname character varying,
    IN moddepartno integer,
    IN moddepartname character varying,
    IN groupno bigint,
    IN depth integer,
    IN orderno integer
) RETURNS SETOF record
AS $function$
DECLARE
    rtn integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Mode = 0 THEN
		IF GroupNo = 0 THEN
			GroupNo := (SELECT MAX(GroupNo) + 1 FROM NoticeComments WHERE NoticeNo = notice_insertupdatecomment.noticeno);
			IF GroupNo IS NULL THEN
				GroupNo := 1;
			END IF;
		END IF;
	
		UPDATE NoticeComments SET OrderNo = notice_insertupdatecomment.orderno + 1
		WHERE NoticeNo = notice_insertupdatecomment.noticeno AND OrderNo >= notice_insertupdatecomment.orderno

		INSERT INTO NoticeComments(NoticeNo,RegUserNo,RegDate,Content,ModUserNo,ModDate,ModUserName,ModPositionNo,ModPositionName,
		ModDepartNo,ModDepartName,GroupNo,Depth,OrderNo)
		VALUES(NoticeNo,RegUserNo,NOW(),Content,RegUserNo,NOW(),ModUserName,ModPositionNo,ModPositionName,
		ModDepartNo,ModDepartName,GroupNo,Depth,OrderNo)
		RTN := lastval();
	END IF;
	ELSIF Mode = 1 THEN;
		UPDATE NoticeComments SET Content=notice_insertupdatecomment.content,ModUserNo=notice_insertupdatecomment.reguserno,ModDate=NOW() WHERE CommentNo=notice_insertupdatecomment.commentno
		RTN := @ERROR;
	END IF;
	ELSE;
		DELETE FROM NoticeComments WHERE CommentNo=notice_insertupdatecomment.commentno
		RTN := @ERROR;
	END IF;
	
	RETURN QUERY
	SELECT RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
