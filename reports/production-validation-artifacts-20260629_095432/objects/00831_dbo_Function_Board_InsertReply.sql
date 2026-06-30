-- ─── FUNCTION: board_insertreply ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertreply(bigint, bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, bigint, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.board_insertreply(
    parentno bigint,
    contentno bigint DEFAULT 4742,
    moduserno integer DEFAULT 222,
    modusername character varying DEFAULT 'test1',
    modpositionno integer DEFAULT 15,
    modpositionname character varying DEFAULT 'Staff',
    moddepartno integer DEFAULT 33,
    moddepartname character varying DEFAULT 'DisDepartment',
    regdate timestamp without time zone DEFAULT '2018-12-06',
    groupno bigint DEFAULT 2,
    depth integer DEFAULT 1,
    orderno integer DEFAULT 7,
    content character varying DEFAULT 'lv2'
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    replyno bigint;
BEGIN


	IF (GroupNo = 0) BEGIN
	
		SET GroupNo = (SELECT MAX(GroupNo) + 1 FROM Board_Replies WHERE ContentNo = board_insertreply.contentno)
		
		IF (GroupNo IS NULL) BEGIN
		
			SET GroupNo = 1
		
		END
	
	END

	UPDATE Board_Replies SET OrderNo = board_insertreply.orderno + 1
	WHERE ContentNo = board_insertreply.contentno AND OrderNo >= board_insertreply.orderno

	INSERT INTO Board_Replies (ContentNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName,
		ModDepartNo, ModDepartName, RegDate, ModDate, GroupNo, Depth, OrderNo, Content,ParentNo)
	VALUES (ContentNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName,
		ModDepartNo, ModDepartName, RegDate, RegDate, GroupNo, Depth, OrderNo, Content,ParentNo)
		

	SET ReplyNo = lastval()
	
	RETURN QUERY
	SELECT ReplyNo
	
	UPDATE Board_Contents SET ReplyCount = ReplyCount + 1 WHERE ContentNo = board_insertreply.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
