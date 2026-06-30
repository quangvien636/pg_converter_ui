-- ─── PROCEDURE→FUNCTION: eappdocument_update ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.eappdocument_update(integer, character varying, character varying, text, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying, character varying, integer, character varying, integer, timestamp without time zone, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, integer, integer, character varying, character varying, integer, integer, integer, integer, character varying, character varying, integer, character varying, character varying, integer, text, character varying, character varying, text, character varying, character varying, integer, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappdocument_update(
    IN id integer,
    IN agreemanagerid character varying,
    IN title character varying DEFAULT NULL,
    IN content text DEFAULT NULL,
    IN writerid character varying DEFAULT NULL,
    IN positionid character varying DEFAULT NULL,
    IN departid character varying DEFAULT NULL,
    IN gradeid character varying DEFAULT NULL,
    IN worder integer DEFAULT NULL,
    IN wlevel integer DEFAULT NULL,
    IN wgroup integer DEFAULT NULL,
    IN isnotice character varying DEFAULT NULL,
    IN lcategory character varying DEFAULT NULL,
    IN scategory character varying DEFAULT NULL,
    IN authoritylevel integer DEFAULT NULL,
    IN issecret character varying DEFAULT NULL,
    IN hit integer DEFAULT NULL,
    IN regdate timestamp without time zone DEFAULT NULL,
    IN modifier character varying DEFAULT NULL,
    IN moddate timestamp without time zone DEFAULT NULL,
    IN valdate timestamp without time zone DEFAULT NULL,
    IN isdelete character varying DEFAULT NULL,
    IN description character varying DEFAULT NULL,
    IN pathid integer DEFAULT NULL,
    IN progid integer DEFAULT NULL,
    IN state integer DEFAULT NULL,
    IN formid integer DEFAULT NULL,
    IN serial character varying DEFAULT NULL,
    IN operationdate character varying DEFAULT NULL,
    IN storeperiod integer DEFAULT NULL,
    IN contentid integer DEFAULT NULL,
    IN totalstoredboxid integer DEFAULT NULL,
    IN historyid integer DEFAULT NULL,
    IN erpkey character varying DEFAULT NULL,
    IN docsign character varying DEFAULT NULL,
    IN agreeorder integer DEFAULT NULL,
    IN duty character varying DEFAULT NULL,
    IN drafter character varying DEFAULT NULL,
    IN rootid integer DEFAULT NULL,
    IN summary text DEFAULT NULL,
    IN contenttext character varying DEFAULT NULL,
    IN opiniontext character varying DEFAULT NULL,
    IN filenametext text DEFAULT NULL,
    IN groupcode character varying DEFAULT NULL,
    IN isdraftdel character varying DEFAULT NULL,
    IN operationtype integer DEFAULT NULL,
    IN edmsid integer DEFAULT NULL,
    IN edmsstate integer DEFAULT NULL,
    IN isclose character varying DEFAULT NULL,
    IN agreedocid integer DEFAULT NULL,
    IN deptname1 character varying DEFAULT NULL,
    IN deptname2 character varying DEFAULT NULL,
    IN deptname3 character varying DEFAULT NULL,
    IN deptname4 character varying DEFAULT NULL,
    IN isautoafter character varying DEFAULT NULL
) RETURNS void
AS $function$
BEGIN

UPDATE public."EAPPDocument" SET
	  Title = COALESCE(Title, Title)
	, Content = COALESCE(Content, Content)
	, WriterID = COALESCE(WriterID, WriterID)
	, PositionID = COALESCE(PositionID, PositionID)
	, DepartID = COALESCE(DepartID, DepartID)
	, GradeID = COALESCE(GradeID, GradeID)
	, WOrder = COALESCE(WOrder, WOrder)
	, WLevel = COALESCE(WLevel, WLevel)
	, WGroup = COALESCE(WGroup, WGroup)
	, IsNotice = COALESCE(IsNotice, IsNotice)
	, LCategory = COALESCE(LCategory, LCategory)
	, SCategory = COALESCE(SCategory, SCategory)
	, AuthorityLevel = COALESCE(AuthorityLevel, AuthorityLevel)
	, IsSecret = COALESCE(IsSecret, IsSecret)
	, Hit = COALESCE(Hit, Hit)
	, RegDate = COALESCE(RegDate, RegDate)
	, Modifier = COALESCE(Modifier, Modifier)
	, ModDate = COALESCE(ModDate, ModDate)
	, ValDate = COALESCE(ValDate, ValDate)
	, IsDelete = COALESCE(IsDelete, IsDelete)
	, Description = COALESCE(Description, Description)
	, PathID = COALESCE(PathID, PathID)
	, ProgID = COALESCE(ProgID, ProgID)
	, State = COALESCE(State, State)
	, FormID = COALESCE(FormID, FormID)
	, Serial = COALESCE(Serial, Serial)
	, OperationDate = COALESCE(OperationDate, OperationDate)
	, StorePeriod = COALESCE(StorePeriod, StorePeriod)
	, ContentID = COALESCE(ContentID, ContentID) 
	, TotalStoredBoxID = COALESCE(TotalStoredBoxID, TotalStoredBoxID)
	, HistoryID = COALESCE(HistoryID, HistoryID)
	, ErpKey = COALESCE(ErpKey, ErpKey)
	, DocSign = COALESCE(DocSign, DocSign)
	, AgreeOrder = COALESCE(AgreeOrder, AgreeOrder)
	, Duty = COALESCE(Duty, Duty)
	, Drafter = COALESCE(Drafter, Drafter)
	, RootID = COALESCE(RootID, RootID)
	, Summary = COALESCE(Summary, Summary)
	, ContentText = COALESCE(ContentText, ContentText)
	, OpinionText = COALESCE(OpinionText, OpinionText)
	, FileNameText = COALESCE(FileNameText, FileNameText)
	, GroupCode = COALESCE(GroupCode, GroupCode)
	, IsDraftDel = COALESCE(IsDraftDel, IsDraftDel)
	, OperationType = COALESCE(OperationType, OperationType)
	, EDMSID = COALESCE(EDMSID, EDMSID)
	, EDMSState = COALESCE(EDMSState, EDMSState)
	, IsClose = COALESCE(IsClose, IsClose)
	,AgreeDocId= COALESCE(AgreeDocId, AgreeDocId)
	,AgreeManagerID = COALESCE(AgreeManagerID, AgreeManagerID)
	,DeptName1 = COALESCE(DeptName1, DeptName1)
	,DeptName2 = COALESCE(DeptName2, DeptName2)
	,DeptName3 = COALESCE(DeptName3, DeptName3)
	,DeptName4 = COALESCE(DeptName4, DeptName4)
	,IsAutoAfter= COALESCE(IsAutoAfter, IsAutoAfter)
	
WHERE ID = eappdocument_update.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
