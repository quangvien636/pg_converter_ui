-- ─── PROCEDURE→FUNCTION: board_getreplybycontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getreplybycontent(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_getreplybycontent(
    IN contentno bigint DEFAULT 5721,
    IN langcode character varying DEFAULT 'EN',
    IN userno integer DEFAULT 70
) RETURNS TABLE(replyno bigint, moduserno integer, modusername varchar, modpositionno integer, modpositionname varchar, moddepartno integer, moddepartname varchar, regdate timestamp without time zone, moddate timestamp without time zone, groupno integer, depth integer, orderno integer, content text, userphoto varchar, photo varchar, isdelete boolean)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

WITH TMP AS
(
  SELECT *--,0 AS Level
  ,CAST(ReplyNo AS text) AS Root
  FROM Board_Replies
  WHERE ContentNo = board_getreplybycontent.contentno AND ParentNo = 0
  UNION ALL
  SELECT BR.*--,(T.Level + 1) AS Level
  , (T.Root || '-' || CAST(BR.ReplyNo AS text)) AS Root
  FROM Board_Replies BR
  INNER JOIN TMP T ON T.ReplyNo = BR.ParentNo AND BR.ContentNo = board_getreplybycontent.contentno
)--, 
--EndRoot AS (
--	SELECT P.ReplyNo 
--	FROM TMP P
--	LEFT JOIN TMP  C ON P.ReplyNo=C.ParentNo
--	GROUP BY P.ReplyNo
--	HAVING COUNT(C.ParentNo) = 0
--)
	RETURN QUERY
	SELECT BR.ReplyNo,
		BR.ModUserNo,
		BR.ModUserName,
		BR.ModPositionNo,
		COALESCE(CASE LangCode WHEN 'EN' THEN COALESCE(OP.Name_EN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name) WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name)WHEN 'VN' THEN COALESCE(OP.Name_VN,OP.Name) ELSE OD.Name END,'') AS ModPositionName,
		--BR.ModPositionName,
		BR.ModDepartNo,
		COALESCE(CASE LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name)WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) ELSE OD.Name END,'') AS ModDepartName,
		BR.RegDate,
		BR.ModDate,
		BR.GroupNo,
		BR.Depth,
		BR.OrderNo,
		BR.Content,
		OU.UserPhoto, 
		OU.Photo,--BR.Level  ,BR.Root,
		(BR.ModUserNo = board_getreplybycontent.userno
            AND NOT EXISTS (
                    SELECT 1
                    FROM Board_Replies C
                    WHERE C.ParentNo = BR.ReplyNo AND C.ContentNo = board_getreplybycontent.contentno
            )) AS IsDelete
		--CAST((CASE WHEN ER.ReplyNo IS NOT NULL AND BR.ModUserNo=UserNo THEN 1 ELSE 0 END) AS BIT) AS IsDelete 
	FROM TMP BR 
	LEFT OUTER JOIN Organization_Users OU ON OU.UserNo = BR.ModUserNo
	LEFT OUTER JOIN Organization_Departments OD ON OD.DepartNo=BR.ModDepartNo AND OD.Enabled = TRUE
	LEFT OUTER JOIN Organization_Positions OP ON OP.PositionNo=BR.ModPositionNo AND OP.Enabled = TRUE
	--LEFT OUTER JOIN EndRoot ER ON ER.ReplyNo=BR.ReplyNo 
	WHERE ContentNo = board_getreplybycontent.contentno
	ORDER BY BR.GroupNo DESC, BR.Root ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.