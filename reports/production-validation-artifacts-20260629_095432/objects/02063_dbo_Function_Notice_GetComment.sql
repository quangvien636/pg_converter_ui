-- ─── FUNCTION: notice_getcomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getcomment(integer);
CREATE OR REPLACE FUNCTION public.notice_getcomment(
    noticeno integer
) RETURNS TABLE(
    commentno text,
    reguserno text,
    name text,
    regdate text,
    moduserno text,
    moddate text,
    content text,
    photo text,
    username text,
    positionno text,
    positionname text,
    departno text,
    departname text,
    groupno text,
    depth text,
    orderno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CommentNo,C.RegUserNo,Name,C.RegDate,C.ModUserNo,
	C.ModDate,C.Content,U.Photo,COALESCE(C.ModUserName,'') as UserName, COALESCE(C.ModPositionNo,0) as PositionNo,
	COALESCE(C.ModPositionName,'') as PositionName,COALESCE(C.ModDepartNo,0) as DepartNo,COALESCE(C.ModDepartName,'') as DepartName,COALESCE(C.GroupNo,0) as GroupNo,
	COALESCE(C.Depth,0) as Depth,COALESCE(C.OrderNo,0) as OrderNo
	FROM NoticeComments C
	INNER JOIN Organization_Users U ON C.RegUserNo = U.UserNo
	WHERE NoticeNo = notice_getcomment.noticeno
	ORDER BY C.GroupNo DESC, C.OrderNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
