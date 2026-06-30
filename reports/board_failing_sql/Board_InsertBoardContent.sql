-- ─── PROCEDURE→FUNCTION: board_insertboardcontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertboardcontent(integer, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, character varying, integer, bigint, integer, integer, integer, boolean, character varying, boolean, integer, timestamp without time zone, timestamp without time zone, boolean, character varying, character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, boolean, character varying, character varying, character varying, character varying, character varying, character varying, integer, boolean, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.board_insertboardcontent(
    IN boardno integer,
    IN moduserno integer,
    IN modusername character varying,
    IN modpositionno integer,
    IN modpositionname character varying,
    IN moddepartno integer,
    IN moddepartname character varying,
    IN regdate timestamp without time zone,
    IN title character varying,
    IN titleeffect integer,
    IN groupno bigint,
    IN depth integer,
    IN orderno integer,
    IN headno integer,
    IN isnotice boolean,
    IN content character varying,
    IN isfile boolean,
    IN filecount integer,
    IN startdate timestamp without time zone,
    IN enddate timestamp without time zone,
    IN isshareall boolean,
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
    IN viewmode integer DEFAULT 2,
    IN isalarm boolean DEFAULT FALSE,
    IN rootid integer DEFAULT 0,
    IN visitdate timestamp without time zone DEFAULT NULL,
    IN visitcompletedate timestamp without time zone DEFAULT NULL,
    IN businessdate timestamp without time zone DEFAULT NULL,
    IN dateview timestamp without time zone DEFAULT NULL
) RETURNS SETOF record
AS $function$
DECLARE
    contentno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF GroupNo = 0 THEN
	
		GroupNo := (SELECT MAX(GroupNo) + 1 FROM Board_Contents WHERE BoardNo = board_insertboardcontent.boardno);
		IF GroupNo IS NULL THEN
		
			GroupNo := 1;
		END;
	
	END;
	
	UPDATE Board_Contents SET OrderNo = board_insertboardcontent.orderno + 1
	WHERE BoardNo = board_insertboardcontent.boardno AND OrderNo >= board_insertboardcontent.orderno;
	
	INSERT INTO Board_Contents (BoardNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, ModDate, Title, TitleEffect, GroupNo, Depth, OrderNo, HeadNo, IsNotice, Content, IsFile, FileCount,
		ReplyCount, RecommendedCount, ViewedCount, StartDate, EndDate, Enabled,RegUserNo,  RegPositionNo,  RegDepartNo,ViewMode,IsAlarm,IsShareAll,Type,ErrorType,PersonType,DesignNo,ConstructionName,VisitDate,VisitCompleteDate,BusinessDate,DateView,ApplyTo,Important,MailRecipientNo,MailRecipientName,Private,Purpose,Note,Other,Inspector,Generation,BadNo,Standard)
	VALUES (BoardNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, RegDate, Title, TitleEffect, GroupNo, Depth, OrderNo, HeadNo, IsNotice, Content, IsFile, FileCount,
		0, 0, 0, StartDate, EndDate, 1,ModUserNo, ModPositionNo, ModDepartNo,ViewMode,IsAlarm,IsShareAll,Type,ErrorType,PersonType,DesignNo,ConstructionName,VisitDate,VisitCompleteDate,BusinessDate,DateView,ApplyTo,Important,MailRecipientNo,MailRecipientName,Private,Purpose,Note,Other,Inspector,Generation,BadNo,Standard);

		

	ContentNo := lastval();
	IF RootId=0 THEN
	    UPDATE Board_Contents SET RootId=ContentNo WHERE ContentNo=ContentNo;
	ELSE
	    UPDATE Board_Contents SET RootId=board_insertboardcontent.rootid WHERE ContentNo=ContentNo;
	END IF;
	RETURN QUERY
	SELECT ContentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.