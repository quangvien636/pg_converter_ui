-- ─── FUNCTION: center_googleotp_select_list ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_googleotp_select_list(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.center_googleotp_select_list(
    userid character varying,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    rownum text,
    userid text,
    otpsetupkey text,
    qrcodesetupimageurl text,
    manualentrykey text,
    regdate text
)
AS $function$
DECLARE
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
BEGIN

	




	SET TotalItemCount = (SELECT COUNT(*) FROM Center_GoogleOTPInfo
	WHERE Center_GoogleOTPInfo.UserID ILIKE '%' || UserID || '%')
	
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = center_googleotp_select_list.currentpageindex * CountPerPage
	
	RETURN QUERY
	SELECT 
	ROWNUM
	,UserID
	,OTPSetUpKey
	,QrCodeSetupImageUrl
	,ManualEntryKey
	,RegDate
	FROM (
	SELECT 
	ROW_NUMBER() OVER (ORDER BY RegDate desc) AS ROWNUM
	,UserID
	,OTPSetUpKey
	,QrCodeSetupImageUrl
	,ManualEntryKey
	,RegDate
	FROM Center_GoogleOTPInfo
	WHERE Center_GoogleOTPInfo.UserID ILIKE '%' || UserID || '%'
	) V
	WHERE V.RowNum BETWEEN StartRowNum AND EndRowNum
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalOTPCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
