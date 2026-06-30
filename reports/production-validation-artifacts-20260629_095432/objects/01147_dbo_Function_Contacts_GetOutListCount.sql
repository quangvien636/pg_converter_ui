-- ─── FUNCTION: contacts_getoutlistcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getoutlistcount(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getoutlistcount(
    grouplist character varying DEFAULT 'ALL'
) RETURNS TABLE(
    groupno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tabgroup table(groupno int);
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupList = 'ALL'
	BEGIN

		RETURN QUERY
		SELECT
			COUNT(U.Seq) AS CNT
		FROM ContactsUser U
		WHERE RegUserNo = UserNo
		AND UseYn = 'Y'
	END
	ELSE
	BEGIN

		SET GroupList = contacts_getoutlistcount.grouplist || ','
		
		WHILE STRPOS(',GroupList, ') > 0
		BEGIN

			SET GroupNo = SUBSTRING(GroupList,0,STRPOS(',GroupList, '))
			
			INSERT INTO tabGroup
			(
				GroupNo
			)
			VALUES
			(
				GroupNo
			)
			
			SET GroupList = SUBSTRING(GroupList,STRPOS(',GroupList, ')+1,LEN(GroupList))
		END
		 
		RETURN QUERY
		SELECT
			COUNT(U.Seq) AS CNT
		FROM ContactsUser U
		JOIN ContactsGroupUser G ON U.Seq = G.UserSeq
		WHERE U.RegUserNo = UserNo
		AND U.UseYn = 'Y'
		AND G.GroupNo IN (SELECT GroupNo FROM tabGroup)
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
