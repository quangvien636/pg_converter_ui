-- ─── PROCEDURE→FUNCTION: sns_insertreply ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_insertreply(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_insertreply(
    IN message character varying,
    IN messageno integer,
    IN groupno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    writer integer;
    replyno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO SnsReplys (MessageNo, GroupNo, UserNo, Message, RegDate)
	VALUES (MessageNo,GroupNo,UserNo,Message,NOW())
	

	ReplyNo := lastval();
	RETURN QUERY
	SELECT ReplyNo
	
	--같은 그룹안의 유저들에게만;
	INSERT INTO SnsReplyChk ( ReplyNo, UserNo, GroupNo, IsCheck, Regdate )
	RETURN QUERY
	SELECT ReplyNo, UserNo, GroupNo, 0, NOW() FROM SnsGroupUsers WHERE GroupNo=sns_insertreply.groupno
	
	--본인은 읽음 체크로 업데이트 처리;
	UPDATE SnsReplyChk SET IsCheck = TRUE WHERE GroupNo=sns_insertreply.groupno AND UserNo=sns_insertreply.userno
	
	--본인의 글이 아니면 이슈 데이터를 남깁니다.
	SELECT UserNo INTO writer FROM SnsMessages WHERE MessageNo=sns_insertreply.messageno
	IF Writer != sns_insertreply.userno THEN;
	INSERT INTO Biz_Company_1.public."SnsIssues"
           (IssueType
           ,ActionType
           ,GroupNo
           ,ParentNo
           ,Send_UserNo
           ,Recv_UserNo
           ,Message
           ,RegDate)
     VALUES
           (0				--소식타입(0:게시글,1:댓글,2:초대)
           ,2				--행동타입(0:좋아요,1:싫어요,2:댓글,3:공유,4:초대,5:거부)
           ,GroupNo
           ,MessageNo
           ,UserNo
           ,Writer
           ,Message
           ,NOW())
    END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
