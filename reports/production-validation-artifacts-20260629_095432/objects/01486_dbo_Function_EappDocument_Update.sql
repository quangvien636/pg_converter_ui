-- ─── FUNCTION: eappdocument_update ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappdocument_update(integer, character varying, character varying, text, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying, character varying, integer, character varying, integer, timestamp without time zone, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, integer, integer, character varying, character varying, integer, integer, integer, integer, character varying, character varying, integer, character varying, character varying, integer, text, character varying, character varying, text, character varying, character varying, integer, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappdocument_update(
    id integer,
    agreemanagerid character varying,
    title character varying DEFAULT NULL,
    content text DEFAULT NULL,
    writerid character varying DEFAULT NULL,
    positionid character varying DEFAULT NULL,
    departid character varying DEFAULT NULL,
    gradeid character varying DEFAULT NULL,
    worder integer DEFAULT NULL,
    wlevel integer DEFAULT NULL,
    wgroup integer DEFAULT NULL,
    isnotice character varying DEFAULT NULL,
    lcategory character varying DEFAULT NULL,
    scategory character varying DEFAULT NULL,
    authoritylevel integer DEFAULT NULL,
    issecret character varying DEFAULT NULL,
    hit integer DEFAULT NULL,
    regdate timestamp without time zone DEFAULT NULL,
    modifier character varying DEFAULT NULL,
    moddate timestamp without time zone DEFAULT NULL,
    valdate timestamp without time zone DEFAULT NULL,
    isdelete character varying DEFAULT NULL,
    description character varying DEFAULT NULL,
    pathid integer DEFAULT NULL,
    progid integer DEFAULT NULL,
    state integer DEFAULT NULL,
    formid integer DEFAULT NULL,
    serial character varying DEFAULT NULL,
    operationdate character varying DEFAULT NULL,
    storeperiod integer DEFAULT NULL,
    contentid integer DEFAULT NULL,
    totalstoredboxid integer DEFAULT NULL,
    historyid integer DEFAULT NULL,
    erpkey character varying DEFAULT NULL,
    docsign character varying DEFAULT NULL,
    agreeorder integer DEFAULT NULL,
    duty character varying DEFAULT NULL,
    drafter character varying DEFAULT NULL,
    rootid integer DEFAULT NULL,
    summary text DEFAULT NULL,
    contenttext character varying DEFAULT NULL,
    opiniontext character varying DEFAULT NULL,
    filenametext text DEFAULT NULL,
    groupcode character varying DEFAULT NULL,
    isdraftdel character varying DEFAULT NULL,
    operationtype integer DEFAULT NULL,
    edmsid integer DEFAULT NULL,
    edmsstate integer DEFAULT NULL,
    isclose character varying DEFAULT NULL,
    agreedocid integer DEFAULT NULL,
    deptname1 character varying DEFAULT NULL,
    deptname2 character varying DEFAULT NULL,
    deptname3 character varying DEFAULT NULL,
    deptname4 character varying DEFAULT NULL,
    isautoafter character varying DEFAULT NULL
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
