-- ─── FUNCTION: notice_mobile_getcontentnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_mobile_getcontentnotice(integer);
CREATE OR REPLACE FUNCTION public.notice_mobile_getcontentnotice(
    noticeno integer
) RETURNS TABLE(
    commentno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT NoticeNo, RegUserNo, RegDate, ModUserNo, ModDate, Title, DivisionNo, Content, StartDate, EndDate,
		Important, IsShare, IsAttach, TotalViews, CurrentViews, IsContentImg
	FROM Notices
	WHERE NoticeNo = notice_mobile_getcontentnotice.noticeno

	RETURN QUERY
	SELECT AttachNo, FileName, FileLength, FilePath
	FROM NoticeAttachments
	WHERE NoticeNo = notice_mobile_getcontentnotice.noticeno
	ORDER BY AttachNo ASC

	RETURN QUERY
	SELECT CommentNo, RegUserNo, RegDate, ModUserNo, ModDate, Content
	FROM NoticeComments
	WHERE NoticeNo = notice_mobile_getcontentnotice.noticeno
	ORDER BY CommentNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
