-- ─── FUNCTION: work_getregularjournalcountforlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularjournalcountforlist(integer, integer, integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.work_getregularjournalcountforlist(
    userno integer,
    groupno integer,
    divisionno integer,
    searchtype integer,
    searchtext character varying,
    ismanager boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	IF IsManager = TRUE BEGIN
		
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND Title ILIKE '%' || SearchText || '%'
			
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
					AND Title ILIKE '%' || SearchText || '%'
				
			END
		
		END
	
	END

	ELSE IF IsDirector = TRUE BEGIN
		
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND Title ILIKE '%' || SearchText || '%'
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.GroupNo = work_getregularjournalcountforlist.groupno AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
					AND Title ILIKE '%' || SearchText || '%'
				
			END
		
		END
	
	END
	
	ELSE IF IsPerson = TRUE BEGIN
		
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.RegUserNo = work_getregularjournalcountforlist.userno AND RWJ.GroupNo = work_getregularjournalcountforlist.groupno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.RegUserNo = work_getregularjournalcountforlist.userno AND RWJ.GroupNo = work_getregularjournalcountforlist.groupno
					AND Title ILIKE '%' || SearchText || '%'
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.RegUserNo = work_getregularjournalcountforlist.userno AND RWJ.GroupNo = work_getregularjournalcountforlist.groupno
					AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkJournals RWJ
				WHERE RWJ.RegUserNo = work_getregularjournalcountforlist.userno AND RWJ.GroupNo = work_getregularjournalcountforlist.groupno
					AND RWJ.DivisionNo = work_getregularjournalcountforlist.divisionno
					AND Title ILIKE '%' || SearchText || '%'
				
			END
		
		END
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
