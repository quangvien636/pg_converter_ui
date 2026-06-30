-- ─── FUNCTION: eappparentlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappparentlist(integer);
CREATE OR REPLACE FUNCTION public.eappparentlist(
    docid integer
) RETURNS TABLE(
    docid integer,
    level integer
)
AS $function$
#variable_conflict use_column
DECLARE
    level integer;
    rootid integer;
    stack table  (item nvarchar(50);
BEGIN
 



	INSERT INTO stack VALUES (DocID, 1)
	
	SELECT level = 1

	WHILE level > 0
	BEGIN

		IF EXISTS (SELECT * FROM stack WHERE level = level)
	        BEGIN

		         SELECT DocID = item
		         FROM stack
		         WHERE level = level
			  
		         INSERT INTO ChildOrgan(DocID, Level)	 VALUES(DocID, level)

		         DELETE FROM stack
		         WHERE level = level
		         AND item = eappparentlist.docid
	
		 SELECT RootID=RootID FROM EAPPDocument WHERE ID = eappparentlist.docid

		         INSERT INTO stack VALUES(RootID,level + 1)
		        

		         IF RootID <> eappparentlist.docid
		            SELECT level = level + 1
		       END
		ELSE      
			SELECT level = level - 1

	END -- WHILE
	
	-- 순번 거꾸로...;
	UPDATE ChildOrgan 
		SET Level = (SELECT COUNT(*) + 1 FROM ChildOrgan WHERE Level > A.Level)	
	FROM  ChildOrgan AS A
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
