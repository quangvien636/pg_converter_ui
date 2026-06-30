-- ─── FUNCTION: contacts_getcontactscount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getcontactscount(integer, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_getcontactscount(
    reguserno integer,
    ts character varying,
    te character varying,
    search character varying,
    searchmode character varying,
    groupno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
AS $function$
DECLARE
    pagingqry character varying;
    countqry character varying;
    param character varying;
    searchtxt character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SET PagingQry = 'SELECT count(*) cnt FROM
				(SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq,Name,Memo FROM ContactsUser'

	SET CountQry = 'SELECT COUNT(*) CNT FROM ContactsUser'
	
	SET PARAM = 'P_RegUserNo INT,
	P_TS NVARCHAR(5),
	P_TE NVARCHAR(5),
	P_GroupNo INT'

	IF GroupNo > 0
	BEGIN
		SET PagingQry += ' CU INNER JOIN ContactsGroupUser CG
				ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '

		SET CountQry += ' CU INNER JOIN ContactsGroupUser CG
				ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '
	
		IF TS = '' AND TE = ''
		BEGIN
			IF Mode = '0'
			BEGIN
				SET PagingQry += 'WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo) PagingTable'
			END
			ELSE
			BEGIN
				SET CountQry += 'WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo'
			END
		END
		ELSE
		BEGIN
			IF Mode = '0'
			BEGIN
				SET PagingQry += 'WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo AND
				Name BETWEEN P_TS AND P_TE) PagingTable'
			END
			ELSE
			BEGIN
				SET CountQry += 'WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo AND Name BETWEEN P_TS AND P_TE'
			END
		END	
	END
	ELSE
	BEGIN

		SET PagingQry += ' '
		SET CountQry += ' '		
	
		IF Search = ''
		BEGIN
			SET SearchTxt = ''
		END
		ELSE
		BEGIN			
			IF SearchMode = '0'
			BEGIN
				SET SearchTxt = ' AND Name ILIKE ''%' || Search || '%'''
			END
			ELSE IF SearchMode = '1'
			BEGIN
				SET SearchTxt = ''
			END
			ELSE IF SearchMode = '2'
			BEGIN
				SET SearchTxt = ''
			END
			ELSE
			BEGIN
				SET SearchTxt = ' AND Memo ILIKE ''%' || Search || '%'''
			END
		END
	
		IF TS = '' AND TE = ''
		BEGIN
			IF Mode = '0'
			BEGIN
				SET PagingQry += 'WHERE RegUserNo=P_RegUserNo' || SearchTxt || ') PagingTable'
			END
			ELSE
			BEGIN
				SET CountQry += 'WHERE RegUserNo=P_RegUserNo' || SearchTxt
			END
		END
		ELSE
		BEGIN
			IF Mode = '0'
			BEGIN
				SET PagingQry += 'WHERE RegUserNo=P_RegUserNo AND Name BETWEEN P_TS AND P_TE' || SearchTxt || ') PagingTable'
			END
			ELSE
			BEGIN
				SET CountQry += 'WHERE RegUserNo=P_RegUserNo AND Name BETWEEN P_TS AND P_TE' || SearchTxt
			END
		END
	END
	
	IF Mode = '0'
	BEGIN
		EXECUTE sp_executesql PagingQry,PARAM,P_RegUserNo = contacts_getcontactscount.reguserno,
		P_TS = contacts_getcontactscount.ts,P_TE = contacts_getcontactscount.te,P_GroupNo = contacts_getcontactscount.groupno
	END
	ELSE
	BEGIN
		EXECUTE sp_executesql CountQry,PARAM,P_RegUserNo = contacts_getcontactscount.reguserno,
		P_TS = contacts_getcontactscount.ts,P_TE = contacts_getcontactscount.te,P_GroupNo = contacts_getcontactscount.groupno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
