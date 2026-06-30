-- ─── FUNCTION: sns_updategroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_updategroup(character varying, integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.sns_updategroup(
    groupname character varying,
    groupno integer,
    makeuserno integer,
    opentype integer,
    addusers character varying
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
BEGIN

	IF GroupName != '' AND OpenType > -1
	BEGIN;
		UPDATE SnsGroups SET GroupName=sns_updategroup.groupname, OpenType=sns_updategroup.opentype WHERE GroupNo = sns_updategroup.groupno
	END
	
	IF DelUsers != ''
	BEGIN
		-- 그룹 맴버 삭제(방장제외);
		DELETE FROM SnsGroupUsers WHERE UserNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(DelUsers, ';'))
	END
	
	IF AddUsers != ''
	BEGIN
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
