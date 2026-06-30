-- ─── PROCEDURE→FUNCTION: contacts_getoutlistcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_getoutlistcount(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getoutlistcount(
    IN grouplist character varying DEFAULT 'ALL'
) RETURNS SETOF record
AS $function$
DECLARE
    tabgroup table(groupno int);
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupList = 'ALL' THEN

		RETURN QUERY
		SELECT
			COUNT(U.Seq) AS CNT
		FROM ContactsUser U
		WHERE RegUserNo = UserNo
		AND UseYn = 'Y'
	END IF;
	ELSE

		GroupList := contacts_getoutlistcount.grouplist || ',';
		WHILE STRPOS(',GroupList, ') > 0 LOOP

			GroupNo := SUBSTRING(GroupList,0,STRPOS(',GroupList, '));;
			INSERT INTO tabGroup
			(
				GroupNo
			)
			VALUES
			(
				GroupNo
			)
			
			GroupList := SUBSTRING(GroupList,STRPOS(',GroupList, ')+1,LEN(GroupList));
		END LOOP;
		 
		RETURN QUERY
		SELECT
			COUNT(U.Seq) AS CNT
		FROM ContactsUser U
		JOIN ContactsGroupUser G ON U.Seq = G.UserSeq
		WHERE U.RegUserNo = UserNo
		AND U.UseYn = 'Y'
		AND G.GroupNo IN (SELECT GroupNo FROM tabGroup)
		
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
