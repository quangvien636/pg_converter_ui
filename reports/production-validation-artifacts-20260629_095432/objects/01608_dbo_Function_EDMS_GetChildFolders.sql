-- ─── FUNCTION: edms_getchildfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getchildfolders(character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.edms_getchildfolders(
    isadmin character varying,
    divid character varying,
    parentid integer,
    langindex integer
) RETURNS TABLE(
    id text,
    itemnm text,
    sortord text,
    parentid text,
    foldertype text,
    options text
)
AS $function$
DECLARE
    temparentid integer;
    tempid integer;
    ischeck integer;
BEGIN




RowNum		INT IDENTITY,
ID int,
ItemNm nvarchar(200),
SortOrd int,
ParentID int,
FolderType char(2),
Options int
)

if(isAdmin='') BEGIN
		IF(ParentID>0) BEGIN
			RETURN QUERY
			SELECT a.ID,
			(case when LangIndex = 1  then a.ItemNm1
				when LangIndex=2 then a.ItemNm2
				when LangIndex=3 then a.ItemNm3
				when LangIndex=4 then a.ItemNm4
			end) AS ItemNm,
			a.SortOrd,a.ParentID,'2' AS FolderType 
			, 0 as Options
			FROM EDMSTreeItem a left join EDMSTreeAuthority b on a.ParentID=b.ParentID
			WHERE a.DivID = edms_getchildfolders.divid AND a.UseYn = 'Y' AND a.ParentID = edms_getchildfolders.parentid
			AND a.ID=b.FolderId
			AND b.DepartID=DepartID
			--AND a.UserID=UserId
			ORDER BY a.SortOrd
		END
		ELSE BEGIN;
		insert into Temptable
			RETURN QUERY
			SELECT  a.ID,
			(case when LangIndex = 1  then a.ItemNm1
				when LangIndex=2 then a.ItemNm2
				when LangIndex=3 then a.ItemNm3
				when LangIndex=4 then a.ItemNm4
			end) AS ItemNm,
			a.SortOrd,a.ParentID,'2' AS FolderType, 0 as Options		
			FROM EDMSTreeItem a  left join EDMSTreeAuthority b  on a.ParentID=b.ParentID
			WHERE a.DivID = edms_getchildfolders.divid AND a.UseYn = 'Y'
			AND a.ID=b.FolderId
			AND b.DepartID = DepartID	
			--AND a.UserID=UserId		
			ORDER BY a.SortOrd
			

			RowNum		INT IDENTITY,
				ID int,
				ItemNm nvarchar(200),
				SortOrd int, 
				ParentID int,
				Options int
			)

			insert into TemtableResult
			RETURN QUERY
			select ID,ItemNm,SortOrd,ParentID,Options from Temptable







			SET RowIndex = 1

			SET MaxIndex = (SELECT MAX(RowNum) FROM Temptable)

			WHILE (RowIndex <= MaxIndex) BEGIN

				select TemparentId= edms_getchildfolders.parentid from Temptable where RowNum=RowIndex

				if(TemparentId>0) begin

					set ischeck = (select count(*) from TemtableResult where ID= TemparentId)
					-- begin check recored
					if(ischeck = FALSE) begin;
						insert into TemtableResult
						RETURN QUERY
						select ID,(case when LangIndex = 1  then ItemNm1
										when LangIndex=2 then ItemNm2
										when LangIndex=3 then ItemNm3
										when LangIndex=4 then ItemNm4
									end) AS ItemNm,
									SortOrd,
									ParentID,
									1 as Options
									 from EDMSTreeItem where DivID=edms_getchildfolders.divid and ID=TemparentId
					end -- end check record


						SET TempId =(select  public."EDMS_GetParentID"(TemparentId,DivId))


						while TempId > 0 begin

						insert into TemtableResult
							RETURN QUERY
							select ID,(case when LangIndex = 1  then ItemNm1
											when LangIndex=2 then ItemNm2
											when LangIndex=3 then ItemNm3
											when LangIndex=4 then ItemNm4
										end) AS ItemNm,
										SortOrd,
										ParentID,
										1 as Options
										 from EDMSTreeItem where DivID=edms_getchildfolders.divid and ID=TempId
							SET TempId =(select  public."EDMS_GetParentID"(TempId,DivId))
						end
				end


				SET RowIndex = RowIndex + 1
			end

			RETURN QUERY
			select convert(varchar(100),ID) as ID,ItemNm,SortOrd,convert(varchar(100),ParentID) as ParentID,'2' AS FolderType,Options from TemtableResult
		END
	END
	ELSE BEGIN
			RETURN QUERY
			SELECT ID,
		(case when LangIndex = 1  then ItemNm1
			when LangIndex=2 then ItemNm2
			when LangIndex=3 then ItemNm3
			when LangIndex=4 then ItemNm4
		end) AS ItemNm,
		SortOrd,ParentID,'2' AS FolderType , 0 as Options
		FROM EDMSTreeItem 
		WHERE DivID = edms_getchildfolders.divid AND UseYn = 'Y' AND ParentID !='-1'	
		ORDER BY SortOrd
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
