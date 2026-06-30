-- ─── PROCEDURE→FUNCTION: note_getcomments_reply ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getcomments_reply(uuid, uuid, integer);
CREATE OR REPLACE FUNCTION public.note_getcomments_reply(
    IN parentid uuid,
    IN commentno uuid,
    IN pagesize integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF CAST(CommentNo as varchar(64)) = '00000000-0000-0000-0000-000000000000' THEN
		RETURN QUERY
		SELECT * FROM (
		SELECT	ROW_NUMBER() OVER (ORDER BY RegDate desc) AS RowNumber, CTE.* FROM ( SELECT
			RN = ROW_NUMBER()OVER(PARTITION BY CommentNo ORDER BY RegDate desc)
			,public."Note_Comments".ListNo
			,public."Note_Comments".CommentNo
			,public."Note_Comments".RegDate
			,public."Note_Comments".ModDate AS DateComment
			,public."Note_Comments".Content
			,public."Note_Comments".RegUserNo AS UserNo
			,public."Note_Comments".ReadUserList
			,public."Note_Comments".ParentID
			,public."Organization_Users".UserPhoto
			,public."Organization_Users".Photo
			,public."Organization_Users".Name
			,public."Organization_Users".Name_EN
			,public."Organization_Positions".Name AS Positions
			,public."Organization_Positions".Name_EN AS PositionsEN
			
	FROM	public."Organization_BelongToDepartment" INNER JOIN
            public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo RIGHT OUTER JOIN
            public."Organization_Users" ON public."Organization_BelongToDepartment".UserNo = public."Organization_Users".UserNo RIGHT OUTER JOIN
            public."Note_Comments" ON public."Organization_Users".UserNo = public."Note_Comments".RegUserNo

		WHERE public."Note_Comments".ParentID = note_getcomments_reply.parentid) AS CTE
		WHERE CTE.RN <= 1
		) as t
		where  t.RowNumber BETWEEN RowStart and PageSize
		ORDER BY RegDate desc
	END IF;
	ELSE
		SELECT RowNumber INTO rowstart from	(SELECT	ROW_NUMBER() OVER (ORDER BY RegDate desc) AS RowNumber, CommentNo
		FROM public."Note_Comments" 
		WHERE ParentID = note_getcomments_reply.parentid
		) as t
		where t.CommentNo = note_getcomments_reply.commentno

		RETURN QUERY
		SELECT * FROM (
		SELECT	ROW_NUMBER() OVER (ORDER BY RegDate desc) AS RowNumber, CTE.* FROM ( SELECT
			RN = ROW_NUMBER()OVER(PARTITION BY CommentNo ORDER BY RegDate desc)
			,public."Note_Comments".ListNo
			,public."Note_Comments".CommentNo
			,public."Note_Comments".RegDate
			,public."Note_Comments".ModDate AS DateComment
			,public."Note_Comments".Content
			,public."Note_Comments".RegUserNo AS UserNo
			,public."Note_Comments".ReadUserList
			,public."Note_Comments".ParentID
			,public."Organization_Users".UserPhoto
			,public."Organization_Users".Photo
			,public."Organization_Users".Name
			,public."Organization_Users".Name_EN
			,public."Organization_Positions".Name AS Positions
			,public."Organization_Positions".Name_EN AS PositionsEN
			
	FROM	public."Organization_BelongToDepartment" INNER JOIN
            public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo RIGHT OUTER JOIN
            public."Organization_Users" ON public."Organization_BelongToDepartment".UserNo = public."Organization_Users".UserNo RIGHT OUTER JOIN
            public."Note_Comments" ON public."Organization_Users".UserNo = public."Note_Comments".RegUserNo

		WHERE public."Note_Comments".ParentID = note_getcomments_reply.parentid) AS CTE
		WHERE CTE.RN <= 1
		) as t
		where  t.RowNumber BETWEEN RowStart+1 and RowStart+PageSize

		ORDER BY RegDate desc
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
