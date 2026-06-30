-- ─── FUNCTION: uf_contactsdetailexcel ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_contactsdetailexcel();
CREATE OR REPLACE FUNCTION public.uf_contactsdetailexcel(
) RETURNS character varying
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    rtn character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- Declare the return variable here

	-- Add the T-SQL statements to compute the return value here
	IF Type = 'email'
		SELECT /* TOP 1 */ RTN = Value FROM ContactsEmail WHERE UserSeq = UserSeq ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'cellphone'
		SELECT /* TOP 1 */ RTN = Value FROM ContactsNumber WHERE UserSeq = UserSeq AND Type=0 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type='companyphone'
		SELECT /* TOP 1 */ RTN = Value FROM ContactsNumber WHERE UserSeq = UserSeq AND Type=2 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type='homephone'
		SELECT /* TOP 1 */ RTN = Value FROM ContactsNumber WHERE UserSeq = UserSeq AND Type=1 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type='faxphone'
		SELECT /* TOP 1 */ RTN = Value FROM ContactsNumber WHERE UserSeq = UserSeq AND Type=3 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'company'
		SELECT /* TOP 1 */ RTN = Company FROM ContactsCompany WHERE UserSeq = UserSeq ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'depart'
		SELECT /* TOP 1 */ RTN = Depart FROM ContactsCompany WHERE UserSeq = UserSeq ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'position'
		SELECT /* TOP 1 */ RTN = Position FROM ContactsCompany WHERE UserSeq = UserSeq ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'companyzipcode'
		SELECT /* TOP 1 */ RTN = (ZipCode1 || '-' || ZipCode2)  FROM ContactsAddress WHERE UserSeq = UserSeq AND ZipCode1!='' AND Type=0 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'companyaddress'
		SELECT /* TOP 1 */ RTN = Address  FROM ContactsAddress WHERE UserSeq = UserSeq AND Type=0 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'homezipcode'
		SELECT /* TOP 1 */ RTN = (ZipCode1 || '-' || ZipCode2)  FROM ContactsAddress WHERE UserSeq = UserSeq AND ZipCode1!='' AND Type=1 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'homeaddress'
		SELECT /* TOP 1 */ RTN = Address  FROM ContactsAddress WHERE UserSeq = UserSeq AND Type=1 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'homepage'
		SELECT /* TOP 1 */ RTN = Value  FROM ContactsHomepage WHERE UserSeq = UserSeq AND Type=0 ORDER BY IsDefault DESC, Seq ASC
	ELSE IF Type = 'group'	
	BEGIN
		SELECT /* TOP 1 */ RTN = GroupName FROM ContactsGroup G 
		LEFT JOIN ContactsGroupUser U ON G.GroupNo = U.GroupNo
		WHERE U.UserSeq = UserSeq
		ORDER BY IsDefault DESC, Seq ASC
	END
	-- Return the result of the function
	RETURN RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
