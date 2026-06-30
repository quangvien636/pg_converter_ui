-- ─── FUNCTION: sns_insertmessage ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_insertmessage(character varying, integer, integer, boolean, integer);
CREATE OR REPLACE FUNCTION public.sns_insertmessage(
    message character varying,
    groupno integer,
    userno integer,
    isshare boolean,
    sharecontentno integer
) RETURNS TABLE(
    col1 text,
    userno text,
    groupno text,
    0 text,
    col5 text
)
AS $function$
DECLARE
    msgno integer;
BEGIN

	
	INSERT INTO SnsMessages (GroupNo, UserNo, Message, IsShare, ShareContentNo, RegDate)
	VALUES (GroupNo,UserNo,Message,IsShare,ShareContentNo,NOW())
	

	SET MsgNo = lastval()
	
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
