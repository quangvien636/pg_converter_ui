-- ─── FUNCTION: edmsusersetauthoritylevel ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsusersetauthoritylevel(character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmsusersetauthoritylevel(
    userid character varying,
    authoritylevel character varying
) RETURNS TABLE(
    userid text
)
AS $function$
DECLARE
    userid character varying;
BEGIN
	/*	
RETURN QUERY
select * from EDMSUSERENV


	,	AuthorityLevel	nvarchar(50)	--등급	
select	UserId			=	'0008018;0209008;'
	,	AuthorityLevel	=	'3'
	--*/	

	/***************************************************************************
	-- 기존내역 변경.
	***************************************************************************/;
	UPDATE	EDMSUSERENV
	SET		AuthorityLevel = edmsusersetauthoritylevel.authoritylevel
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
	,	adminflag
	)	
	RETURN QUERY
	SELECT 
				CONTENTS
	,			'0'
	,			AuthorityLevel										
	,			''
	FROM	EDMSSplitTable(UserId,';') B
	where	B.CONTENTS not in (
									select Userid from EDMSUSERENV
								);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
