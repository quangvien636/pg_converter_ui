-- ─── PROCEDURE→FUNCTION: board_updateboardcontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_updateboardcontent(integer, bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, character varying, integer, integer, boolean, character varying, boolean, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent(
    IN boardno integer,
    IN contentno bigint,
    IN moduserno integer,
    IN modusername character varying,
    IN modpositionno integer,
    IN modpositionname character varying,
    IN moddepartno integer,
    IN moddepartname character varying,
    IN moddate timestamp without time zone,
    IN title character varying,
    IN titleeffect integer,
    IN headno integer,
    IN isnotice boolean,
    IN content character varying,
    IN isfile boolean,
    IN filecount integer,
    IN startdate timestamp without time zone,
    IN enddate timestamp without time zone,
    IN type character varying,
    IN errortype character varying,
    IN persontype character varying,
    IN designno character varying,
    IN constructionname character varying,
    IN applyto character varying,
    IN important boolean,
    IN mailrecipientno character varying,
    IN mailrecipientname character varying,
    IN private boolean,
    IN purpose character varying,
    IN note character varying,
    IN other character varying,
    IN inspector character varying,
    IN generation character varying,
    IN badno character varying,
    IN isalarm boolean DEFAULT FALSE,
    IN isshareall boolean DEFAULT FALSE,
    IN visitdate timestamp without time zone DEFAULT NULL,
    IN visitcompletedate timestamp without time zone DEFAULT NULL,
    IN businessdate timestamp without time zone DEFAULT NULL,
    IN dateview timestamp without time zone DEFAULT NULL
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	UPDATE Board_Contents SET
		BoardNo = board_updateboardcontent.boardno,
		ModUserNo = board_updateboardcontent.moduserno,
		--ModUserName = ModUserName,
		ModPositionNo = board_updateboardcontent.modpositionno,
		--ModPositionName = ModPositionName,
		ModDepartNo = board_updateboardcontent.moddepartno,
		--ModDepartName = ModDepartName,
		ModDate = board_updateboardcontent.moddate,
		Title = board_updateboardcontent.title,
		TitleEffect = board_updateboardcontent.titleeffect,
		HeadNo = board_updateboardcontent.headno,
		IsNotice = board_updateboardcontent.isnotice,
		Content = board_updateboardcontent.content,
		IsFile = board_updateboardcontent.isfile,
		FileCount = board_updateboardcontent.filecount,
		StartDate = board_updateboardcontent.startdate,
		EndDate = board_updateboardcontent.enddate,
		IsAlarm=board_updateboardcontent.isalarm,
		IsShareAll=board_updateboardcontent.isshareall,
		Type = board_updateboardcontent.type,
		ErrorType = board_updateboardcontent.errortype,
		PersonType = board_updateboardcontent.persontype,
		DesignNo = board_updateboardcontent.designno,
		ConstructionName = board_updateboardcontent.constructionname,
		VisitDate=board_updateboardcontent.visitdate,
		VisitCompleteDate=board_updateboardcontent.visitcompletedate,
		BusinessDate=board_updateboardcontent.visitcompletedate,
		DateView=board_updateboardcontent.dateview,
		ApplyTo=board_updateboardcontent.applyto,
		Important=board_updateboardcontent.important,
		MailRecipientNo=board_updateboardcontent.mailrecipientno,
		MailRecipientName=board_updateboardcontent.mailrecipientname,
		Private=board_updateboardcontent.private,
		Purpose=board_updateboardcontent.purpose,
		Note=board_updateboardcontent.note,
		Other=board_updateboardcontent.other,
		Inspector=board_updateboardcontent.inspector,
		Generation=board_updateboardcontent.generation,
		BadNo=board_updateboardcontent.badno,
		Standard=Standard
	WHERE ContentNo = board_updateboardcontent.contentno;

	--SELECT IsAlarm
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
