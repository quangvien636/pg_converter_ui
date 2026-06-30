-- ─── FUNCTION: sns_insertreply ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_insertreply(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_insertreply(
    message character varying,
    messageno integer,
    groupno integer,
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    writer integer;
    replyno integer;
BEGIN


	INSERT INTO SnsReplys (MessageNo, GroupNo, UserNo, Message, RegDate)
	VALUES (MessageNo,GroupNo,UserNo,Message,NOW())
	

	SET ReplyNo = lastval()
	
	RETURN QUERY
	SELECT ReplyNo
	
	--같은 그룹안의 유저들에게만;
	INSERT INTO SnsReplyChk ( ReplyNo, UserNo, GroupNo, IsCheck, Regdate )
	RETURN QUERY
	SELECT ReplyNo, UserNo, GroupNo, 0, NOW() FROM SnsGroupUsers WHERE GroupNo=sns_insertreply.groupno
	
	--본인은 읽음 체크로 업데이트 처리;
	UPDATE SnsReplyChk SET IsCheck = TRUE WHERE GroupNo=sns_insertreply.groupno AND UserNo=sns_insertreply.userno
	
	--본인의 글이 아니면 이슈 데이터를 남깁니다.
	SELECT Writer=sns_insertreply.userno FROM SnsMessages WHERE MessageNo=sns_insertreply.messageno
	IF Writer != sns_insertreply.userno
	BEGIN;
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
    END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
