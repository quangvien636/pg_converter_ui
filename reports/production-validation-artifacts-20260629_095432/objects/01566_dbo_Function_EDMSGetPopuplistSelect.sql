-- ─── FUNCTION: edmsgetpopuplistselect ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetpopuplistselect(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsgetpopuplistselect(
    docid integer,
    lan character varying
) RETURNS TABLE(
    col1 text,
    divid text
)
AS $function$
DECLARE
    selectflag character varying;
BEGIN
/*

	,		DOCID		INT
	,		LAN		VARCHAR(1)
	SELECT	SELECTFLAG	= 'CLASSFLAG'
	,		DOCID		= 21
	,		LAN		= '1'
--*/

	--수신처
	IF(SELECTFLAG = 'SUSIN')
		BEGIN
			RETURN QUERY
			SELECT	case when LAN='1' then '사용자' when LAN='2' then 'User' when LAN='3' then 'User' when LAN='4' then 'User' else '사용자' end	as state
			,		USERID as cd
			,		'user' as mode
			FROM	EDMSReceiveUSER 
			WHERE	DOCID = edmsgetpopuplistselect.docid
			
			UNION ALL		

			RETURN QUERY
			SELECT	case when LAN='1' then '부서' when LAN='2' then 'Depart' when LAN='3' then 'Depart' when LAN='4' then 'Depart' else '부서' end	as state
			,		ORGCD as cd
			,		'dept' as mode
			FROM 	EDMSReceiveORG 
			WHERE	DOCID = edmsgetpopuplistselect.docid			
		END	
	ELSE
	IF	(SELECTFLAG = 'SUCURITY')	--권한 3
		BEGIN
			RETURN QUERY
			SELECT	case when LAN='1' then '사용자' when LAN='2' then 'User' when LAN='3' then 'User' when LAN='4' then 'User' else '사용자' end	as state
			,		CONVERT(NVARCHAR(50),Organization_Users.USERID) as cd
			,		'user' as mode
			FROM	EDMSAUTHUSER
				left join Organization_Users on Organization_Users.UserID = EDMSAUTHUSER.UserID or CONVERT(NVARCHAR(50),Organization_Users.UserNo) = EDMSAUTHUSER.UserID
			WHERE	DOCID = edmsgetpopuplistselect.docid
			
			UNION ALL		

			RETURN QUERY
			SELECT	case when LAN='1' then '부서' when LAN='2' then 'Depart' when LAN='3' then 'Depart' when LAN='4' then 'Depart' else '부서' end	as state
			,		CONVERT(NVARCHAR(50),ORGCD) as cd
			,		'dept' as mode
			FROM 	EDMSAUTHDEPART
			WHERE	DOCID = edmsgetpopuplistselect.docid			

		END
	ELSE
	IF	(SELECTFLAG = 'CLASSFLAG')	
		BEGIN
			RETURN QUERY
			SELECT	CASE B.DIVID WHEN 1 THEN case when LAN='1' then '문서보관함' when LAN='2' then 'DocStore' when LAN='3' then 'DocStore' when LAN='4' then 'DocStore' else '문서보관함' end
								 WHEN 2 THEN case when LAN='1' then '문서 분류' when LAN='2' then 'DocCatergory' when LAN='3' then 'DocCatergory' when LAN='4' then 'DocCatergory' else '문서보관함' end
					END		as state
			,		CASE	WHEN LAN = '1' THEN ITEMNM1
							WHEN LAN = '2' THEN ITEMNM2
							WHEN LAN = '3' THEN ITEMNM3
							WHEN LAN = '4' THEN ITEMNM4
					ELSE	ItemNm1
					END		AS NAME
		
			FROM
				(	
					SELECT DISTINCT	FOLDERID, divid
					FROM	EDMSDocFolder A
					WHERE	DOCID = edmsgetpopuplistselect.docid
				) A
				INNER JOIN
				EDMSTREEITEM B					
				ON A.FOLDERID = B.ID and A.divid=b.DivID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
