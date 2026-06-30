-- ─── FUNCTION: sns_insertgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_insertgroup(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_insertgroup(
    groupname character varying,
    makeuserno integer,
    grouptype integer,
    opentype integer
) RETURNS TABLE(
    2 text,
    4 text,
    groupno text,
    groupno text,
    makeuserno text,
    value text,
    col7 text,
    col8 text
)
AS $function$
DECLARE
    groupno integer;
BEGIN


	INSERT INTO SnsGroups ( GroupName, MakeUserNo, GroupType, OpenType )
	VALUES (GroupName, MakeUserNo, GroupType, OpenType)
	

	SET GroupNo = lastval()
	
	RETURN QUERY
	SELECT GroupNo

	-- 방장 추가;
	INSERT INTO SnsGroupUsers ( GroupNo, IsBookmark, IsJoin, UserNo, RegDate )
	VALUES (GroupNo, 0, 1, MakeUserNo, NOW())
	
	-- 그룹 맴버 추가(방장제외)
	IF Users != ''
	BEGIN;
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
