-- ─── PROCEDURE→FUNCTION: board_insertreply ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertreply(bigint, bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, bigint, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.board_insertreply(
    IN parentno bigint,
    IN contentno bigint DEFAULT 4742,
    IN moduserno integer DEFAULT 222,
    IN modusername character varying DEFAULT 'test1',
    IN modpositionno integer DEFAULT 15,
    IN modpositionname character varying DEFAULT 'Staff',
    IN moddepartno integer DEFAULT 33,
    IN moddepartname character varying DEFAULT 'DisDepartment',
    IN regdate timestamp without time zone DEFAULT '2018-12-06',
    IN groupno bigint DEFAULT 2,
    IN depth integer DEFAULT 1,
    IN orderno integer DEFAULT 7,
    IN content character varying DEFAULT 'lv2'
) RETURNS SETOF record
AS $function$
DECLARE
    replyno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF GroupNo = 0 THEN
	
		GroupNo := (SELECT MAX(GroupNo) + 1 FROM Board_Replies WHERE ContentNo = board_insertreply.contentno);
		IF GroupNo IS NULL THEN
		
			GroupNo := 1;
		END IF;
	
	END IF;

	UPDATE Board_Replies SET OrderNo = board_insertreply.orderno + 1
	WHERE ContentNo = board_insertreply.contentno AND OrderNo >= board_insertreply.orderno

	INSERT INTO Board_Replies (ContentNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName,
		ModDepartNo, ModDepartName, RegDate, ModDate, GroupNo, Depth, OrderNo, Content,ParentNo)
	VALUES (ContentNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName,
		ModDepartNo, ModDepartName, RegDate, RegDate, GroupNo, Depth, OrderNo, Content,ParentNo)
		

	ReplyNo := lastval();
	RETURN QUERY
	SELECT ReplyNo
	
	UPDATE Board_Contents SET ReplyCount = ReplyCount + 1 WHERE ContentNo = board_insertreply.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
