-- ─── PROCEDURE→FUNCTION: board_updatereply ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updatereply(bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, character varying, bigint);
CREATE OR REPLACE FUNCTION public.board_updatereply(
    IN replyno bigint,
    IN moduserno integer,
    IN modusername character varying,
    IN modpositionno integer,
    IN modpositionname character varying,
    IN moddepartno integer,
    IN moddepartname character varying,
    IN moddate timestamp without time zone,
    IN content character varying,
    IN parentno bigint
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
