-- ─── FUNCTION: note_getdepartments ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getdepartments(integer);
CREATE OR REPLACE FUNCTION public.note_getdepartments(
    parentno integer
) RETURNS TABLE(
    departno serial,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer,
    name character varying(100),
    name_en character varying(100),
    shortname character varying(100),
    sortno integer,
    enabled boolean,
    name_ch character varying(200),
    name_jp character varying(200),
    name_vn character varying(200),
    sendername character varying(100)
)
AS $function$
BEGIN

	IF ParentNo=-1
		BEGIN
			RETURN QUERY
			SELECT * FROM Organization_Departments
			WHERE Enabled = TRUE

		END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT * FROM Organization_Departments
	WHERE ParentNo=note_getdepartments.parentno AND Enabled = TRUE

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
