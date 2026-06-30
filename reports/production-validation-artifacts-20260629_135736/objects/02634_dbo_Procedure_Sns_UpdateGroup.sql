-- ─── PROCEDURE→FUNCTION: sns_updategroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_updategroup(character varying, integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.sns_updategroup(
    IN groupname character varying,
    IN groupno integer,
    IN makeuserno integer,
    IN opentype integer,
    IN addusers character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupName != '' AND OpenType > -1 THEN;
		UPDATE SnsGroups SET GroupName=sns_updategroup.groupname, OpenType=sns_updategroup.opentype WHERE GroupNo = sns_updategroup.groupno
	END IF;
	
	IF DelUsers != '' THEN
		-- 그룹 맴버 삭제(방장제외);
		DELETE FROM SnsGroupUsers WHERE UserNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(DelUsers, ';'))
	END IF;
	
	IF AddUsers != '' THEN
		-- 그룹 맴버 추가(방장제외)	;
		INSERT INTO SnsGroupUsers ( GroupNo, IsBookmark, IsJoin, UserNo, RegDate )
		RETURN QUERY
		SELECT GroupNo, 0, 0, VALUE, NOW() FROM public."UF_TEXT_SPLIT"(AddUsers,';')
		
		-- 초대 이슈 남김;
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
    	SELECT 2, 4, GroupNo, GroupNo, MakeUserNo, VALUE, '그룹초대', NOW() FROM public."UF_TEXT_SPLIT"(AddUsers,';')    
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
