-- ─── FUNCTION: work_getcooperationcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getcooperationcomments(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getcooperationcomments(
    groupno integer,
    userno integer
) RETURNS TABLE(
    commentno text,
    cooperationno text,
    groupno text,
    reguserno text,
    name text,
    regdate text,
    moduserno text,
    moddate text,
    content text,
    readdate text
)
AS $function$
BEGIN


	RETURN QUERY
	select A.CommentNo,A.CooperationNo,A.GroupNo,A.RegUserNo,B.Name,A.RegDate,A.ModUserNo,
	A.ModDate,A.Content,C.ReadDate from Work_CooperationComments A
	join Organization_Users B
	on A.RegUserNo = B.UserNo
		left join Work_CooperationCommentReference C
	on A.CommentNo = C.CommentNo and C.UserNo = work_getcooperationcomments.userno
	where A.groupno = work_getcooperationcomments.groupno
	order by A.RegDate asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
