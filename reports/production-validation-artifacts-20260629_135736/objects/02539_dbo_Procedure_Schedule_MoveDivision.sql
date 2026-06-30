-- ─── PROCEDURE→FUNCTION: schedule_movedivision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_movedivision(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_movedivision(
    IN mode character varying,
    IN curridx integer,
    IN moveidx integer
) RETURNS SETOF record
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
	IF Mode = 'UF' THEN

		SELECT MIN(SortOrder) INTO min from ScheduleDivisions

		UPDATE ScheduleDivisions
		SortOrder := min;
		WHERE DivisionNo = DivisionNo

		UPDATE ScheduleDivisions SET SortOrder = SortOrder + 1
		WHERE DivisionNo <> DivisionNo and SortOrder >= min
	END IF;
	IF Mode = 'U' THEN



		SELECT SortOrder INTO sortorderold1 from ScheduleDivisions
		where DivisionNo = DivisionNo

		RETURN QUERY
		select /* TOP 1 */ s1 = SortOrder, no1 = DivisionNo from ScheduleDivisions 
		where SortOrder < SortOrderOld1
		order by SortOrder desc   
		if(no1 != 0)
		begin;
			UPDATE ScheduleDivisions
			SortOrder := s1;
			WHERE DivisionNo = DivisionNo

			UPDATE ScheduleDivisions
			SortOrder := SortOrderOld1;
			WHERE DivisionNo = no1	
		END;


	END IF;
	IF Mode = 'D' THEN



		SELECT SortOrder INTO sortorderold from ScheduleDivisions
		where DivisionNo = DivisionNo

		RETURN QUERY
		select /* TOP 1 */ s = SortOrder, no = DivisionNo from ScheduleDivisions 
		where SortOrder > SortOrderOld
		order by SortOrder asc   
		if(no != 0)
		begin;
			UPDATE ScheduleDivisions
			SortOrder := s;
			WHERE DivisionNo = DivisionNo

			UPDATE ScheduleDivisions
			SortOrder := SortOrderOld;
			WHERE DivisionNo = no
		END;
	END IF;
	IF Mode = 'DL' THEN;
		UPDATE ScheduleDivisions
		SortOrder := SortOrder - 1;
		where SortOrder > 1
				
		UPDATE ScheduleDivisions
		SortOrder := (SELECT COUNT(DivisionNo) FROM ScheduleDivisions);
		WHERE DivisionNo = DivisionNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
