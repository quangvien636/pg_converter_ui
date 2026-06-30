-- ─── FUNCTION: edmsgetfolderlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetfolderlist(integer);
CREATE OR REPLACE FUNCTION public.edmsgetfolderlist(
    docid integer
) RETURNS character varying
AS $function$
DECLARE
    returnstring character varying;
BEGIN



		 + COALESCE(max(case idx when  2 then name end),'') || COALESCE(max(case idx when  3 then name end),'') || COALESCE(max(case idx when  4 then name end),'') || COALESCE(max(case idx when  5 then name end),'')	 
	-- || COALESCE(max(case idx when  6 then name end),'')
	-- || COALESCE(max(case idx when  7 then name end),'')
	-- || COALESCE(max(case idx when  8 then name end),'')
	-- || COALESCE(max(case idx when  9 then name end),'')	 
	-- || COALESCE(max(case idx when  10 then name end),'')

	FROM 
	(
			select	convert(varchar,b.id) || ',' || b.itemnm1 || ':' as name							
					--아이덴티티필드
					,	(
							select	COUNT(D.ID)
							from	edmsdocfolder C
									inner join
									edmstreeitem D
									on C.folderid = D.id
							where	C.docid = edmsgetfolderlist.docid
							and		D.DivId = ClassFlag
							AND		A.ID >= C.ID
						)	AS IDX
			from	edmsdocfolder a
					inner join
					edmstreeitem b
					on folderid = b.id
			where	docid = edmsgetfolderlist.docid
			and		b.DivId = ClassFlag
	) A	

	
	RETURN returnstring;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
