-- ─── FUNCTION: board_updatereply ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updatereply(bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, character varying, bigint);
CREATE OR REPLACE FUNCTION public.board_updatereply(
    replyno bigint,
    moduserno integer,
    modusername character varying,
    modpositionno integer,
    modpositionname character varying,
    moddepartno integer,
    moddepartname character varying,
    moddate timestamp without time zone,
    content character varying,
    parentno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Replies SET
		ModUserNo = board_updatereply.moduserno,
		ModUserName = board_updatereply.modusername,
		ModPositionNo = board_updatereply.modpositionno,
		ModPositionName = board_updatereply.modpositionname,
		ModDepartNo = board_updatereply.moddepartno,
		ModDepartName = board_updatereply.moddepartname,
		ModDate = board_updatereply.moddate,
		Content = board_updatereply.content,
		ParentNo=board_updatereply.parentno
	WHERE ReplyNo = board_updatereply.replyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
