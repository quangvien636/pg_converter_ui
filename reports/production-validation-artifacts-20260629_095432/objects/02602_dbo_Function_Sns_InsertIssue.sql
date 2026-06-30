-- ─── FUNCTION: sns_insertissue ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_insertissue(integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_insertissue(
    issuetype integer,
    actiontype integer,
    groupno integer,
    parentno integer,
    senduserno integer,
    recvuserno integer
) RETURNS TABLE(
    issueno text
)
AS $function$
DECLARE
    issueno integer;
BEGIN

	
	INSERT INTO SnsIssues (
	IssueType, 
	ActionType, 
	GroupNo, 
	ParentNo, 
	Send_UserNo, 
	Recv_UserNo, 
	Message, 
	RegDate
	)
	VALUES (
	IssueType,
	ActionType,
	GroupNo,
	ParentNo,
	SendUserNo,
	RecvUserNo,
	Message,
	NOW()
	)
	

	SET IssueNo = lastval()
	
	RETURN QUERY
	SELECT IssueNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
