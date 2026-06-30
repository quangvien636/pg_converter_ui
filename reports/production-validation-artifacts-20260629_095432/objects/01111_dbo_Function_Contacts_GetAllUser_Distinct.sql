-- ─── FUNCTION: contacts_getalluser_distinct ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getalluser_distinct(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getalluser_distinct(
    reguserno integer,
    currpage integer DEFAULT 1,
    recodperpage integer DEFAULT 20
) RETURNS TABLE(
    col1 text,
    col2 text
)
AS $function$
BEGIN

	WITH s AS
		(
			SELECT ROW_NUMBER() 
				OVER(ORDER BY Seq DESC) AS RowNum,Seq,FirstName,LastName,RegUserNo,Memo,RegDate,Photo,ModDate,CallName,ViewCount,(FirstName+LastName) as FullName
				--,(SELECT COUNT(*) FROM ContactsUser WHERE  Seq IN  (select MAX(Seq) AS SEQ FROM ContactsUser WHERE RegUserNo=RegUserNo GROUP BY FirstName+LastName)) as counts
			FROM ContactsUser Cu
			WHERE Seq IN  (select MAX(Seq) AS SEQ FROM ContactsUser WHERE RegUserNo=contacts_getalluser_distinct.reguserno   GROUP BY FirstName+LastName)
		  AND RegUserNo=contacts_getalluser_distinct.reguserno AND UseYn='Y'	
		)
		RETURN QUERY
		Select * , (select COUNT(*) FROM s) As counts From s 
		Where RowNum Between 
			(currPage - 1)*recodperpage+1 
			AND currPage*recodperpage	
			ORDER BY Seq DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
