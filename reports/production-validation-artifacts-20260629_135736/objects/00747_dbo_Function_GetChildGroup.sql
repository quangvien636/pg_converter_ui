-- ─── FUNCTION: getchildgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.getchildgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.getchildgroup(
    reguserno integer,
    pgroupno integer
) RETURNS TABLE(
    treeid integer,
    level integer
)
AS $function$
#variable_conflict use_column
DECLARE
    level integer;
    stack table  (item int, level int);
BEGIN
	


	INSERT INTO stack VALUES (PGroupNo, 1)
	
	SELECT level = 1

	WHILE level > 0
	BEGIN
		IF EXISTS (SELECT * FROM stack WHERE level = level)
	    BEGIN
			SELECT PGroupNo = item FROM stack WHERE level = level		         ;
			INSERT INTO ChildTree(TreeID, Level) VALUES(PGroupNo, level)

		    DELETE FROM stack WHERE level = level AND item = getchildgroup.pgroupno

		    INSERT INTO stack SELECT GroupNo as child, level + 1
           	FROM ContactsGroup
            WHERE ParentGNo = getchildgroup.pgroupno and RegUserNo=getchildgroup.reguserno

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
	return;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
