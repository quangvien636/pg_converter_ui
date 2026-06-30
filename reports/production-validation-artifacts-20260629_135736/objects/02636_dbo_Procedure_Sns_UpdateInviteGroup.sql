-- ─── PROCEDURE→FUNCTION: sns_updateinvitegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_updateinvitegroup(integer, integer);
CREATE OR REPLACE FUNCTION public.sns_updateinvitegroup(
    IN groupuserno integer,
    IN isresult integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 업데이트 처리
	IF IsResult = TRUE THEN
	-- 초대 수락;
		UPDATE SnsGroupUsers SET IsJoin=sns_updateinvitegroup.isresult WHERE GroupUserNo=sns_updateinvitegroup.groupuserno
	END IF;
	ELSE
	-- 초대 거절
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
