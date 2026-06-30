-- ─── PROCEDURE→FUNCTION: edmstreeitemsortchange ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmstreeitemsortchange();
CREATE OR REPLACE FUNCTION public.edmstreeitemsortchange(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

/*
exec EAPPTreeItemSortChange UserGrpList = '403,402,406,404,400', LoginId = '0408004'


	,	LoginId		NVARCHAR(50)  --수정한사용자아니디
,	divid			varchar(200)	--트리의 종류

	UserGrpList := ('403,402,406,404,400');
	, 	LoginId = '0408004'
,	DIVID	  = '1'
--*/

	UPDATE 	EDMSTreeItem
	SortOrd := B.IDX - 1;
	,	ModId		= LoginId
	, 	ModDATE	= NOW()
--	SElect *
	FROM
		EDMSTreeItem A
		INNER JOIN	
		(
			SELECT IDX
			, CODE 
			FROM public."EDMSGetCodeToTable"(UserGrpList, ',')
		) AS B
		ON A.ID = B.CODE
	WHERE	A.DIVID = DIVID	
	and (( DIVID = '4' AND 	UserId	=	LoginId)	
				OR DIVID IN ('1','2','3','5') );
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
