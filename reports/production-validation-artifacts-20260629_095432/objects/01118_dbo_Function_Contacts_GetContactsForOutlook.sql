-- ─── FUNCTION: contacts_getcontactsforoutlook ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getcontactsforoutlook();
CREATE OR REPLACE FUNCTION public.contacts_getcontactsforoutlook(
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
		COALESCE(CUO.OutlookEntryID,'') AS OutlookEntryID,
		COALESCE(CGO.OutlookFolderEntryID,'') AS FolderEntryID,
		COALESCE(CG.GroupNo,0) AS GroupNo,
		COALESCE(CG.GroupName,'') AS FolderName,
		CU.Seq,
		CU.FirstName,
		CU.LastName,
		CU.RegUserNo,
		COALESCE((SELECT /* TOP 1 */ Company FROM ContactsCompany CC WHERE CC.UserSeq = CU.Seq ORDER BY IsDefault DESC, Seq),'') As Company,
		COALESCE((SELECT /* TOP 1 */ Depart FROM ContactsCompany CC WHERE CC.UserSeq = CU.Seq ORDER BY IsDefault DESC, Seq),'') As Department,
		COALESCE((SELECT /* TOP 1 */ Position FROM ContactsCompany CC WHERE CC.UserSeq = CU.Seq ORDER BY IsDefault DESC, Seq),'') As Position,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsEmail CE WHERE CE.UserSeq = CU.Seq ORDER BY IsDefault DESC, seq),'') AS Email_01,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsEmail CE WHERE CE.UserSeq = CU.Seq AND CE.Seq NOT IN(SELECT /* TOP 1 */ Seq FROM ContactsEmail CE2 WHERE CE.UserSeq = CE2.UserSeq ORDER BY IsDefault DESC,Seq) ORDER BY IsDefault DESC,Seq),'') AS Email_02,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsEmail CE WHERE CE.UserSeq = CU.Seq AND CE.Seq NOT IN(SELECT /* TOP 2 */ Seq FROM ContactsEmail CE2 WHERE CE.UserSeq = CE2.UserSeq ORDER BY IsDefault DESC,Seq) ORDER BY IsDefault DESC,Seq),'') AS Email_03,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsNumber CN WHERE CN.UserSeq = CU.Seq AND CN.Type = '0' ORDER BY IsDefault DESC,Seq),'') AS MobileNumber,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsHomepage CH WHERE CH.UserSeq = CU.Seq ORDER BY IsDefault DESC, Seq),'') AS HomePage,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsSns CS WHERE CS.UserSeq = CU.Seq ORDER BY IsDefault DESC, Seq),'') AS Messenger,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsNumber CN WHERE CN.UserSeq = CU.Seq AND CN.Type = '1' ORDER BY IsDefault DESC,Seq),'') AS HomeTelNumber,
		COALESCE((SELECT /* TOP 1 */ ZipCode1 || '-' || ZipCode2 FROM ContactsAddress CA WHERE CA.UserSeq = CU.Seq AND CA.Type = '1' ORDER BY IsDefault DESC, Seq),'') AS HomeZipCode,
		COALESCE((SELECT /* TOP 1 */ Address FROM ContactsAddress CA WHERE CA.UserSeq = CU.Seq AND CA.Type = '1' ORDER BY IsDefault DESC, Seq),'') AS HomeAddr,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsNumber CN WHERE CN.UserSeq = CU.Seq AND CN.Type = '3' ORDER BY IsDefault DESC,Seq),'') AS HomeFaxNumber,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsNumber CN WHERE CN.UserSeq = CU.Seq AND CN.Type = '2' ORDER BY IsDefault DESC,Seq),'') AS CompanyTelNumber,
		COALESCE((SELECT /* TOP 1 */ ZipCode1 || '-' || ZipCode2 FROM ContactsAddress CA WHERE CA.UserSeq = CU.Seq AND CA.Type = '0' ORDER BY IsDefault DESC, Seq),'') AS CompanyZipCode,
		COALESCE((SELECT /* TOP 1 */ Address FROM ContactsAddress CA WHERE CA.UserSeq = CU.Seq AND CA.Type = '0' ORDER BY IsDefault DESC, Seq),'') AS CompanyAddr,
		COALESCE((SELECT /* TOP 1 */ Value FROM ContactsNumber CN WHERE CN.UserSeq = CU.Seq AND CN.Type = '8' ORDER BY IsDefault DESC,Seq),'') AS OtherTelNumber,
		COALESCE((SELECT /* TOP 1 */ ZipCode1 || '-' || ZipCode2 FROM ContactsAddress CA WHERE CA.UserSeq = CU.Seq AND CA.Type = '8' ORDER BY IsDefault DESC, Seq),'') AS OtherZipCode,
		COALESCE((SELECT /* TOP 1 */ Address FROM ContactsAddress CA WHERE CA.UserSeq = CU.Seq AND CA.Type = '8' ORDER BY IsDefault DESC, Seq),'') AS OtherAddr,
		CU.Memo
	FROM ContactsUser CU
	LEFT JOIN ContactsUserOutlook CUO ON CU.Seq = CUO.Seq
	INNER JOIN ContactsGroupUser CGU ON CU.Seq = CGU.UserSeq
	LEFT JOIN ContactsGroup CG ON CG.GroupNo = CGU.GroupNo
	LEFT JOIN ContactsGroupOutlook CGO ON CG.GroupNo = CGO.GroupNo
	WHERE CU.UseYn = 'Y'
	AND CU.RegUserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
