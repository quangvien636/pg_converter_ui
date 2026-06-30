-- ─── FUNCTION: eappsetformerp ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappsetformerp(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.eappsetformerp(
    id character varying,
    name character varying,
    code character varying,
    standard character varying,
    storeperiod character varying,
    eacode character varying,
    formtype character varying,
    iserp character varying,
    erptype character varying,
    content text,
    description character varying,
    regid character varying,
    boardid character varying,
    categoryid character varying,
    departid character varying,
    pathid character varying,
    fixedpath character varying,
    erpfixedpath character varying,
    draftline character varying,
    agreeline character varying,
    assistline character varying,
    proposalline character varying,
    executeline character varying,
    auditline character varying,
    receiverline character varying,
    referenceline character varying,
    draftcount integer,
    agreecount integer,
    assistcount integer,
    proposalcount integer,
    executecount integer,
    auditcount integer,
    receivecount integer,
    referencecount integer,
    printtype character varying,
    topmargin character varying,
    bottommargin character varying,
    leftmargin character varying,
    rightmargin character varying,
    operationtype integer,
    requiremanager character varying,
    modapproval character varying,
    reapproval character varying,
    passageline character varying,
    passagecount integer,
    width integer,
    height integer,
    proagreeline character varying DEFAULT '0',
    exeagreeline character varying DEFAULT '0',
    yesanline character varying DEFAULT NULL,
    gamsaline character varying DEFAULT NULL,
    prefinalline character varying DEFAULT 0,
    finalline character varying DEFAULT 0,
    proagreecount integer DEFAULT 10,
    exeagreecount integer DEFAULT 10,
    yesancount integer DEFAULT NULL,
    gamsacount integer DEFAULT NULL,
    prefinalcount integer DEFAULT 10,
    finalcount integer DEFAULT 10,
    usetemp character varying DEFAULT '0',
    usemod character varying DEFAULT '0',
    usedel character varying DEFAULT '0',
    edmsautocheck character varying DEFAULT NULL,
    edmsfolderfix character varying DEFAULT NULL,
    edmsauth character varying DEFAULT NULL,
    edmsauthfix character varying DEFAULT NULL,
    edmsauthdefault character varying DEFAULT NULL,
    departlist character varying DEFAULT NULL,
    seriallang character varying DEFAULT NULL,
    formserial character varying DEFAULT NULL,
    ishotnews character varying DEFAULT '0',
    isshare character varying DEFAULT NULL,
    nodecision character varying DEFAULT NULL,
    popupurl character varying DEFAULT '',
    edmsauthoritylevel integer DEFAULT 0,
    linkform character varying DEFAULT '0'
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    col4 text,
    col5 text,
    col6 text,
    col7 text,
    col8 text,
    col9 text,
    col10 text,
    col11 text,
    col12 text,
    col13 text,
    col14 text,
    col15 text,
    col16 text,
    col17 text,
    col18 text,
    col19 text,
    col20 text,
    col21 text,
    col22 text,
    col23 text,
    col24 text,
    col25 text,
    col26 text,
    col27 text,
    col28 text,
    col29 text,
    col30 text,
    col31 text,
    col32 text,
    col33 text,
    col34 text,
    col35 text,
    col36 text,
    col37 text,
    col38 text,
    col39 text,
    col40 text,
    col41 text,
    col42 text,
    col43 text,
    col44 text,
    col45 text,
    col46 text,
    col47 text,
    col48 text,
    col49 text,
    col50 text,
    col51 text,
    col52 text,
    col53 text,
    col54 text,
    col55 text,
    col56 text,
    col57 text,
    col58 text,
    col59 text,
    col60 text,
    col61 text,
    col62 text,
    col63 text,
    col64 text,
    col65 text,
    col66 text,
    col67 text,
    col68 text,
    col69 text,
    col70 text,
    col71 text,
    col72 text,
    col73 text,
    col74 text,
    col75 text,
    col76 text
)
AS $function$
DECLARE
    seq integer;
BEGIN
	IF SerialLang = ''		
	begin

		SET SerialLang = NULL
	end
 
	if(ID is null or ID = '')  
	begin  ;
		insert into EAPPForm(RegID,RegDate) 
		values(RegID,NOW())  
		set ID=@IDENTITY  


		from eappform  

		update EAPPForm 
		set 
			SeqNo=seq
			,IsDelete='0'
			,IsUsing='1'
			,IsFixedForm='0'
			,ErpType='QUERY'
			,IsErp='1'
			,pathid=0
			,IsClose='0'  
		WHERE   ID=eappsetformerp.id  

	end  

	RETURN QUERY
	SELECT ID   
  
	update EAPPForm 
	set 
		Name=eappsetformerp.name
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
