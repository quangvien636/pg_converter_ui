-- ─── FUNCTION: eappdocument_insert_getdocid ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappdocument_insert_getdocid(character varying, character varying, text, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying, character varying, integer, character varying, integer, timestamp without time zone, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, integer, integer, character varying, character varying, integer, integer, integer, integer, character varying, character varying, integer, character varying, character varying, integer, text, character varying, character varying, text, character varying, character varying, integer, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappdocument_insert_getdocid(
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
) RETURNS TABLE(
    id text
)
AS $function$
BEGIN
INSERT INTO EAPPDocument (Title, Content, WriterID, PositionID, DepartID, GradeID, WOrder, WLevel, WGroup, IsNotice, LCategory, SCategory, AuthorityLevel, IsSecret, Hit, RegDate, Modifier, ModDate, ValDate, IsDelete, Description, PathID, ProgID, State, FormID, Serial, OperationDate, StorePeriod, ContentID, TotalStoredBoxID, HistoryID, ErpKey, DocSign, AgreeOrder, Duty, Drafter, RootID, Summary, ContentText, OpinionText, FileNameText, GroupCode, IsDraftDel, OperationType, EDMSID, EDMSState, IsClose, AgreeDocId, AgreeManagerID, DeptName1, DeptName2, DeptName3, DeptName4,IsAutoAfter) 
values (Title, Content, WriterID, PositionID, DepartID, GradeID, WOrder, WLevel, WGroup, IsNotice, LCategory, SCategory, AuthorityLevel, IsSecret, Hit, RegDate, Modifier, ModDate, ValDate, IsDelete, Description, PathID, ProgID, State, FormID, Serial, OperationDate, StorePeriod, ContentID, TotalStoredBoxID, HistoryID, ErpKey, DocSign, AgreeOrder, Duty, Drafter, RootID, Summary, ContentText, OpinionText, FileNameText, GroupCode, IsDraftDel, OperationType, EDMSID, EDMSState, IsClose, AgreeDocId, AgreeManagerID, DeptName1, DeptName2, DeptName3, DeptName4,IsAutoAfter)

RETURN QUERY
SELECT lastval() AS ID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
