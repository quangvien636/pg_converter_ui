-- ─── FUNCTION: eappgetorganchild ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetorganchild();
CREATE OR REPLACE FUNCTION public.eappgetorganchild(
) RETURNS TABLE(
    departno integer,
    departpath character varying,
    level integer
)
AS $function$
#variable_conflict use_column
DECLARE
    level integer;
    stack table  (item int, name nvarchar(3000);
BEGIN
 

	


	-- 테이블변수

	
	select Name=Name from Organization_Departments where DepartNo=DepartNo	;
	INSERT INTO stack VALUES (DepartNo, Name, 1)
		
	
	SELECT level = 1


	WHILE level > 0
	BEGIN

		IF EXISTS (SELECT * FROM stack WHERE level = level)
	        BEGIN

		         SELECT DepartNo = item, Name=Name
		         FROM stack
		         WHERE level = level
			  
			  INSERT INTO ChildOrgan(DepartNo, DepartPath, Level) VALUES(DepartNo, Name, level)

		         DELETE FROM stack
		         WHERE level = level
		         AND item = DepartNo

		         INSERT INTO stack
		         RETURN QUERY
		         SELECT DepartNo,Name || '-' || Name, level + 1
	            	  FROM Organization_Departments
            		  WHERE ParentNo = DepartNo and Enabled='1' order by SortNo

		         IF @ROWCOUNT > 0
		            SELECT level = level + 1
		       END
		ELSE      
			SELECT level = level - 1

	END -- WHILE


	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
