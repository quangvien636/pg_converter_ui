-- ─── PROCEDURE→FUNCTION: sns_insertmessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_insertmessage(character varying, integer, integer, boolean, integer);
CREATE OR REPLACE FUNCTION public.sns_insertmessage(
    IN message character varying,
    IN groupno integer,
    IN userno integer,
    IN isshare boolean,
    IN sharecontentno integer
) RETURNS SETOF record
AS $function$
DECLARE
    msgno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	INSERT INTO SnsMessages (GroupNo, UserNo, Message, IsShare, ShareContentNo, RegDate)
	VALUES (GroupNo,UserNo,Message,IsShare,ShareContentNo,NOW())
	

	MsgNo := lastval();
	RETURN QUERY
	SELECT MsgNo
	
	--같은 그룹안의 유저들에게만;
	INSERT INTO SnsMessageChk ( MessageNo, UserNo, GroupNo, IsCheck, Regdate )
	RETURN QUERY
	SELECT MsgNo, UserNo, GroupNo, 0, NOW() FROM SnsGroupUsers WHERE GroupNo=sns_insertmessage.groupno
	
	--본인은 읽음 체크로 업데이트 처리;
	UPDATE SnsMessageChk SET IsCheck = TRUE WHERE GroupNo=sns_insertmessage.groupno AND UserNo=sns_insertmessage.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
