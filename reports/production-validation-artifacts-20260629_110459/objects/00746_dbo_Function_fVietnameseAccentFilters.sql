-- ─── FUNCTION: fvietnameseaccentfilters ───────────────────────────────
DROP FUNCTION IF EXISTS public.fvietnameseaccentfilters();
CREATE OR REPLACE FUNCTION public.fvietnameseaccentfilters(
) RETURNS character varying
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    rt character varying;
    sign_chars character varying;
    unsign_chars character varying;
    counter integer;
    counter1 integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

 Set strInput=rtrim(ltrim(lower(strInput)))
    IF strInput IS NULL RETURN strInput
    IF strInput = '' RETURN strInput

    Set text='-''`~!@#$%^&*()?><:|}{,./\"''='';–'
    Select i= PATINDEX('%[' || text || ']%',strInput ) 
    while i > 0
        begin
         set strInput = replace(strInput, substring(strInput, i, 1), '')
         set i = patindex('%[' || text || ']%', strInput)
        End
        Set strInput =replace(strInput,'  ',' ')
        



    SET SIGN_CHARS = 'áàãảạăắằẵẳặâấầẫẩậóòõỏọôốồỗổộơớờỡởợéèẽẻẹêếềễểệúùũủụưứừữửựíìĩỉịýỳỹỷỵđ' || NCHAR(272) || NCHAR(208)
    SET UNSIGN_CHARS = 'aaaaaaaaaaaaaaaaaoooooooooooooooooeeeeeeeeeeeuuuuuuuuuuuiiiiiyyyyyd'


    SET COUNTER = 1
    WHILE (COUNTER <=LEN(strInput))
    BEGIN   
      SET COUNTER1 = 1
       WHILE (COUNTER1 <=LEN(SIGN_CHARS) || 1)
       BEGIN
     IF UNICODE(SUBSTRING(SIGN_CHARS, COUNTER1,1)) 
            = UNICODE(SUBSTRING(strInput,COUNTER ,1) )
     BEGIN           
          IF COUNTER=1
              SET strInput = SUBSTRING(UNSIGN_CHARS, COUNTER1,1) || SUBSTRING(strInput, COUNTER || 1,LEN(strInput)-1)                   
          ELSE
              SET strInput = SUBSTRING(strInput, 1, COUNTER-1) || SUBSTRING(UNSIGN_CHARS, COUNTER1,1) || SUBSTRING(strInput, COUNTER || 1,LEN(strInput)- COUNTER)
              BREAK
               END
             SET COUNTER1 = COUNTER1 || 1
       END
       SET COUNTER = COUNTER || 1
    End
 SET strInput = replace(strInput,' ',' ')
    RETURN lower(strInput);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
