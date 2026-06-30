-- ─── FUNCTION: mail_getmails_fornos ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails_fornos(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_fornos(
    mailnos character varying,
    totalcount integer,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    tagno text,
    imageno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		

		RowNum	INT IDENTITY(1, 1),
		MailNo	BIGINT
	)
	


    SET Len = LEN(MailNos)
    SET Pos = 0

    WHILE ((STRPOS(MailNos, Pos, ';') - Pos) > 0) BEGIN
    
		SET Val = SUBSTRING(MailNos, Pos, (STRPOS(MailNos, Pos, ';') - Pos))
		
        INSERT INTO SearchResult SELECT Val
        SET Pos = STRPOS(MailNos, Pos, ';') + 1
        
    END

    IF Pos <= Len BEGIN
    
		SET Val = SUBSTRING(MailNos, Pos, (Len + 1) - Pos);
        INSERT INTO SearchResult SELECT Val
        
    END

	
	
	/*
	 * 
	 */



	SET TotalItemCount = mail_getmails_fornos.totalcount
	SET TotalPageCount = TotalItemCount / CountPerPage
	
	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount
	
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
