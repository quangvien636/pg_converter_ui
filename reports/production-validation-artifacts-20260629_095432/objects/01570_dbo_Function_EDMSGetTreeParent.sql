-- ─── FUNCTION: edmsgettreeparent ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgettreeparent(character varying);
CREATE OR REPLACE FUNCTION public.edmsgettreeparent(
    treeid character varying
) RETURNS TABLE(
    treeid character varying,
    level integer
)
AS $function$
#variable_conflict use_column
DECLARE
    level integer;
    stack table  (item varchar(100);
BEGIN
 
	IF(treeid IS NULL) -- 최은상 수정 (무한루프 방지)
		RETURN
	-- 최상위 계열사 코드가 나타날때까지 INSERT
	


	-- 테이블변수

	
		
	INSERT INTO stack VALUES (treeid, 1)
	
	SELECT level = 1


	WHILE level > 0
	BEGIN

		IF EXISTS (SELECT * FROM stack WHERE level = level)
	        BEGIN

		         SELECT treeid = item
		         FROM stack
		         WHERE level = level

		         --SELECT line = space(level - 1) + treeid
		         --PRINT line
			  
			  INSERT INTO ParentTree(TreeID, Level)	 VALUES(treeid, level)

		         DELETE FROM stack
		         WHERE level = level
		         AND item = edmsgettreeparent.treeid

		         INSERT INTO stack
		         RETURN QUERY
		         SELECT ParentID as parent, level + 1
	            	  FROM EDMSTreeItem
            		  WHERE cast(ID as varchar) = edmsgettreeparent.treeid and DivID=divid and UseYn='Y'

		         IF @ROWCOUNT > 0
		            SELECT level = level + 1
		       END
		ELSE      
			SELECT level = level - 1

	END -- WHILE



      --delete from ParentTree  where TreeID = '0'
	-- 순번 거꾸로...;
	UPDATE ParentTree 
		SET Level = (SELECT COUNT(*) + 1 FROM ParentTree WHERE Level > A.Level)	
	FROM  ParentTree AS A
		
		
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
