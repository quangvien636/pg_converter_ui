-- ─── FUNCTION: edmsgetstorefolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetstorefolder(character varying, integer);
CREATE OR REPLACE FUNCTION public.edmsgetstorefolder(
    userid character varying,
    docid integer
) RETURNS character varying
AS $function$
DECLARE
    folderid character varying;
    foldername character varying;
    divid character varying;
BEGIN






	

	
	SELECT FolderID=FolderID
	FROM EDMSPrivateDoc
	WHERE UserID=edmsgetstorefolder.userid AND DocID=edmsgetstorefolder.docid
	
	SELECT divid=divid
	FROM EDMSDocFolder
	WHERE DocID=edmsgetstorefolder.docid

	IF FolderID<>0
	 BEGIN
		SELECT FolderName=ItemNm1
		FROM EDMSTreeItem
		WHERE ID=FolderID and DivID=divid
	 END


	RETURN	(FolderID || ',' || FolderName);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
