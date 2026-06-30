-- ─── FUNCTION: note_getcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getcomments(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_getcomments(
    commentno uuid,
    pagesizereply integer
) RETURNS TABLE(
    col1 text,
    listno text,
    commentno text,
    regdate text,
    datecomment text,
    content text,
    userno text,
    userphoto text,
    photo text,
    name text,
    name_en text,
    positions text,
    positionsen text,
    readuserlist text
)
AS $function$
BEGIN

RETURN QUERY
SELECT * FROM (
		SELECT	ROW_NUMBER() OVER (ORDER BY RegDate desc) AS RowNumber, CTE.* FROM ( SELECT
			RN = ROW_NUMBER()OVER(PARTITION BY CommentNo ORDER BY RegDate desc),
				 public."Note_Comments".ListNo, public."Note_Comments".CommentNo, public."Note_Comments".RegDate, public."Note_Comments".ModDate AS DateComment, public."Note_Comments".Content, 
                         public."Note_Comments".RegUserNo AS UserNo, public."Organization_Users".UserPhoto, public."Organization_Users".Photo, public."Organization_Users".Name, public."Organization_Users".Name_EN, 
                         public."Organization_Positions".Name AS Positions, public."Organization_Positions".Name_EN AS PositionsEN, public."Note_Comments".ReadUserList

		FROM            public."Organization_BelongToDepartment" INNER JOIN
                         public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo RIGHT OUTER JOIN
                         public."Organization_Users" ON public."Organization_BelongToDepartment".UserNo = public."Organization_Users".UserNo RIGHT OUTER JOIN
                         public."Note_Comments" ON public."Organization_Users".UserNo = public."Note_Comments".RegUserNo

		WHERE public."Note_Comments".ParentID = note_getcomments.commentno ) AS CTE
		WHERE CTE.RN <= 1
		) as t
		where  t.RowNumber BETWEEN 1 and PageSizeReply
		ORDER BY RegDate desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
