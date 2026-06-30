-- ─── FUNCTION: notice_insertupdatecomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_insertupdatecomment(integer, integer, integer, character varying, integer, character varying, integer, character varying, integer, character varying, bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_insertupdatecomment(
    commentno integer,
    noticeno integer,
    reguserno integer,
    content character varying,
    mode integer,
    modusername character varying,
    modpositionno integer,
    modpositionname character varying,
    moddepartno integer,
    moddepartname character varying,
    groupno bigint,
    depth integer,
    orderno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    rtn integer;
BEGIN


	IF Mode = 0
	BEGIN
		IF (GroupNo = 0)
		BEGIN
			SET GroupNo = (SELECT MAX(GroupNo) + 1 FROM NoticeComments WHERE NoticeNo = notice_insertupdatecomment.noticeno)
			IF (GroupNo IS NULL) BEGIN
				SET GroupNo = 1
			END
		END
	
		UPDATE NoticeComments SET OrderNo = notice_insertupdatecomment.orderno + 1
		WHERE NoticeNo = notice_insertupdatecomment.noticeno AND OrderNo >= notice_insertupdatecomment.orderno

		INSERT INTO NoticeComments(NoticeNo,RegUserNo,RegDate,Content,ModUserNo,ModDate,ModUserName,ModPositionNo,ModPositionName,
		ModDepartNo,ModDepartName,GroupNo,Depth,OrderNo)
		VALUES(NoticeNo,RegUserNo,NOW(),Content,RegUserNo,NOW(),ModUserName,ModPositionNo,ModPositionName,
		ModDepartNo,ModDepartName,GroupNo,Depth,OrderNo)
		SET RTN = lastval()
	END
	ELSE IF Mode = 1
	BEGIN;
		UPDATE NoticeComments SET Content=notice_insertupdatecomment.content,ModUserNo=notice_insertupdatecomment.reguserno,ModDate=NOW() WHERE CommentNo=notice_insertupdatecomment.commentno
		SET RTN = @ERROR
	END
	ELSE
	BEGIN;
		DELETE FROM NoticeComments WHERE CommentNo=notice_insertupdatecomment.commentno
		SET RTN = @ERROR
	END
	
	RETURN QUERY
	SELECT RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
