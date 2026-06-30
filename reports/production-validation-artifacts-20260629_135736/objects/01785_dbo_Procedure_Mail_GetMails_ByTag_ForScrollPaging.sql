-- ─── PROCEDURE→FUNCTION: mail_getmails_bytag_forscrollpaging ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.mail_getmails_bytag_forscrollpaging(integer, integer, character varying, bigint, bigint, boolean, bigint);
CREATE OR REPLACE FUNCTION public.mail_getmails_bytag_forscrollpaging(
    IN userno integer,
    IN searchtype integer,
    IN searchtext character varying,
    IN accno bigint,
    IN mailtagno bigint,
    IN isdownward boolean,
    IN anchormailno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
    searchresult table (
		rownum		int,
		mailno		bigint
	);
    anchorrownum bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	/*
	 * 쿼리 조합 시작
	 */

	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY MailNo DESC) RowNum, MailNo ' +;
		'FROM Mail_Mails WHERE UserNo = UserNo '

	IF (AccNo = -1) SET Query += 'AND IsDelete = FALSE ' THEN
	ELSE SET Query += 'AND AccNo = AccNo AND IsDelete = FALSE '
	
	SET Query += 'AND TagNo = MailTagNo '



	/*
	 * 검색 조건
	 */
	 
	IF SearchText != '' THEN

		IF (SearchType = 1) SET Query += 'AND Title ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 2) SET Query += 'AND To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 3) SET Query += 'AND (FromName + FromAddr) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 4) SET Query += 'AND RegDate ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN

	END IF;

	

	INSERT INTO SearchResult
	EXECUTE format(Query, UserNo, AccNo, MailTagNo, SearchText);
	/*
	 * 메일 목록을 가져옵니다.
	 */
	 

	AnchorRowNum := 0;
	IF AnchorMailNo != 0 THEN

		SELECT RowNum INTO anchorrownum FROM SearchResult WHERE MailNo = mail_getmails_bytag_forscrollpaging.anchormailno
		
	END IF;
	

	IF IsDownward = TRUE THEN
	
		RETURN QUERY
		SELECT /* TOP 20 */ M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
		FROM SearchResult T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_bytag_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
		WHERE T.RowNum > AnchorRowNum
		ORDER BY T.RowNum ASC
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
		FROM SearchResult T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_bytag_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
		WHERE T.RowNum < AnchorRowNum
		ORDER BY T.RowNum ASC
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
