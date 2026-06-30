-- ─── FUNCTION: wfaxgetfaxboxparent ───────────────────────────────
DROP FUNCTION IF EXISTS public.wfaxgetfaxboxparent();
CREATE OR REPLACE FUNCTION public.wfaxgetfaxboxparent(
) RETURNS TABLE(
    faxboxcd character varying,
    level integer
)
AS $function$
#variable_conflict use_column
BEGIN
 

	


	-- 테이블변수

	
		
	INSERT INTO stack VALUES (FaxBoxCd, 1)
	
	SELECT level = 1


	WHILE level > 0
	BEGIN

		IF EXISTS (SELECT * FROM stack WHERE level = level)
	        BEGIN

		         SELECT FaxBoxCd = item
		         FROM stack
		         WHERE level = level

		         --SELECT line = space(level - 1) + MailBoxCd
		         --PRINT line
			  
			  INSERT INTO ChildOrgan(FaxBoxCd, Level)	 VALUES(FaxBoxCd, level)

		         DELETE FROM stack
		         WHERE level = level
		         AND item = FaxBoxCd

		         INSERT INTO stack
		         RETURN QUERY
		         SELECT ParentFaxBoxCd as parent, level + 1
	            	  FROM WFAXBox
            		  WHERE FaxBoxCd = FaxBoxCd
					  AND ParentFaxBoxCd > '0000' 

		         IF @ROWCOUNT > 0
		            SELECT level = level + 1
		       END
		ELSE      
			SELECT level = level - 1

	END -- WHILE


	-- 순번 거꾸로...;
	UPDATE ChildOrgan 
		SET Level = (SELECT COUNT(*) + 1 FROM ChildOrgan WHERE Level > A.Level)	
	FROM  ChildOrgan AS A
		
		
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
