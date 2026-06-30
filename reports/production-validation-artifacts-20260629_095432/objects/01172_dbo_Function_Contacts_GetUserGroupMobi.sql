-- ─── FUNCTION: contacts_getusergroupmobi ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getusergroupmobi(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getusergroupmobi(
    reguser integer,
    groupid integer,
    currpage integer DEFAULT 1,
    recodperpage integer DEFAULT 20
) RETURNS TABLE(
    seq serial,
    groupno integer,
    userseq integer,
    reguserno integer,
    regdate timestamp without time zone,
    moddate timestamp without time zone
)
AS $function$
BEGIN

	WITH s AS
		(
			SELECT ROW_NUMBER() 
				OVER(ORDER BY CG.UserSeq DESC) AS RowNum,CG.UserSeq ,
				(SELECT COUNT(*) FROM ContactsGroupUser CG INNER JOIN ContactsUser CU ON CG.UserSeq=CU.Seq
					WHERE CG.RegUserNo=contacts_getusergroupmobi.reguser 
						  AND CG.GroupNo=contacts_getusergroupmobi.groupid 
						  AND CU.UseYn='Y') as counts
			FROM ContactsGroupUser CG
			INNER JOIN ContactsUser CU
			ON CG.UserSeq=CU.Seq
			WHERE CG.RegUserNo=contacts_getusergroupmobi.reguser 
				  AND CG.GroupNo=contacts_getusergroupmobi.groupid 
				  AND CU.UseYn='Y'
		)
		RETURN QUERY
		Select * From s 
		Where RowNum Between 
			(currPage - 1)*recodperpage+1 
			AND currPage*recodperpage;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
