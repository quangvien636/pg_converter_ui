-- ─── FUNCTION: contacts_getprivateboxcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getprivateboxcount(integer);
CREATE OR REPLACE FUNCTION public.contacts_getprivateboxcount(
    reguserno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

RETURN QUERY
select count(T.seq) from (
	SELECT distinct u.* FROM ContactsGroupUser G
	INNER JOIN ContactsUser U ON U.Seq = G.UserSeq AND U.UseYn='Y'
	inner join ContactsGroup cg on cg.groupno=g.groupno
	WHERE   
	--U.RegUserNo=RegUserNo and
	(U.RegUserNo=contacts_getprivateboxcount.reguserno) AND SUBSTRING(U.Share,1,3)='100'
	) as T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
