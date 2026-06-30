-- ─── PROCEDURE→FUNCTION: edmsusersetauthoritylevel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmsusersetauthoritylevel(character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmsusersetauthoritylevel(
    IN userid character varying,
    IN authoritylevel character varying
) RETURNS SETOF record
AS $function$
DECLARE
    userid character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	
RETURN QUERY
select * from EDMSUSERENV


	,	AuthorityLevel	nvarchar(50)	--등급	
UserId := ('0008018;0209008;');
	,	AuthorityLevel	=	'3'
	--*/	

	/***************************************************************************
	-- 기존내역 변경.
	***************************************************************************/;
	UPDATE	EDMSUSERENV
	AuthorityLevel := edmsusersetauthoritylevel.authoritylevel;
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
