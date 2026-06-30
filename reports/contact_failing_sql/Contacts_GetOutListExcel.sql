-- ─── PROCEDURE→FUNCTION: contacts_getoutlistexcel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_getoutlistexcel(integer, character varying, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.contacts_getoutlistexcel(
    IN userno integer DEFAULT 70,
    IN grouplist character varying DEFAULT '',
    IN sharelist character varying DEFAULT '0',
    IN publiclist character varying DEFAULT '',
    IN isadmin boolean DEFAULT TRUE
) RETURNS SETOF record
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

CREATE TEMP TABLE tabgroup (GroupNo integer) ON COMMIT DROP;
	GroupList := contacts_getoutlistexcel.grouplist || ',';
		WHILE STRPOS(',GroupList, ') > 0 LOOP

			GroupNo := SUBSTRING(GroupList,0,STRPOS(',GroupList, '));
			INSERT INTO tabGroup
			(
				GroupNo
			)
			VALUES
			(
				GroupNo
			);

			GroupList := SUBSTRING(GroupList,STRPOS(',GroupList, ')+1,LEN(GroupList));
		END LOOP
IF IsAdmin = TRUE THEN
		RETURN QUERY
		SELECT distinct
			Seq,
			LastName,
			CallName,
			FirstName,
			cellphone,
			companyphone,
			homephone,
			faxphone,
			Company,
			Position,
			Depart,
			Email,
			companyzipcode,
			companyaddress,
			homezipcode,
			homeaddress,
			homepage,
			ModDate,
			RegDate,
			CASE WHEN STRPOS(GroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(GroupName)  WHERE NAME='KO') ELSE GroupName END AS GroupName ,
			--GroupName,
			Memo,
			GroupId,
			RegUserNo,
			UseYn
		FROM
		(
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				gg.GroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			inner join (SELECT DISTINCT  M.GroupNo,G.UserSeq
					FROM  ContactsGroupUser G inner JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getoutlistexcel.userno) gg  ON gg.UserSeq = U.Seq
			WHERE
			U.UseYn = 'Y'
			AND gg.GroupNo IN (SELECT GroupNo FROM tabGroup)
			UNION  ALL
			SELECT
					U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.PublicGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_PublicGroupUser G ON U.Seq = G.UserSeq

			WHERE
			 SUBSTRING(U.Share,1,3)='300'
			AND U.UseYn = 'Y'
			AND COALESCE(G.PublicGroupNo,0) IN (SELECT * FROM Contacts_StringToListInt(PublicList))
			UNION  ALL
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.ShareGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_ShareGroupUser G ON U.Seq = G.UserSeq
			WHERE
			 --((U.RegUserNo=UserNo AND SUBSTRING(U.Share,1,3)='200')

				--or (SUBSTRING(U.Share,1,3)='200' AND (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_GetDepartmentsByUser(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			SUBSTRING(U.Share,1,3)='200'
			--AND U.RegUserNo <> UserNo
			AND U.UseYn = 'Y'
			AND COALESCE(G.ShareGroupNo,0) IN (SELECT * FROM Contacts_StringToListInt(ShareList))
		) A;

		ELSE




		RETURN QUERY
		SELECT distinct
			Seq,
			LastName,
			CallName,
			FirstName,
			cellphone,
			companyphone,
			homephone,
			faxphone,
			Company,
			Position,
			Depart,
			Email,
			companyzipcode,
			companyaddress,
			homezipcode,
			homeaddress,
			homepage,
			ModDate,
			RegDate,
			CASE WHEN STRPOS(GroupName, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(GroupName)  WHERE NAME='KO') ELSE GroupName END AS GroupName ,
			--GroupName,
			Memo,
			GroupId,
			RegUserNo,
			UseYn
		FROM
		(
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				gg.GroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			inner join (SELECT DISTINCT  M.GroupNo,G.UserSeq
					FROM  ContactsGroupUser G inner JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getoutlistexcel.userno) gg  ON gg.UserSeq = U.Seq
			WHERE
			U.UseYn = 'Y'
			AND gg.GroupNo IN (SELECT GroupNo FROM tabGroup)
			UNION  ALL
			SELECT
					U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.PublicGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_PublicGroupUser G ON U.Seq = G.UserSeq

			WHERE
			 SUBSTRING(U.Share,1,3)='300'
			AND U.UseYn = 'Y'
			AND COALESCE(G.PublicGroupNo,0) IN (SELECT * FROM Contacts_StringToListInt(PublicList))
			UNION  ALL
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.ShareGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_ShareGroupUser G ON U.Seq = G.UserSeq
			WHERE
			 ((U.RegUserNo=contacts_getoutlistexcel.userno AND SUBSTRING(U.Share,1,3)='200')

				or (SUBSTRING(U.Share,1,3)='200' AND (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = contacts_getoutlistexcel.userno))))
			--SUBSTRING(U.Share,1,3)='200'
			AND U.RegUserNo <> contacts_getoutlistexcel.userno
			AND U.UseYn = 'Y'
			AND COALESCE(G.ShareGroupNo,0) IN (SELECT * FROM Contacts_StringToListInt(ShareList))
		) A;
END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.