-- ─── FUNCTION: contacts_countusersharewithoutgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_countusersharewithoutgroup(integer);
CREATE OR REPLACE FUNCTION public.contacts_countusersharewithoutgroup(
    reguserno integer DEFAULT 70
) RETURNS TABLE(
    seq text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT COUNT(u.Seq) FROM ContactsUser U
	LEFT JOIN Contact_ShareGroupUser SU ON SU.UserSeq = U.Seq AND U.UseYn='Y' AND SU.IsDelete= FALSE
	WHERE U.UseYn='Y' AND 
	((U.RegUserNo=contacts_countusersharewithoutgroup.reguserno AND SUBSTRING(U.Share,1,3)='200' AND SU.UserSeq IS NULL)  OR 
	(SUBSTRING(U.Share,1,3)='200' AND SU.UserSeq IS NULL AND ( U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo=contacts_countusersharewithoutgroup.reguserno))) );
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
