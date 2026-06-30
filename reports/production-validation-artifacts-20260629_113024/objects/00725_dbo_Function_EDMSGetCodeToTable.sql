-- ─── FUNCTION: edmsgetcodetotable ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetcodetotable(character varying);
CREATE OR REPLACE FUNCTION public.edmsgetcodetotable(
    strcodelist character varying
) RETURNS TABLE(
    idx integer,
    code character varying
)
-- TODO: LEN was not fully converted; use length()
AS $function$
#variable_conflict use_column
DECLARE
    npos integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	


	,	cnt		INT

	SET cnt = 0

	while strCodeList <> ''
	begin
		set nPos = STRPOS(strCodeList, strDivChar)
		
		if nPos = 0 
		begin
			if strCodeList <> ''
			begin
				set sCode =  edmsgetcodetotable.strcodelist
				set strCodeList = ''
			end
			else
				set sCode = null
		end
		else
		begin
			set sCode = left(strCodeList, nPos - 1)
			set strCodeList = substring(strCodeList, nPos + 1, len(strCodeList) - nPos)
		end

		if sCode is not null
		begin
			set cnt = cnt + 1;
			insert into tmpTable values(cnt, sCode)

		end

	end
	
	return;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
