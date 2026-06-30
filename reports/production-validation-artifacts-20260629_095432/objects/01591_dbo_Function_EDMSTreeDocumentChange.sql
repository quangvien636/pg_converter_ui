-- ─── FUNCTION: edmstreedocumentchange ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmstreedocumentchange(character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmstreedocumentchange(
    userid character varying,
    divid character varying
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    col4 text
)
AS $function$
DECLARE
    parentid character varying;
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/*
	exec EDMSTreeItemChange PARENTid='10',SELECTid='12',divid='1',check='1',UserId='0408004'
	RETURN QUERY
	select * from EDMSTreeItem order by divid , parentid desc

	,	UserId		varchar(500)
	SELECT 	PARENTid='69'
	,	SELECTid='70'	
	,	UserId='smkim'
--*/
/***********************************************************************************************************************
--	필요변수 셋팅 시작
***********************************************************************************************************************/


/***********************************************************************************************************************
--	필요변수 셋팅 끝
***********************************************************************************************************************/;
	update edmsdocument
	set		modifier = edmstreedocumentchange.userid
	,		moddate = NOW()
	where	id in (select Docid from EDMSDocFolder where folderid = SELECTid and divid=edmstreedocumentchange.divid)	

	update	EDMSDocFolder 
	set		folderid = PARENTid
	where	folderid = SELECTid and divid=edmstreedocumentchange.divid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
