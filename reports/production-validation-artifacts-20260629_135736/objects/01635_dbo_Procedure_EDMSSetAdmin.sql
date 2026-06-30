-- ─── PROCEDURE→FUNCTION: edmssetadmin ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmssetadmin(character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmssetadmin(
    IN userid character varying,
    IN langcode character varying
) RETURNS SETOF record
AS $function$
DECLARE
    userid character varying;
    authoritylevel character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	
RETURN QUERY
select * from EDMSUSERENV


UserId := ('0309008;0312028;0405013;0408004;0512033;admin;cnn1;cnn2;');
	--*/	
	/***************************************************************************
	-- 기본변수셋팅
	***************************************************************************/

	/***************************************************************************
	-- 기존내역 변경.
	***************************************************************************/
	--기존 내역은 무조건 삭제하고 다시 업데이트 및 등록을 한다.;
	update	EDMSUSERENV 
	adminFlag := '';;
	UPDATE	EDMSUSERENV
	adminFlag := 'Y';
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
