-- ─── PROCEDURE→FUNCTION: eappsetformerp ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.eappsetformerp(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.eappsetformerp(
    IN id character varying,
    IN name character varying,
    IN code character varying,
    IN standard character varying,
    IN storeperiod character varying,
    IN eacode character varying,
    IN formtype character varying,
    IN iserp character varying,
    IN erptype character varying,
    IN content text,
    IN description character varying,
    IN regid character varying,
    IN boardid character varying,
    IN categoryid character varying,
    IN departid character varying,
    IN pathid character varying,
    IN fixedpath character varying,
    IN erpfixedpath character varying,
    IN draftline character varying,
    IN agreeline character varying,
    IN assistline character varying,
    IN proposalline character varying,
    IN executeline character varying,
    IN auditline character varying,
    IN receiverline character varying,
    IN referenceline character varying,
    IN draftcount integer,
    IN agreecount integer,
    IN assistcount integer,
    IN proposalcount integer,
    IN executecount integer,
    IN auditcount integer,
    IN receivecount integer,
    IN referencecount integer,
    IN printtype character varying,
    IN topmargin character varying,
    IN bottommargin character varying,
    IN leftmargin character varying,
    IN rightmargin character varying,
    IN operationtype integer,
    IN requiremanager character varying,
    IN modapproval character varying,
    IN reapproval character varying,
    IN passageline character varying,
    IN passagecount integer,
    IN width integer,
    IN height integer,
    IN proagreeline character varying DEFAULT '0',
    IN exeagreeline character varying DEFAULT '0',
    IN yesanline character varying DEFAULT NULL,
    IN gamsaline character varying DEFAULT NULL,
    IN prefinalline character varying DEFAULT 0,
    IN finalline character varying DEFAULT 0,
    IN proagreecount integer DEFAULT 10,
    IN exeagreecount integer DEFAULT 10,
    IN yesancount integer DEFAULT NULL,
    IN gamsacount integer DEFAULT NULL,
    IN prefinalcount integer DEFAULT 10,
    IN finalcount integer DEFAULT 10,
    IN usetemp character varying DEFAULT '0',
    IN usemod character varying DEFAULT '0',
    IN usedel character varying DEFAULT '0',
    IN edmsautocheck character varying DEFAULT NULL,
    IN edmsfolderfix character varying DEFAULT NULL,
    IN edmsauth character varying DEFAULT NULL,
    IN edmsauthfix character varying DEFAULT NULL,
    IN edmsauthdefault character varying DEFAULT NULL,
    IN departlist character varying DEFAULT NULL,
    IN seriallang character varying DEFAULT NULL,
    IN formserial character varying DEFAULT NULL,
    IN ishotnews character varying DEFAULT '0',
    IN isshare character varying DEFAULT NULL,
    IN nodecision character varying DEFAULT NULL,
    IN popupurl character varying DEFAULT '',
    IN edmsauthoritylevel integer DEFAULT 0,
    IN linkform character varying DEFAULT '0'
) RETURNS SETOF record
AS $function$
DECLARE
    seq integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	IF SerialLang = '' THEN

		SerialLang := NULL;
	END IF;
 
	if(ID is null or ID = '')  
	begin  ;
		insert into EAPPForm(RegID,RegDate) 
		values(RegID,NOW())  
		ID := @IDENTITY;
		from eappform  

		update EAPPForm 
		SeqNo := seq;
			,IsDelete='0'
			,IsUsing='1'
			,IsFixedForm='0'
			,ErpType='QUERY'
			,IsErp='1'
			,pathid=0
			,IsClose='0'  
		WHERE   ID=eappsetformerp.id  

	END;

	RETURN QUERY
	SELECT ID   
  
	update EAPPForm 
	Name := eappsetformerp.name;
	,Code=eappsetformerp.code
	,StorePeriod=eappsetformerp.storeperiod
	,EACode=eappsetformerp.eacode
	,FormType=eappsetformerp.formtype
	,Content=eappsetformerp.content
	,Description=eappsetformerp.description
	,ModID=eappsetformerp.regid
	,ModDate=NOW() 
	,BoardID=eappsetformerp.boardid
	,DepartID=eappsetformerp.departid
	,CategoryID=eappsetformerp.categoryid
	,PathID = case when PathID = '-1' or PathID = '0' then PathID else PathID end
	,FixedPath=eappsetformerp.fixedpath  
	,ERPFixedPath = eappsetformerp.erpfixedpath
	,DraftLine=eappsetformerp.draftline
	,AgreeLine=eappsetformerp.agreeline
	,ProAgreeLine=eappsetformerp.proagreeline
	,ExeAgreeLine=eappsetformerp.exeagreeline
	,AssistLine=eappsetformerp.assistline
	,ProposalLine=eappsetformerp.proposalline
	,ExecuteLine=eappsetformerp.executeline
	,AuditLine=eappsetformerp.auditline
	,ReceiveLine=eappsetformerp.receiverline
	,ReferenceLine=eappsetformerp.referenceline
	,DraftCount=eappsetformerp.draftcount
	,AgreeCount=eappsetformerp.agreecount
	,ProAgreeCount=eappsetformerp.proagreecount
	,ExeAgreeCount=eappsetformerp.exeagreecount
	,AssistCount=eappsetformerp.assistcount
	,ProposalCount=eappsetformerp.proposalcount
	,ExecuteCount=eappsetformerp.executecount
	,AuditCount=eappsetformerp.auditcount
	,ReceiveCount=eappsetformerp.receivecount
	,ReferenceCount=eappsetformerp.referencecount
	,Width=eappsetformerp.width
	,Height=eappsetformerp.height
	,PrintType=eappsetformerp.printtype
	,TopMargin=eappsetformerp.topmargin
	,BottomMargin=eappsetformerp.bottommargin
	,LeftMargin=eappsetformerp.leftmargin
	,RightMargin=eappsetformerp.rightmargin
	,OperationType=eappsetformerp.operationtype
	,Standard=eappsetformerp.standard
	,RequireManager=eappsetformerp.requiremanager
	,IsErp=eappsetformerp.iserp
	,ErpType=eappsetformerp.erptype
	,ModApproval=eappsetformerp.modapproval
	,ReApproval=eappsetformerp.reapproval
	,PassageLine=eappsetformerp.passageline
	,PassageCount=eappsetformerp.passagecount
	,YesanLine=eappsetformerp.yesanline
	,YesanCount=eappsetformerp.yesancount
	,GamsaLine=eappsetformerp.gamsaline
	,GamsaCount=eappsetformerp.gamsacount  
	,PreFinalLine=eappsetformerp.prefinalline
	,FinalLine=eappsetformerp.finalline
	,PreFinalCount=eappsetformerp.prefinalcount
	,FinalCount=eappsetformerp.finalcount	
	,SerialLang = COALESCE(SerialLang, '1')  
	,EdmsSet = COALESCE(EdmsAutoCheck, EdmsSet)  
	,EdmsFolderID = COALESCE(EdmsFolderID, EdmsFolderID)  
	,EdmsFolderFix = COALESCE(EdmsFolderFix, EdmsFolderFix) 
	,EDMSAuth=COALESCE(EdmsAuth, EDMSAuth) 
	,EDMSAuthFix=COALESCE(EdmsAuthFix, EDMSAuthFix) 
	,EDMSAuthDefault=COALESCE(EdmsAuthDefault, EDMSAuthDefault) 
	,DocSerial = eappsetformerp.formserial
	,IsHotNews = eappsetformerp.ishotnews
	,IsShare = eappsetformerp.isshare
	,noDecision = eappsetformerp.nodecision
	,PopUpUrl = eappsetformerp.popupurl
	,UseTemp = eappsetformerp.usetemp
	,UseMod = eappsetformerp.usemod
	,UseDel = eappsetformerp.usedel
	,EDMSAuthorityLevel=eappsetformerp.edmsauthoritylevel
	,LinkForm=eappsetformerp.linkform
	WHERE ID=eappsetformerp.id;
  

	--사용부서다중선택(20080828 김민지)
	--EXEC EAPPRegFormDepart ID, DEPARTLIST
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
