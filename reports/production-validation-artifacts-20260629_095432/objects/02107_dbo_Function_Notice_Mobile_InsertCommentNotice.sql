-- ─── FUNCTION: notice_mobile_insertcommentnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_mobile_insertcommentnotice(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.notice_mobile_insertcommentnotice(
    noticeno integer,
    reguserno integer,
    regdate timestamp without time zone
) RETURNS TABLE(
    commentno text
)
AS $function$
DECLARE
    commentno integer;
BEGIN


	INSERT INTO NoticeComments (NoticeNo, RegUserNo, RegDate, ModUserNo, ModDate, Content)
	VALUES (NoticeNo, RegUserNo, RegDate, RegUserNo, RegDate, Content)


	SET CommentNo = lastval()

	RETURN QUERY
	SELECT CommentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
