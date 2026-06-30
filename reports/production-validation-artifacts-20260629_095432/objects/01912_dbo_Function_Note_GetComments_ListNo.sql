-- ─── FUNCTION: note_getcomments_listno ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getcomments_listno(uuid, uuid, integer);
CREATE OR REPLACE FUNCTION public.note_getcomments_listno(
    listno uuid,
    commentno uuid,
    pagesize integer
) RETURNS TABLE(
    commentno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF CAST(CommentNo as varchar(64)) = '00000000-0000-0000-0000-000000000000'
	BEGIN
		RETURN QUERY
		SELECT * FROM (
		SELECT	ROW_NUMBER() OVER (ORDER BY RegDate desc) AS RowNumber,
				CTE.* FROM ( SELECT
				RN = ROW_NUMBER()OVER(PARTITION BY CommentNo ORDER BY RegDate desc),
				public."Note_Comments".ListNo, public."Note_Comments".CommentNo, 
				public."Note_Comments".RegDate, public."Note_Comments".ModDate AS DateComment, 
				public."Note_Comments".Content, 
                public."Note_Comments".RegUserNo AS UserNo, 
				public."Organization_Users".UserPhoto, 
				public."Organization_Users".Photo, 
				public."Organization_Users".Name, 
				public."Organization_Users".Name_EN, 
                public."Organization_Positions".Name AS Positions, 
				public."Organization_Positions".Name_EN AS PositionsEN, 
				public."Note_Comments".ReadUserList
				,(SELECT COUNT(R.CommentNo) FROM Note_Comments R WHERE R.ParentID = public."Note_Comments".CommentNo) AS TotalReply
				,(SELECT /* TOP 1 */ RN.CommentNo FROM Note_Comments RN WHERE RN.ParentID = public."Note_Comments".CommentNo ORDER BY RN.RegDate DESC) AS UserReply

		FROM            public."Organization_BelongToDepartment" INNER JOIN
                         public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo RIGHT OUTER JOIN
                         public."Organization_Users" ON public."Organization_BelongToDepartment".UserNo = public."Organization_Users".UserNo RIGHT OUTER JOIN
                         public."Note_Comments" ON public."Organization_Users".UserNo = public."Note_Comments".RegUserNo

		WHERE public."Note_Comments".ListNo = note_getcomments_listno.listno AND  public."Note_Comments".ParentID = '00000000-0000-0000-0000-000000000000') AS CTE
		WHERE CTE.RN <= 1
		) as t
		where  t.RowNumber BETWEEN RowStart and PageSize
		ORDER BY RegDate desc
	END
	ELSE
	BEGIN
		SELECT RowStart = RowNumber from	(SELECT	ROW_NUMBER() OVER (ORDER BY RegDate desc) AS RowNumber, CommentNo
		FROM public."Note_Comments" 
		WHERE ListNo = note_getcomments_listno.listno AND  public."Note_Comments".ParentID = '00000000-0000-0000-0000-000000000000'
		) as t
		where t.CommentNo = note_getcomments_listno.commentno

		RETURN QUERY
		SELECT * FROM (
		SELECT	ROW_NUMBER() OVER (ORDER BY RegDate desc) AS RowNumber,
				CTE.* FROM ( SELECT
				RN = ROW_NUMBER()OVER(PARTITION BY CommentNo ORDER BY RegDate desc),
				public."Note_Comments".ListNo, public."Note_Comments".CommentNo, 
				public."Note_Comments".RegDate, public."Note_Comments".ModDate AS DateComment, 
				public."Note_Comments".Content, 
                public."Note_Comments".RegUserNo AS UserNo, 
				public."Organization_Users".UserPhoto, 
				public."Organization_Users".Photo, 
				public."Organization_Users".Name, 
				public."Organization_Users".Name_EN, 
                public."Organization_Positions".Name AS Positions, 
				public."Organization_Positions".Name_EN AS PositionsEN, 
				public."Note_Comments".ReadUserList
				,(SELECT COUNT(R.CommentNo) FROM Note_Comments R WHERE R.ParentID = public."Note_Comments".CommentNo) AS TotalReply
				,(SELECT /* TOP 1 */ RN.CommentNo FROM Note_Comments RN WHERE RN.ParentID = public."Note_Comments".CommentNo ORDER BY RN.RegDate DESC) AS UserReply

		FROM            public."Organization_BelongToDepartment" INNER JOIN
                         public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo RIGHT OUTER JOIN
                         public."Organization_Users" ON public."Organization_BelongToDepartment".UserNo = public."Organization_Users".UserNo RIGHT OUTER JOIN
                         public."Note_Comments" ON public."Organization_Users".UserNo = public."Note_Comments".RegUserNo

		WHERE public."Note_Comments".ListNo = note_getcomments_listno.listno AND  public."Note_Comments".ParentID = '00000000-0000-0000-0000-000000000000') AS CTE
		WHERE CTE.RN <= 1
		) as t
		where  t.RowNumber BETWEEN RowStart+1 and RowStart+PageSize

		ORDER BY RegDate desc
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
