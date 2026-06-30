-- ─── PROCEDURE→FUNCTION: edmstreeitemchange ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmstreeitemchange(character varying);
CREATE OR REPLACE FUNCTION public.edmstreeitemchange(
    IN userid character varying
) RETURNS SETOF record
AS $function$
DECLARE
    parentid character varying;
    selectparentid character varying;
    selectidsortno character varying;
    sortno character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*
	exec EDMSTreeItemChange PARENTid='10',SELECTid='12',divid='1',check='1',UserId='0408004'
	RETURN QUERY
	select * from EDMSTreeItem order by divid , parentid desc

	,	divid		varchar(20)
	,	check		varchar(1)		--0 : 동일레벨의 폴더를 다 이동시킨다. 1 : 본인 폴더만 이동.
	,	UserId		varchar(500)
	PARENTid := ('10');
	,	SELECTid='12'
	,	divid='4'
	,	check='1'
	,	UserId='0408004'
--*/


/***********************************************************************************************************************
--	필요변수 셋팅 시작
***********************************************************************************************************************/

	--현재그룹의 부모값을 받는다.

	FROM	EDMSTreeItem
	WHERE	ID = SELECTid and DivID=divid

	--현재 아이디의 소트넘버를 불른다.

	FROM	EDMSTREEITEM
	WHERE	ID = SELECTid and DivID=divid

	--이동될 부모값의 최종 소팅 넘버를 뽑는다.

	FROM	EDMSTreeItem
	WHERE	PARENTID = PARENTID	
	and		divId	= divId
	and (( DIVID = '4' AND 	UserId	=	edmstreeitemchange.userid)	
				OR DIVID IN ('1','2') ) 


/***********************************************************************************************************************
--	필요변수 셋팅 끝
***********************************************************************************************************************/
	--동일레벨의 폴더를 다이동 시키고 변경될폴더의 부모가 최상위 폴더라면 이동을 불가능 하게 한다.
	IF(check = '0' AND SELECTPARENTID = '0')
	BEGIN
		RETURN QUERY
		SELECT '0'
	END;
	ELSE--부모가될값 의 부모중에 자식이될값이 있는지 확인한다.	
	IF EXISTS(SELECT * FROM EDMSGetParent(PARENTid,divid,UserId) WHERE PARENTCD = SELECTID)
	BEGIN
		RETURN QUERY
		SELECT '1'
	END;
	ELSE
		IF CHECK = '0' THEN

			--선택된 레벨의 값들의 부모값,소트 넘버를 변경한다.;
			UPDATE	EDMSTreeItem
			PARENTID := PARENTid;
			,		SORTORD		=	SORTNO + A.SORTORD
			FROM	EDMSTreeItem A 
					INNER JOIN
					(
						--소트넘버를 위한 카운트 쿼리.
						SELECT	COUNT(A.SORTORD)AS SORTORD
						,		A.ID
						,		A.DivID
						FROM	
							(	
								SELECT	ID
								,		SORTORD
								,		DivID
								FROM  	EDMSTreeItem
								WHERE	USEYN		= 	'Y'		
								and		divId	= divId
								and (( DIVID = '4' AND 	UserId	=	edmstreeitemchange.userid)	
								OR DIVID IN ('1','2') ) 
								AND	PARENTID	=	SELECTPARENTID
							) A
							INNER JOIN
							(
								SELECT	ID
								,		SORTORD
								,		DivID
								FROM  	EDMSTreeItem
								WHERE	USEYN		= 	'Y'		
								and		divId	= divId
								and (( DIVID = '4' AND 	UserId	=	edmstreeitemchange.userid)	
								OR DIVID IN ('1','2') ) 
								AND	PARENTID	=	SELECTPARENTID
							) B
							ON A.SORTORD >= B.SORTORD
						GROUP BY A.ID, A.DivID
					)B
					ON A.ID = B.ID and a.DivID=b.DivID
		END IF;
		ELSE;
				UPDATE	EDMSTreeItem
				PARENTID := PARENTid;
				,		SORTORD		=	SORTNO + 1
				FROM	EDMSTreeItem A
				WHERE	USEYN		= 	'Y'		
				and		divId	= divId
				and (( DIVID = '4' AND 	UserId	=	edmstreeitemchange.userid)	
					OR DIVID IN ('1','2') ) 
				AND	ID			=	SELECTID		

				--이동될 노드와 부모값이 같고 소트 넘버가 큰넘들은 -1 씩 해준다.;
				UPDATE	EDMSTreeItem
				SORTORD := SORTORD - 1;
				WHERE	PARENTID	=	SELECTPARENTID
				AND		SORTORD		>	SELECTIDSORTNO
				and		DivID=divid
		END IF;
		
		RETURN QUERY
		SELECT 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
