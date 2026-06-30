-- ─── FUNCTION: board_updateboardcontent ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateboardcontent(integer, bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, character varying, integer, integer, boolean, character varying, boolean, integer, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, boolean, boolean, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent(
    boardno integer,
    contentno bigint,
    moduserno integer,
    modusername character varying,
    modpositionno integer,
    modpositionname character varying,
    moddepartno integer,
    moddepartname character varying,
    moddate timestamp without time zone,
    title character varying,
    titleeffect integer,
    headno integer,
    isnotice boolean,
    content character varying,
    isfile boolean,
    filecount integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    type character varying,
    errortype character varying,
    persontype character varying,
    designno character varying,
    constructionname character varying,
    applyto character varying,
    important boolean,
    mailrecipientno character varying,
    mailrecipientname character varying,
    private boolean,
    purpose character varying,
    note character varying,
    other character varying,
    inspector character varying,
    generation character varying,
    badno character varying,
    isalarm boolean DEFAULT FALSE,
    isshareall boolean DEFAULT FALSE,
    visitdate timestamp without time zone DEFAULT NULL,
    visitcompletedate timestamp without time zone DEFAULT NULL,
    businessdate timestamp without time zone DEFAULT NULL,
    dateview timestamp without time zone DEFAULT NULL
) RETURNS TABLE(
    isalarm text
)
AS $function$
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
