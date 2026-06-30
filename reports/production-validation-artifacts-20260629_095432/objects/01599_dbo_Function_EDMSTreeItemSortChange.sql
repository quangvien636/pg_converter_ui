-- ─── FUNCTION: edmstreeitemsortchange ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmstreeitemsortchange();
CREATE OR REPLACE FUNCTION public.edmstreeitemsortchange(
) RETURNS TABLE(
    idx text,
    code text
)
AS $function$
BEGIN

/*
exec EAPPTreeItemSortChange UserGrpList = '403,402,406,404,400', LoginId = '0408004'


	,	LoginId		NVARCHAR(50)  --수정한사용자아니디
,	divid			varchar(200)	--트리의 종류

	SELECT UserGrpList = '403,402,406,404,400'
	, 	LoginId = '0408004'
,	DIVID	  = '1'
--*/

	UPDATE 	EDMSTreeItem
	SET	SortOrd  	= 	B.IDX - 1
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
