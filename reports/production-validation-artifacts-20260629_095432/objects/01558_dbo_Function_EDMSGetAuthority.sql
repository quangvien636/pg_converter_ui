-- ─── FUNCTION: edmsgetauthority ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetauthority(character varying, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmsgetauthority(
    userid character varying,
    edmsid integer,
    authoritylevel character varying,
    departno character varying
) RETURNS TABLE(
    id text
)
AS $function$
DECLARE
    userid character varying;
    viewflag character varying;
BEGIN
/*
권한의 순서 
전자결제 권한 (cs단에서 이미 진행되었음.) -> 권한이 있는지 판단 -> 보안등급이 맞는지 판단.

,	AuthorityLevel varchar(3)
,	DepartNo		varchar(4)
SELECT	UserId='SMKIM',edmsId=87,AuthorityLevel='4'
,	DepartNo		= 1119
--*/

	/**********************************************************************************************************
	--기본변수 셋팅
	************************************************************************************************************/

	,		VIEWCOUNT	INT
	,		Level		varchar(3)
	,		AuthUser   varchar(1)
	
	select Level = edmsgetauthority.authoritylevel,VIEWCOUNT = 0 from edmsdocument where ID = edmsgetauthority.edmsid

	--전체에 권한이 지정이 안되어있다면 전체공유라고 판단.
	--로직의 간결화를 위해 삭제	된 부분
	--권한 부서
	SELECT VIEWCOUNT = VIEWCOUNT +	(SELECT COUNT(1) FROM	EDMSAUTHUSER	WHERE DOCID = edmsgetauthority.edmsid)	
	--권한 유저
	SELECT VIEWCOUNT = VIEWCOUNT +	(SELECT COUNT(1) FROM	EDMSAUTHDEPART	WHERE DOCID = edmsgetauthority.edmsid)	
	
	-----------------------------------------------------------------------------------------------------------	

	--글쓴이가 본인이거나 권한 자체가 등록이 안된 문서라면 무조건 문서 뷰 가능 
	IF exists(SELECT 1 FROM	EDMSdocument WHERE ID = edmsgetauthority.edmsid and WriterID = edmsgetauthority.userid) 
	BEGIN
			SELECT 	VIEWFLAG = 'Y'
			select AuthUser = 'Y'

	END
	ELSE IF exists(select 1 from EAPPProgress inner join EAPPDocument on EAPPProgress.DocumentID=EAPPDocument.ID where EAPPDocument.EDMSID=edmsgetauthority.edmsid and EAPPProgress.ManagerID=edmsgetauthority.userid)
	BEGIN
		SELECT VIEWFLAG = 'Y'
	END
	ELSE IF exists(select 1 from EAPPProgress inner join EAPPReceive on EAPPProgress.ID=EAPPReceive.ProgID inner join EAPPDocument on EAPPProgress.DocumentID=EAPPDocument.ID 
	where EAPPDocument.EDMSID=edmsgetauthority.edmsid and EAPPReceive.ReceiverID=edmsgetauthority.userid)
	BEGIN
		SELECT VIEWFLAG = 'Y'
	END
	ELSE IF(VIEWCOUNT <> 0) --권한이 있다면 권한테이블 조회
	BEGIN 	
		--권한이 사용자 정보와 맞는지 판단.
		IF	EXISTS(SELECT 1 FROM	EDMSAUTHUSER	WHERE DOCID = edmsgetauthority.edmsid		AND  USERID = edmsgetauthority.userid)
			OR	EXISTS(SELECT 1 FROM	EDMSAUTHDEPART	WHERE DOCID = edmsgetauthority.edmsid		AND  ORGCD = edmsgetauthority.departno)
		BEGIN
			SELECT 	VIEWFLAG = 'Y'
		END
		ELSE
		BEGIN
			if LEVEL = '0' OR LEVEL >= edmsgetauthority.authoritylevel
			begin
				SELECT 	VIEWFLAG = 'Y'
			end
			else
			begin
				SELECT 	VIEWFLAG = ''
			end
		END		
	END	
	ELSE IF(LEVEL = '0' OR LEVEL >= edmsgetauthority.authoritylevel) --전체공개이거나 유저의 권한등급보다 높은 등급의 문서라면 이후 분기 실행 A
	BEGIN
		SELECT 	VIEWFLAG = 'Y'
	END	
	ELSE		
	BEGIN
		SELECT 	VIEWFLAG = ''
	END	
	 
	if VIEWFLAG = 'Y' and AuthUser <> 'Y'
	begin
		
		if exists(select a.id from EDMSDocFolder f inner join EDMSTreeAuthority a on f.FolderID=a.FolderID where f.DocID=edmsgetauthority.edmsid)
		begin
			
			if not exists(select a.id from EDMSDocFolder f inner join EDMSTreeAuthority a on f.FolderID=a.FolderID where f.DocID=edmsgetauthority.edmsid and a.DepartID=edmsgetauthority.departno)
			BEGIN
				SELECT 	VIEWFLAG = ''
			END	
		end	
		
	end

	RETURN QUERY
	SELECT VIEWFLAG;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
