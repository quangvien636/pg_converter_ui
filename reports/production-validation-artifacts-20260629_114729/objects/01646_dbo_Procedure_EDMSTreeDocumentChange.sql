-- ─── PROCEDURE→FUNCTION: edmstreedocumentchange ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmstreedocumentchange(character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmstreedocumentchange(
    IN userid character varying,
    IN divid character varying
) RETURNS SETOF record
AS $function$
DECLARE
    parentid character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*
	exec EDMSTreeItemChange PARENTid='10',SELECTid='12',divid='1',check='1',UserId='0408004'
	RETURN QUERY
	select * from EDMSTreeItem order by divid , parentid desc

	,	UserId		varchar(500)
	PARENTid := ('69');
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
	modifier := edmstreedocumentchange.userid;
	,		moddate = NOW()
	where	id in (select Docid from EDMSDocFolder where folderid = SELECTid and divid=edmstreedocumentchange.divid)	

	update	EDMSDocFolder 
	folderid := PARENTid;
	where	folderid = SELECTid and divid=edmstreedocumentchange.divid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
