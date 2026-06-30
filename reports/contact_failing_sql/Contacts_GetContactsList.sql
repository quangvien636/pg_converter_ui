-- ─── PROCEDURE→FUNCTION: contacts_getcontactslist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getcontactslist(integer, integer, integer, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_getcontactslist(
    IN reguserno integer,
    IN sidx integer,
    IN eidx integer,
    IN ts character varying,
    IN te character varying,
    IN search character varying,
    IN searchmode character varying,
    IN groupno integer
) RETURNS SETOF record
AS $function$
DECLARE
    pagingqry character varying;
    countqry character varying;
    param character varying;
    searchtxt character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	PagingQry := 'SELECT ROWNUM, Seq, Name, Memo FROM;
				(SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, Name, Memo FROM ContactsUser ';

	CountQry := 'SELECT COUNT(*) CNT FROM ContactsUser ';
	PARAM := 'P_RegUserNo INT,;
	P_Sidx INT,
	P_Eidx INT,
	P_TS NVARCHAR(5),
	P_TE NVARCHAR(5),
	P_GroupNo INT';

		pagingqry := COALESCE(pagingqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		countqry := COALESCE(countqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		IF TS = '' AND TE = '' THEN
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo))) PagingTable
WHERE ROWNUM BETWEEN P_Sidx AND P_Eidx'), '');

			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo))'), '');
			END IF;
		ELSE

			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo)) AND
Name BETWEEN P_TS AND P_TE) PagingTable WHERE ROWNUM BETWEEN P_Sidx AND P_Eidx'), '');

			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo)) AND Name BETWEEN P_TS AND P_TE'), '');
			END IF;
		END IF;



		IF Search = '' THEN
			SearchTxt := '';
		ELSE
			IF SearchMode = '0' THEN
				SearchTxt := ' AND Name ILIKE ''%' || Search || '%''';
			ELSIF SearchMode = '1' THEN
				SearchTxt := ' AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '2' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '3' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '4' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '5' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '6' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSEq FROM ContactsGroupUser WHERE;
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE ''%' || Search || '%''))';

			ELSIF SearchMode = '7' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsGroup WHERE RegDate ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '8' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM  WHERE Value ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '9' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM  WHERE Value ILIKE ''%' || Search || '%'')';
			END IF;
		END IF;

		pagingqry := COALESCE(pagingqry, '') || COALESCE((SearchTxt), '');
		countqry := COALESCE(countqry, '') || COALESCE((SearchTxt), '');


	IF Mode = '0' THEN
		PERFORM sp_executesql(PagingQry,PARAM,RegUserNo,Sidx);
		P_Eidx = contacts_getcontactslist.eidx,P_TS = contacts_getcontactslist.ts,P_TE = contacts_getcontactslist.te,P_GroupNo = contacts_getcontactslist.groupno;
	ELSE
		PERFORM sp_executesql(CountQry,PARAM,RegUserNo,Sidx);
		P_Eidx = contacts_getcontactslist.eidx,P_TS = contacts_getcontactslist.ts,P_TE = contacts_getcontactslist.te,P_GroupNo = contacts_getcontactslist.groupno;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.