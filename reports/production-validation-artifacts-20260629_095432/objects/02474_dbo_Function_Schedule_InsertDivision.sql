-- ─── FUNCTION: schedule_insertdivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertdivision(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertdivision(
    name character varying,
    nameen character varying,
    namejp character varying,
    namech character varying,
    namevn character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN



	select row = count(*) from ScheduleDivisions
	if(row > 0)
	begin
		select maxOrder = MAX(SortOrder) from ScheduleDivisions
	end
	else
	begin
		select maxOrder = 1
	end
		 
	INSERT INTO ScheduleDivisions
	(
		Name,
		NameEn,
		NameJp,
		NameCh,
		NameVn,
		Color,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		SortOrder
	)
	VALUES
	(
		Name,
		NameEn,
		NameJp,
		NameCh,
		NameVn,
		Color,
		UserNo,
		NOW(),
		UserNo,
		NOW(),
		maxOrder
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
