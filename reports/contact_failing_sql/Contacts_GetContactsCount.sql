-- ─── PROCEDURE→FUNCTION: contacts_getcontactscount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getcontactscount(integer, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_getcontactscount(
    IN reguserno integer,
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





	PagingQry := 'SELECT count(*) cnt FROM;
				(SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq,Name,Memo FROM ContactsUser';

	CountQry := 'SELECT COUNT(*) CNT FROM ContactsUser';
	PARAM := 'P_RegUserNo INT,;
	P_TS NVARCHAR(5),
	P_TE NVARCHAR(5),
	P_GroupNo INT';

	IF GroupNo > 0 THEN
		pagingqry := COALESCE(pagingqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		countqry := COALESCE(countqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		IF TS = '' AND TE = '' THEN
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo) PagingTable'), '');
			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo'), '');
			END IF;
		ELSE
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo AND
Name BETWEEN P_TS AND P_TE) PagingTable'), '');
			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo AND Name BETWEEN P_TS AND P_TE'), '');
			END IF;
		END IF;
	ELSE

		pagingqry := COALESCE(pagingqry, '') || COALESCE((' '), '');
		countqry := COALESCE(countqry, '') || COALESCE((' '), '');

		IF Search = '' THEN
			SearchTxt := '';
		ELSE
			IF SearchMode = '0' THEN
				SearchTxt := ' AND Name ILIKE ''%' || Search || '%''';
			ELSIF SearchMode = '1' THEN
				SearchTxt := '';
			ELSIF SearchMode = '2' THEN
				SearchTxt := '';
			ELSE
				SearchTxt := ' AND Memo ILIKE ''%' || Search || '%''';
			END IF;
		END IF;

		IF TS = '' AND TE = '' THEN
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo' || SearchTxt || ') PagingTable'), '');
			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo' || SearchTxt), '');
			END IF;
		ELSE
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo AND Name BETWEEN P_TS AND P_TE'), '');
				+ SearchTxt || ') PagingTable';
			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo AND Name BETWEEN P_TS AND P_TE'), '');
				 + SearchTxt;
			END IF;
		END IF;
	END IF;

	IF Mode = '0' THEN
		PERFORM sp_executesql(PagingQry,PARAM,RegUserNo);
		P_TS = contacts_getcontactscount.ts,P_TE = contacts_getcontactscount.te,P_GroupNo = contacts_getcontactscount.groupno;
	ELSE
		PERFORM sp_executesql(CountQry,PARAM,RegUserNo);
		P_TS = contacts_getcontactscount.ts,P_TE = contacts_getcontactscount.te,P_GroupNo = contacts_getcontactscount.groupno;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.