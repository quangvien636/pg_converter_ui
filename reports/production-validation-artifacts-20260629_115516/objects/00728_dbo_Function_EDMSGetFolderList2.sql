-- ─── FUNCTION: edmsgetfolderlist2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetfolderlist2(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsgetfolderlist2(
    docid integer,
    classflag character varying
) RETURNS character varying
AS $function$
DECLARE
    returnstring character varying;
BEGIN



	SELECT returnstring = COALESCE(max(case idx when  1 then name end),'') || COALESCE(max(case idx when  2 then name end),'') || COALESCE(max(case idx when  3 then name end),'') || COALESCE(max(case idx when  4 then name end),'') || COALESCE(max(case idx when  5 then name end),'')	 

	FROM 
	(
			select	convert(varchar,b.id) || ',' || replace(case when lang='1' then b.itemnm1 when lang='2' then b.itemnm2 when lang='3' then b.itemnm3 when lang='4' then b.itemnm4 else b.itemnm1 end,',','，') || ':' as name							
					--아이덴티티필드
					,	(
							select	COUNT(D.ID)
							from	edmsdocfolder C
									inner join
									edmstreeitem D
									on C.folderid = D.id and c.divid=d.divid
							where	C.docid = edmsgetfolderlist2.docid
							and		D.DivId = edmsgetfolderlist2.classflag
							AND		A.ID >= C.ID
						)	AS IDX
			from	edmsdocfolder a
					inner join
					edmstreeitem b
					on a.folderid = b.id and a.divid=b.divid
			where	docid = edmsgetfolderlist2.docid
			and		b.DivId = edmsgetfolderlist2.classflag
	) A	

	RETURN returnstring;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
