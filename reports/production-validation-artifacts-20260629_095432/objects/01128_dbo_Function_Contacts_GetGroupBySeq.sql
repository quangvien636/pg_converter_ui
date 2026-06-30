-- ─── FUNCTION: contacts_getgroupbyseq ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getgroupbyseq(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getgroupbyseq(
    userseq integer DEFAULT 0,
    langcode character varying DEFAULT 'EN'
) RETURNS TABLE(
    groupno text,
    name text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	WITH SHAREGROUP  AS(
		SELECT S.GroupNo, 
		CASE WHEN STRPOS(G.GroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(G.GroupName)  WHERE NAME=contacts_getgroupbyseq.langcode) ELSE G.GroupName END AS Name
		FROM ContactsGroupUser S
		INNER JOIN ContactsGroup G ON G.GroupNo=S.GroupNo AND  G.UseYn='Y'
		Where S.UserSeq=contacts_getgroupbyseq.userseq 
		--ORDER BY S.UserSeq DESC LIMIT 1
		UNION ALL
		SELECT S.ShareGroupNo AS GroupNo,
			CASE WHEN STRPOS(G.ShareGroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(G.ShareGroupName)  WHERE NAME=contacts_getgroupbyseq.langcode) ELSE G.ShareGroupName END AS Name
		FROM Contact_ShareGroupUser S
		INNER JOIN Contact_ShareGroup G ON G.ShareGroupNo=S.ShareGroupNo AND   G.IsDelete= FALSE
		Where S.UserSeq=contacts_getgroupbyseq.userseq  
		--ORDER BY S.UserSeq DESC LIMIT 1
		 UNION ALL
		SELECT S.PublicGroupNo AS GroupNo,
		CASE WHEN STRPOS(G.PublicGroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(G.PublicGroupName)  WHERE NAME=contacts_getgroupbyseq.langcode) ELSE G.PublicGroupName END AS Name
		FROM Contact_PublicGroupUser S
		INNER JOIN Contact_PublicGroup G ON G.PublicGroupNo=S.PublicGroupNo AND  G.IsDelete= FALSE
		Where S.UserSeq=contacts_getgroupbyseq.userseq 
		--ORDER BY S.UserSeq DESC LIMIT 1
	)
	RETURN QUERY
	SELECT /* /* TOP 1 */ */ T.GroupNo,T.Name FROM SHAREGROUP T ORDER BY T.GroupNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
