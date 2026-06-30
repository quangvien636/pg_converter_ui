-- ─── FUNCTION: eappgetoperationsender ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetoperationsender(integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappgetoperationsender(
    docid integer,
    userid character varying,
    departid character varying,
    mode character varying DEFAULT '0'
) RETURNS boolean
AS $function$
BEGIN

	
	if Mode = '1'
		begin
			if exists (select id from eappdocument where id=eappgetoperationsender.docid and writerid=eappgetoperationsender.userid)
			begin	
				return 1
			end
			else
			begin
				return 0	
			end
		end
		else
		begin
			if exists (select d.id from eappdocument d inner join eappprogress p on d.id=p.documentid where d.id=eappgetoperationsender.docid and (d.writerid=eappgetoperationsender.userid or p.managerid=eappgetoperationsender.userid or (authoritylevel=200 and d.departid=eappgetoperationsender.departid)))
			begin	
				return 1
			end
			else
			begin
				return 0	
			end
		end
		
		return 0;
--	DECLARE DocWriterID	nvarchar(50)
--	DECLARE DocDepartID	nvarchar(50)
--	DECLARE DocAuth		int
--	SELECT DocWriterID=WriterID,DocDepartID=DepartID,DocAuth=AuthorityLevel FROM EAPPDocument WHERE ID=DocID
--	IF DocWriterID=UserID RETURN 1

--	DECLARE count int
--	SET count=0

--	SELECT count=count(ID) FROM EAPPProgress WHERE DocumentID=DocID AND ManagerID=UserID
--	IF count>0 RETURN 1
	
--	SELECT count=count(r.ID) FROM EAPPReceive r 
--	INNER JOIN EAPPProgress p ON r.progid=p.id
--	WHERE p.DocumentID=DocID AND r.ReceiverID=UserID
--	IF count>0 RETURN 1

--	IF DocAuth=100 RETURN 0
--	ELSE IF DocDepartID=DepartID RETURN 1
		
--	RETURN 0
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
