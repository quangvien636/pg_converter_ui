-- ─── FUNCTION: board_insertboardcontent ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertboardcontent(integer, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, character varying, integer, bigint, integer, integer, integer, boolean, character varying, boolean, integer, timestamp without time zone, timestamp without time zone, boolean, character varying, character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.board_insertboardcontent(
    boardno integer,
    moduserno integer,
    modusername character varying,
    modpositionno integer,
    modpositionname character varying,
    moddepartno integer,
    moddepartname character varying,
    regdate timestamp without time zone,
    title character varying,
    titleeffect integer,
    groupno bigint,
    depth integer,
    orderno integer,
    headno integer,
    isnotice boolean,
    content character varying,
    isfile boolean,
    filecount integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    isshareall boolean,
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
    viewmode integer DEFAULT 2,
    isalarm boolean DEFAULT FALSE,
    rootid integer DEFAULT 0,
    visitdate timestamp without time zone DEFAULT NULL,
    visitcompletedate timestamp without time zone DEFAULT NULL,
    businessdate timestamp without time zone DEFAULT NULL,
    dateview timestamp without time zone DEFAULT NULL
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    contentno bigint;
BEGIN


	IF (GroupNo = 0) BEGIN
	
		SET GroupNo = (SELECT MAX(GroupNo) + 1 FROM Board_Contents WHERE BoardNo = board_insertboardcontent.boardno)
		
		IF (GroupNo IS NULL) BEGIN
		
			SET GroupNo = 1
		
		END
	
	END
	
	UPDATE Board_Contents SET OrderNo = board_insertboardcontent.orderno + 1
	WHERE BoardNo = board_insertboardcontent.boardno AND OrderNo >= board_insertboardcontent.orderno
	
	INSERT INTO Board_Contents (BoardNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, ModDate, Title, TitleEffect, GroupNo, Depth, OrderNo, HeadNo, IsNotice, Content, IsFile, FileCount,
		ReplyCount, RecommendedCount, ViewedCount, StartDate, EndDate, Enabled,RegUserNo,  RegPositionNo,  RegDepartNo,ViewMode,IsAlarm,IsShareAll,Type,ErrorType,PersonType,DesignNo,ConstructionName,VisitDate,VisitCompleteDate,BusinessDate,DateView,ApplyTo,Important,MailRecipientNo,MailRecipientName,Private,Purpose,Note,Other,Inspector,Generation,BadNo,Standard)
	VALUES (BoardNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, RegDate, Title, TitleEffect, GroupNo, Depth, OrderNo, HeadNo, IsNotice, Content, IsFile, FileCount,
		0, 0, 0, StartDate, EndDate, 1,ModUserNo, ModPositionNo, ModDepartNo,ViewMode,IsAlarm,IsShareAll,Type,ErrorType,PersonType,DesignNo,ConstructionName,VisitDate,VisitCompleteDate,BusinessDate,DateView,ApplyTo,Important,MailRecipientNo,MailRecipientName,Private,Purpose,Note,Other,Inspector,Generation,BadNo,Standard)

		

	SET ContentNo = lastval()
	
	IF(RootId=0)	UPDATE Board_Contents SET RootId=ContentNo WHERE ContentNo=ContentNo	
	ELSE UPDATE Board_Contents SET RootId=board_insertboardcontent.rootid WHERE ContentNo=ContentNo
	RETURN QUERY
	SELECT ContentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
