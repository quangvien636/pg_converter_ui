-- ─── FUNCTION: noticesyn_mobile_getcontentnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_mobile_getcontentnotice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_mobile_getcontentnotice(
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
	FROM NoticesSyn
	WHERE NoticeNo = noticesyn_mobile_getcontentnotice.noticeno

	RETURN QUERY
	SELECT AttachNo, FileName, FileLength, FilePath
	FROM NoticeSyn_Attachments
	WHERE NoticeNo = noticesyn_mobile_getcontentnotice.noticeno
	ORDER BY AttachNo ASC

	RETURN QUERY
	SELECT CommentNo, RegUserNo, RegDate, ModUserNo, ModDate, Content
	FROM NoticeSyn_Comments
	WHERE NoticeNo = noticesyn_mobile_getcontentnotice.noticeno
	ORDER BY CommentNo DESC

END;
--------------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
