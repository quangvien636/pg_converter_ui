-- ─── FUNCTION: schedule_movedivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_movedivision(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_movedivision(
    mode character varying,
    curridx integer,
    moveidx integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*With cte As
	(
		SELECT SortOrder,
		ROW_NUMBER() OVER (ORDER BY COALESCE(SortOrder,0) ASC) AS RN
		FROM ScheduleDivisions 
	);
	UPDATE cte SET SortOrder=RN;
	*/
	IF Mode = 'UF'
	BEGIN

		select min = MIN(SortOrder) from ScheduleDivisions

		UPDATE ScheduleDivisions
		SET SortOrder = min
		WHERE DivisionNo = DivisionNo

		UPDATE ScheduleDivisions SET SortOrder = SortOrder + 1
		WHERE DivisionNo <> DivisionNo and SortOrder >= min
	END
	IF Mode = 'U'
	BEGIN



		select SortOrderOld1 = SortOrder from ScheduleDivisions
		where DivisionNo = DivisionNo

		RETURN QUERY
		select /* TOP 1 */ s1 = SortOrder, no1 = DivisionNo from ScheduleDivisions 
		where SortOrder < SortOrderOld1
		order by SortOrder desc   
		if(no1 != 0)
		begin;
			UPDATE ScheduleDivisions
			SET	SortOrder = s1
			WHERE DivisionNo = DivisionNo

			UPDATE ScheduleDivisions
			SET	SortOrder = SortOrderOld1
			WHERE DivisionNo = no1	
		end


	END
	IF Mode = 'D'
	BEGIN



		select SortOrderOld = SortOrder from ScheduleDivisions
		where DivisionNo = DivisionNo

		RETURN QUERY
		select /* TOP 1 */ s = SortOrder, no = DivisionNo from ScheduleDivisions 
		where SortOrder > SortOrderOld
		order by SortOrder asc   
		if(no != 0)
		begin;
			UPDATE ScheduleDivisions
			SET	SortOrder = s
			WHERE DivisionNo = DivisionNo

			UPDATE ScheduleDivisions
			SET	SortOrder = SortOrderOld
			WHERE DivisionNo = no
		end
	END
	IF Mode = 'DL'
	BEGIN;
		UPDATE ScheduleDivisions
		SET	SortOrder = SortOrder - 1
		where SortOrder > 1
				
		UPDATE ScheduleDivisions
		SET	SortOrder = (SELECT COUNT(DivisionNo) FROM ScheduleDivisions)
		WHERE DivisionNo = DivisionNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
