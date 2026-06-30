-- ─── FUNCTION: edmstreeitemlist2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmstreeitemlist2(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmstreeitemlist2(
    viewflag character varying DEFAULT 'N'--하위부서도 보여주는지 여부 'Y' : 뷰,
    orggroup character varying DEFAULT 'G001'		--계열사 코드,
    countflag character varying DEFAULT 'Y'--카운트 사용여부,
    treeid character varying DEFAULT '0'
) RETURNS TABLE(
    orgcd text
)
AS $function$
DECLARE
    chkauth character varying;
    lowdepart table (orgcd varchar(4);
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	if TreeID is null
		set TreeID = '0'
	


	
	select chkAuth = AuthorityLevel from EDMSUserEnv where UserID = UserId
	select chkUseTotallist = ValueData from EDMSConfiguration where KeyCode = 'UseTotallist';
	INSERT INTO lowdepart select CODE from EDMSGetCodeToTable(ORGCD,',')
	if(Viewflag = 'Y')
	begin
		IF DIVID = '3' --부서보관함일때 부서 트리를 보여준다.
		BEGIN

				RETURN QUERY
				select	'ORGCD'	AS ID
			,	'ORGNM1' AS ITEMNM
			,	'sortord' AS SORTORD
			,	'PARENTID' AS PARENTID	
			,	'1' AS foldertype

		END
		ELSE IF DIVID = '4' --개인보관함일때 개인트리의 카운트를 보여준다.
		BEGIN
			RETURN QUERY
			SELECT 			
				T.ID
			,	CASE  Lang 	WHEN '1' THEN T.ItemNm1
						WHEN '2' THEN T.ItemNm2
						WHEN '3' THEN T.ItemNm3
						WHEN '4' THEN T.ItemNm4
						ELSE	T.ItemNm1
				END 
				+ case	when COUNTFLAG	= 'Y'	 then '(' || CONVERT(VARCHAR(80),(SELECT count(P.ID) FROM EDMSPRIVATELIST P WHERE P.FolderID=T.ID ))+')'
									else '' 
									end  AS	ItemNm		
			,	T.SortOrd
			,	convert(varchar(20),T.ParentID)	as ParentID
			,	'2'  as  fordertype
			FROM  	EDMSTreeItem T			
			WHERE T.DivID = DIVID AND T.UserId	=	UserId	and	T.UseYn 	= 	UseYn and T.ParentID=edmstreeitemlist2.treeid
			order by T.SortOrd
		END	
		ELSE 
		BEGIN
			RETURN QUERY
			SELECT 			
				ID
			,	CASE  Lang 	WHEN '1' THEN ItemNm1
						WHEN '2' THEN ItemNm2
						WHEN '3' THEN ItemNm3 
						WHEN '4' THEN ItemNm4
						ELSE	ItemNm1
				END 
					+ case	when COUNTFLAG	= 'Y'	 then '(' || CONVERT(VARCHAR(80),(SELECT	count(F.ID) FROM EDMSFolderList F WHERE F.FOLDERID = T.ID and GroupCode = edmstreeitemlist2.orggroup))+')'
									else '' 
									end  AS	ItemNm
			,	SortOrd
			,	convert(varchar(20),ParentID) as	ParentID
			,	'2'  as  fordertype
			FROM  	EDMSTreeItem T
			WHERE	DivID	=	DivID 	and	UseYn 	= 	UseYn and ParentID=edmstreeitemlist2.treeid
			order by SortOrd

		END	
	end
	else
	begin
		IF DIVID = '3' --부서보관함일때 부서 트리를 보여준다.
		BEGIN
				RETURN QUERY
				select	'ORGCD'	AS ID
			,	'ORGNM1' AS ITEMNM
			,	'sortord' AS SORTORD
			,	'PARENTID' AS PARENTID	
			,	'1' AS foldertype
		END
		ELSE IF DIVID = '4' --개인보관함일때 개인트리의 카운트를 보여준다.
		BEGIN
			RETURN QUERY
			SELECT 			
				T.ID
			,	CASE  Lang 	WHEN '1' THEN T.ItemNm1
						WHEN '2' THEN T.ItemNm2
						WHEN '3' THEN T.ItemNm3
						WHEN '4' THEN T.ItemNm4
						ELSE	T.ItemNm1
				END 
				+ case	when COUNTFLAG	= 'Y'	 then '(' || CONVERT(VARCHAR(80),(SELECT count(P.ID) FROM EDMSPRIVATELIST P WHERE P.FolderID=T.ID ))+')'
									else '' 
									end  AS	ItemNm		
			,	T.SortOrd
			,	convert(varchar(20),T.ParentID)	as ParentID
			,	'2'  as  fordertype
			FROM  	EDMSTreeItem T			
			WHERE T.DivID = DIVID AND T.UserId	=	UserId	and	T.UseYn 	= 	UseYn and T.ParentID=edmstreeitemlist2.treeid
			order by T.SortOrd
		END	
		ELSE IF chkUseTotallist = '1'
		BEGIN
			RETURN QUERY
			SELECT 			
				ID
			,	CASE  Lang 	WHEN '1' THEN ItemNm1
						WHEN '2' THEN ItemNm2
						WHEN '3' THEN ItemNm3 
						WHEN '4' THEN ItemNm4
						ELSE	ItemNm1
				END 
					+ case	when COUNTFLAG	= 'Y'	 then '(' || CONVERT(VARCHAR(80),(SELECT	count(F.ID) FROM (SELECT *,public."EDMSAuthChk"(ID,UserId,ORGCD) as EDAuthChk,public."EAPPAuthChk"(EADocFlag,UserId) as EAAuthChk FROM EDMSFolderList) F WHERE F.FOLDERID = T.ID and ((EAAuth <> 100 and (AuthorityLevel >= chkAuth)) or EAAuthChk = 'Y' or EDAuthChk = 'Y' or AuthorityLevel = 0) and GroupCode = edmstreeitemlist2.orggroup))+')'
									else '' 
									end  AS	ItemNm
			,	SortOrd
			,	convert(varchar(20),ParentID) as	ParentID
			,	'2'  as  fordertype
			FROM  	EDMSTreeItem T
			WHERE	DivID	=	DivID 	and	UseYn 	= 	UseYn and ParentID=edmstreeitemlist2.treeid
			order by SortOrd

		END	
		ELSE
		BEGIN
	   			RETURN QUERY
	   			SELECT 			
				ID
			,	CASE  Lang 	WHEN '1' THEN ItemNm1
						WHEN '2' THEN ItemNm2
						WHEN '3' THEN ItemNm3 
						WHEN '4' THEN ItemNm4
						ELSE	ItemNm1
				END 
					+ case	when COUNTFLAG	= 'Y'	 then '(' || CONVERT(VARCHAR(80),(SELECT	count(F.ID) FROM (SELECT *,public."EDMSAuthChk"(ID,UserId,ORGCD) as EDAuthChk,public."EAPPAuthChk"(EADocFlag,UserId) as EAAuthChk FROM EDMSFolderList) F WHERE F.FOLDERID = T.ID and ((DepartID in (select orgcd from lowdepart) and EAAuth <> 100 and (AuthorityLevel >= chkAuth)) or EAAuthChk = 'Y' or EDAuthChk = 'Y' or AuthorityLevel = 0) and GroupCode = edmstreeitemlist2.orggroup))+')'
									else '' 
									end  AS	ItemNm
			,	SortOrd
			,	convert(varchar(20),ParentID) as	ParentID
			,	'2'  as  fordertype
			FROM  	EDMSTreeItem T
			WHERE	DivID =	DivID and UseYn = UseYn and ParentID=edmstreeitemlist2.treeid
			order by SortOrd
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
