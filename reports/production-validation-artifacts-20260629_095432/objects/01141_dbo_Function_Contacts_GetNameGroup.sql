-- ─── FUNCTION: contacts_getnamegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getnamegroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getnamegroup(
    userno integer,
    groupid integer
) RETURNS TABLE(
    groupno text,
    col2 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo
      ,CASE WHEN STRPOS(GroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(GroupName)  WHERE NAME='KO') ELSE GroupName END AS GroupName ,GroupName
       FROM ContactsGroup WHERE GroupNo=contacts_getnamegroup.groupid AND RegUserNo=contacts_getnamegroup.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
