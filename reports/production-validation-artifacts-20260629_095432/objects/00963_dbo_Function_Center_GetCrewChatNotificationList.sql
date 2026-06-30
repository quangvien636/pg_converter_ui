-- ─── FUNCTION: center_getcrewchatnotificationlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getcrewchatnotificationlist(integer, integer);
CREATE OR REPLACE FUNCTION public.center_getcrewchatnotificationlist(
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    rownum text,
    username text,
    no text,
    name text,
    userno text,
    message text,
    regdate text
)
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
BEGIN

	




	SET TotalItemCount = (SELECT COUNT(*) FROM Center_CrewChatNotification
	join Organization_Users
	on Center_CrewChatNotification.UserNo = Organization_Users.UserNo)
	
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = center_getcrewchatnotificationlist.currentpageindex * CountPerPage
	
	RETURN QUERY
	SELECT 
	*  FROM (
	SELECT 
	ROW_NUMBER() OVER (ORDER BY No desc) AS ROWNUM,	
	Organization_Users.Name as UserName
	,No
	,Organization_Users.Name
	,Center_CrewChatNotification.UserNo
	,Message
	,RegDate
	FROM Center_CrewChatNotification
	join Organization_Users
	on Center_CrewChatNotification.UserNo = Organization_Users.UserNo
	) V
	WHERE V.RowNum BETWEEN StartRowNum AND EndRowNum
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalAccessCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
