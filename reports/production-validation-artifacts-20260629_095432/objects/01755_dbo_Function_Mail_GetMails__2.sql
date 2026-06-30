-- ─── FUNCTION: mail_getmails__2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails__2(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails__2(
    mailnos character varying,
    totalcount integer,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    mailno text,
    cmsendnum text,
    boxno text,
    fromname text,
    fromaddr text,
    to text,
    cc text,
    bcc text,
    accno text,
    title text,
    issent text,
    recipientscount text,
    readcount text,
    isonebyone text,
    replydate text,
    forwarddate text,
    isimportant text,
    tagno text,
    size text,
    filecount text,
    regdate text,
    readdate text,
    boxname text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		

		RowNum		INT IDENTITY(1, 1),
		MailNo		BIGINT
	)
	


    SET Len = Len(MailNos)
    SET Pos = 0

    WHILE ( STRPOS(MailNos, Pos, ';') - Pos ) > 0 BEGIN
    
		SET Val = Substring(MailNos, Pos, ( STRPOS(MailNos, Pos, ';') - Pos ))
		
        INSERT INTO SearchResult SELECT Val
        SET Pos = STRPOS(MailNos, Pos, ';') + 1
        
    END

    IF Pos <= Len BEGIN
    
		SET Val = Substring(MailNos, Pos, ( Len + 1 ) - Pos);
        INSERT INTO SearchResult SELECT Val
        
    END

	
	
	/*
	 * 
	 */



	SET TotalItemCount = mail_getmails__2.totalcount
	SET TotalPageCount = TotalItemCount / CountPerPage
	
	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount
	
	RETURN QUERY
	SELECT M.MailNo, CMSendNum, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
		AccNo, Title, IsSent, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, TagNo, Size, FileCount, RegDate, M.ReadDate, MB.Name AS BoxName
	FROM SearchResult T
	INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
	INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
	ORDER BY T.RowNum ASC
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalMailCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
