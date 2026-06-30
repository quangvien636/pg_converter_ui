-- ─── FUNCTION: edmsgettreechild ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgettreechild(character varying, character varying);
CREATE OR REPLACE FUNCTION public.edmsgettreechild(
    treeid character varying,
    divid character varying
) RETURNS TABLE(
    treeid character varying,
    level integer
)
AS $function$
#variable_conflict use_column
DECLARE
    level integer;
BEGIN

	if mode = '1'
	BEGIN

		
		INSERT INTO stack VALUES (treeid, 1)
	
		SELECT level = 1

		WHILE level > 0
		BEGIN
			IF EXISTS (SELECT * FROM stack WHERE level = level)
	        BEGIN
				SELECT treeid = item FROM stack WHERE level = level		         ;
				INSERT INTO ChildTree(TreeID, Level)	 VALUES(treeid, level)

		        DELETE FROM stack WHERE level = level AND item = edmsgettreechild.treeid

		        INSERT INTO stack SELECT ID as child, level + 1
           		FROM EDMSTreeItem
            	WHERE ParentID = edmsgettreechild.treeid and divid=edmsgettreechild.divid and UseYn='Y'

		        IF @ROWCOUNT > 0
		        BEGIN
		            SELECT level = level + 1
		        END
		    END
			ELSE
			BEGIN
				SELECT level = level - 1
			END
		END
	END
	ELSE
	BEGIN;
		INSERT INTO ChildTree(TreeID, Level)	 VALUES(treeid, 1)
	END
	return;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
