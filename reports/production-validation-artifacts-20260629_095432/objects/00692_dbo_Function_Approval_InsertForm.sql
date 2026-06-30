-- ─── FUNCTION: approval_insertform ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_insertform(integer, timestamp without time zone, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_insertform(
    reguserno integer,
    regdate timestamp without time zone,
    name character varying,
    categoryno integer,
    filetype integer
) RETURNS TABLE(
    formno text
)
AS $function$
DECLARE
    formno integer;
BEGIN


	INSERT INTO Approval_Forms (RegUserNo, RegDate, ModUserNo, ModDate, Name, CategoryNo, FileType, Description)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Name, CategoryNo, FileType, Description)


	SET FormNo = lastval()
	
	RETURN QUERY
	SELECT FormNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
