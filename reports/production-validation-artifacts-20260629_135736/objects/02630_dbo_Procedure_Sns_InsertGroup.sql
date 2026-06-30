-- ─── PROCEDURE→FUNCTION: sns_insertgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_insertgroup(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_insertgroup(
    IN groupname character varying,
    IN makeuserno integer,
    IN grouptype integer,
    IN opentype integer
) RETURNS SETOF record
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO SnsGroups ( GroupName, MakeUserNo, GroupType, OpenType )
	VALUES (GroupName, MakeUserNo, GroupType, OpenType)
	

	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo

	-- 방장 추가;
	INSERT INTO SnsGroupUsers ( GroupNo, IsBookmark, IsJoin, UserNo, RegDate )
	VALUES (GroupNo, 0, 1, MakeUserNo, NOW())
	
	-- 그룹 맴버 추가(방장제외)
	IF Users != '' THEN;
		INSERT INTO SnsGroupUsers ( GroupNo, IsBookmark, IsJoin, UserNo, RegDate )
		RETURN QUERY
		SELECT GroupNo, 0, 0, VALUE, NOW() FROM public."UF_TEXT_SPLIT"(Users,';')
		
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
    	SELECT 2, 4, GroupNo, GroupNo, MakeUserNo, VALUE, '그룹초대', NOW() FROM public."UF_TEXT_SPLIT"(Users,';')    
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
