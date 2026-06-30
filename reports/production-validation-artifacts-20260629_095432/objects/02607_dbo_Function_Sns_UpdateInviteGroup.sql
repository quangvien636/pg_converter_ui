-- ─── FUNCTION: sns_updateinvitegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_updateinvitegroup(integer, integer);
CREATE OR REPLACE FUNCTION public.sns_updateinvitegroup(
    groupuserno integer,
    isresult integer
) RETURNS TABLE(
    2 text,
    5 text,
    groupno text,
    groupno text,
    userno text,
    makeuserno text,
    col7 text,
    col8 text
)
AS $function$
BEGIN

	-- 업데이트 처리
	IF IsResult = TRUE
	-- 초대 수락
	BEGIN;
		UPDATE SnsGroupUsers SET IsJoin=sns_updateinvitegroup.isresult WHERE GroupUserNo=sns_updateinvitegroup.groupuserno
	END
	ELSE
	-- 초대 거절
	BEGIN
		-- 거절 일 경우 삭제하지는 않으며, IsJoin값으로 0이 온다.
		-- 초대거절 이슈를 남기고...;
		INSERT INTO Biz_Company_1.public."SnsIssues"
           (IssueType
           ,ActionType
           ,GroupNo
           ,ParentNo
           ,Send_UserNo
           ,Recv_UserNo
           ,Message
           ,RegDate)
        RETURN QUERY
        SELECT 2,5,GU.GroupNo,GU.GroupNo,GU.UserNo,G.MakeUserNo,'초대거절',NOW() 
        FROM SnsGroupUsers GU
        INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo 
        WHERE GroupUserNo=sns_updateinvitegroup.groupuserno
        -- 해당 초대를 삭제한다.;
        DELETE FROM SnsGroupUsers WHERE GroupUserNo=sns_updateinvitegroup.groupuserno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
