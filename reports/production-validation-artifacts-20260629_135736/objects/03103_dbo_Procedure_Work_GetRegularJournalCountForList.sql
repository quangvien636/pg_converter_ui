-- ─── PROCEDURE→FUNCTION: work_getregularjournalcountforlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getregularjournalcountforlist(integer, integer, integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.work_getregularjournalcountforlist(
    IN userno integer,
    IN groupno integer,
    IN divisionno integer,
    IN searchtype integer,
    IN searchtext character varying,
    IN ismanager boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsManager = TRUE THEN
		
		IF DivisionNo = 0 THEN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND Title ILIKE '%' || SearchText || '%'
			
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
					AND Title ILIKE '%' || SearchText || '%'
				
			END IF;
		
		END IF;
	
	END;

	ELSIF IsDirector = TRUE THEN
		
		IF DivisionNo = 0 THEN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND Title ILIKE '%' || SearchText || '%'
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
					AND Title ILIKE '%' || SearchText || '%'
				
			END IF;
		
		END IF;
	
	END;
	
	ELSIF IsPerson = TRUE THEN
		
		IF DivisionNo = 0 THEN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.RegUserNo = work_getregularjournalcountforlist.userno AND RWJ.GroupNo = work_getregularjournalcountforlist.groupno
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.RegUserNo = work_getregularjournalcountforlist.userno AND RWJ.GroupNo = work_getregularjournalcountforlist.groupno
					AND Title ILIKE '%' || SearchText || '%'
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.RegUserNo = work_getregularjournalcountforlist.userno AND RWJ.GroupNo = work_getregularjournalcountforlist.groupno
					AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.RegUserNo = work_getregularjournalcountforlist.userno AND RWJ.GroupNo = work_getregularjournalcountforlist.groupno
					AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
					AND Title ILIKE '%' || SearchText || '%'
				
			END IF;
		
		END IF;
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
