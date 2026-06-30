-- ─── PROCEDURE→FUNCTION: eappdocument_insert_getdocid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.eappdocument_insert_getdocid(character varying, character varying, text, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying, character varying, integer, character varying, integer, timestamp without time zone, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, integer, integer, integer, character varying, character varying, integer, integer, integer, integer, character varying, character varying, integer, character varying, character varying, integer, text, character varying, character varying, text, character varying, character varying, integer, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappdocument_insert_getdocid(
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
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
INSERT INTO EAPPDocument (Title, Content, WriterID, PositionID, DepartID, GradeID, WOrder, WLevel, WGroup, IsNotice, LCategory, SCategory, AuthorityLevel, IsSecret, Hit, RegDate, Modifier, ModDate, ValDate, IsDelete, Description, PathID, ProgID, State, FormID, Serial, OperationDate, StorePeriod, ContentID, TotalStoredBoxID, HistoryID, ErpKey, DocSign, AgreeOrder, Duty, Drafter, RootID, Summary, ContentText, OpinionText, FileNameText, GroupCode, IsDraftDel, OperationType, EDMSID, EDMSState, IsClose, AgreeDocId, AgreeManagerID, DeptName1, DeptName2, DeptName3, DeptName4,IsAutoAfter) 
values (Title, Content, WriterID, PositionID, DepartID, GradeID, WOrder, WLevel, WGroup, IsNotice, LCategory, SCategory, AuthorityLevel, IsSecret, Hit, RegDate, Modifier, ModDate, ValDate, IsDelete, Description, PathID, ProgID, State, FormID, Serial, OperationDate, StorePeriod, ContentID, TotalStoredBoxID, HistoryID, ErpKey, DocSign, AgreeOrder, Duty, Drafter, RootID, Summary, ContentText, OpinionText, FileNameText, GroupCode, IsDraftDel, OperationType, EDMSID, EDMSState, IsClose, AgreeDocId, AgreeManagerID, DeptName1, DeptName2, DeptName3, DeptName4,IsAutoAfter)

RETURN QUERY
SELECT lastval() AS ID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
