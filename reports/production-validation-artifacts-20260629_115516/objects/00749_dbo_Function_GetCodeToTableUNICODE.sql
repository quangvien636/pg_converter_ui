-- ─── FUNCTION: getcodetotableunicode ───────────────────────────────
DROP FUNCTION IF EXISTS public.getcodetotableunicode(character varying);
CREATE OR REPLACE FUNCTION public.getcodetotableunicode(
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
		select nPos = public."UNICODE_CNT"(strCodeList)		
		if nPos = 0 
		begin
			if strCodeList <> ''
			begin
				set sCode =  getcodetotableunicode.strcodelist
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
			insert into tmpTable values(cnt, RTRIM(LTRIM(sCode)))

		end

	end
	
	return;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
