-- ─── PROCEDURE→FUNCTION: sns_insertissue ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_insertissue(integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_insertissue(
    IN issuetype integer,
    IN actiontype integer,
    IN groupno integer,
    IN parentno integer,
    IN senduserno integer,
    IN recvuserno integer
) RETURNS SETOF record
AS $function$
DECLARE
    issueno integer;
-- !! WARNING: output needs manual review — see TODO comments
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
	

	IssueNo := lastval();
	RETURN QUERY
	SELECT IssueNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
