-- ─── FUNCTION: edmssetadmin ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmssetadmin(character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmssetadmin(
    userid character varying,
    langcode character varying
) RETURNS TABLE(
    userid text
)
AS $function$
DECLARE
    userid character varying;
    authoritylevel character varying;
BEGIN
	/*	
RETURN QUERY
select * from EDMSUSERENV


select	UserId			=	'0309008;0312028;0405013;0408004;0512033;admin;cnn1;cnn2;'	
	--*/	
	/***************************************************************************
	-- 기본변수셋팅
	***************************************************************************/

	/***************************************************************************
	-- 기존내역 변경.
	***************************************************************************/
	--기존 내역은 무조건 삭제하고 다시 업데이트 및 등록을 한다.;
	update	EDMSUSERENV 
	set		adminFlag = ''

	
	UPDATE	EDMSUSERENV
	SET		adminFlag = 'Y'
	FROM	EDMSUSERENV	 A
			INNER JOIN	
			EDMSSplitTable(UserId,';') B
			ON A.USERID = B.CONTENTS
	
	

	/***************************************************************************
	-- EDMSDOCUMENT INSERT
	***************************************************************************/;
	INSERT INTO EDMSUSERENV
	(
		userid
	,	ApplyAllList
	,	AuthorityLevel
	,	ADMINFLAG
	)	
	RETURN QUERY
	SELECT 
				CONTENTS
	,			'0'
	,			AuthorityLevel	
	,			'Y'
	FROM	EDMSSplitTable(UserId,';') B
	where	B.CONTENTS not in (
									select Userid from EDMSUSERENV
								)



exec EDMS_EDMSGetAdminByUsers LangCode;
	--exec EDMSGetAdmin
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
