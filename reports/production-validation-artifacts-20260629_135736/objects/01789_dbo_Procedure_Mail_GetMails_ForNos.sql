-- ─── PROCEDURE→FUNCTION: mail_getmails_fornos ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.mail_getmails_fornos(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_fornos(
    IN mailnos character varying,
    IN totalcount integer,
    IN countperpage integer,
    IN currentpageindex integer
) RETURNS SETOF record
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		
	,
		MailNo	BIGINT
	)
	


    Len := LEN(MailNos);
    Pos := 0;
    WHILE (STRPOS(MailNos, Pos, ';') - Pos) > 0 LOOP
    
		Val := SUBSTRING(MailNos, Pos, (STRPOS(MailNos, Pos, ';') - Pos));;
        INSERT INTO SearchResult SELECT Val
        Pos := STRPOS(MailNos, Pos, ';') + 1;
    END LOOP;

    IF Pos <= Len THEN
    
		Val := SUBSTRING(MailNos, Pos, (Len + 1) - Pos);;
        INSERT INTO SearchResult SELECT Val
        
    END IF;

	
	
	/*
	 * 
	 */



	TotalItemCount := mail_getmails_fornos.totalcount;
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN
	
	RETURN QUERY
	SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
		AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
		Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
	FROM SearchResult T
	INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
	INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
	LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags) MT ON MT.TagNo = M.TagNo
	ORDER BY T.RowNum ASC
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalMailCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
