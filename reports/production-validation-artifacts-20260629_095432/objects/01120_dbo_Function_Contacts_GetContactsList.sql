-- ─── FUNCTION: contacts_getcontactslist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getcontactslist(integer, integer, integer, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_getcontactslist(
    reguserno integer,
    sidx integer,
    eidx integer,
    ts character varying,
    te character varying,
    search character varying,
    searchmode character varying,
    groupno integer
) RETURNS TABLE(
    userseq text
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




	SET PagingQry = 'SELECT ROWNUM, Seq, Name, Memo FROM
				(SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, Name, Memo FROM ContactsUser '

	SET CountQry = 'SELECT COUNT(*) CNT FROM ContactsUser '
	
	SET PARAM = 'P_RegUserNo INT,
	P_Sidx INT,
	P_Eidx INT,
	P_TS NVARCHAR(5),
	P_TE NVARCHAR(5),
	P_GroupNo INT'

		SET PagingQry += ' CU INNER JOIN ContactsGroupUser CG
				ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '

		SET CountQry += ' CU INNER JOIN ContactsGroupUser CG
				ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '
	
		IF TS = '' AND TE = ''
		BEGIN
			IF Mode = '0'
			BEGIN
				SET PagingQry += 'WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo))) PagingTable
				WHERE ROWNUM BETWEEN P_Sidx AND P_Eidx'
			END
			
			ELSE
			BEGIN
				SET CountQry += 'WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo))'
			END
		END
		ELSE
		
		BEGIN
			IF Mode = '0'
			BEGIN
				SET PagingQry += 'WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo)) AND
				Name BETWEEN P_TS AND P_TE) PagingTable WHERE ROWNUM BETWEEN P_Sidx AND P_Eidx'
			END

			ELSE
			BEGIN
				SET CountQry += 'WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo)) AND Name BETWEEN P_TS AND P_TE'
			END
		END	
		

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
				SET SearchTxt = ' AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE ''%' || Search || '%'')'

			END
			
			ELSE IF SearchMode = '2'
			BEGIN
				SET SearchTxt = ' AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE ''%' || Search || '%'')'
			END
			
			ELSE IF SearchMode = '3'
			BEGIN
				SET SearchTxt = ' AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE ''%' || Search || '%'')'
			END

			ELSE IF SearchMode = '4'
			BEGIN
				SET SearchTxt = ' AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE ''%' || Search || '%'')'
			END
			
			ELSE IF SearchMode = '5'
			BEGIN
				SET SearchTxt = ' AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE ''%' || Search || '%'')'
			END
			
			ELSE IF SearchMode = '6'
			BEGIN
				SET SearchTxt = ' AND Seq IN (SELECT UserSEq FROM ContactsGroupUser WHERE 
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE ''%' || Search || '%''))'
			END
			
			ELSE IF SearchMode = '7'
			BEGIN
				SET SearchTxt = ' AND Seq IN (SELECT UserSeq FROM ContactsGroup WHERE RegDate ILIKE ''%' || Search || '%'')'
			END
			
			ELSE IF SearchMode = '8'
			BEGIN
				SET SearchTxt = ' AND Seq IN (SELECT UserSeq FROM  WHERE Value ILIKE ''%' || Search || '%'')'
			END
			
			ELSE IF SearchMode = '9'
			BEGIN
				SET SearchTxt = ' AND Seq IN (SELECT UserSeq FROM  WHERE Value ILIKE ''%' || Search || '%'')'
			END
		END
			
		SET PagingQry += SearchTxt
		SET CountQry += SearchTxt	


	IF Mode = '0'
	BEGIN
		EXECUTE sp_executesql PagingQry,PARAM,P_RegUserNo = contacts_getcontactslist.reguserno,P_Sidx = contacts_getcontactslist.sidx,
		P_Eidx = contacts_getcontactslist.eidx,P_TS = contacts_getcontactslist.ts,P_TE = contacts_getcontactslist.te,P_GroupNo = contacts_getcontactslist.groupno
	END
	ELSE
	BEGIN
		EXECUTE sp_executesql CountQry,PARAM,P_RegUserNo = contacts_getcontactslist.reguserno,P_Sidx = contacts_getcontactslist.sidx,
		P_Eidx = contacts_getcontactslist.eidx,P_TS = contacts_getcontactslist.ts,P_TE = contacts_getcontactslist.te,P_GroupNo = contacts_getcontactslist.groupno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
