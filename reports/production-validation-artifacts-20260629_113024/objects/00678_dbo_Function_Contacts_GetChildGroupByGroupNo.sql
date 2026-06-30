-- ─── FUNCTION: contacts_getchildgroupbygroupno ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getchildgroupbygroupno(integer);
CREATE OR REPLACE FUNCTION public.contacts_getchildgroupbygroupno(
    groupno integer
) RETURNS TABLE(
    groupno integer
)
AS $function$
#variable_conflict use_column
DECLARE
    temptable table ( rownum int identity, groupno int);
    temgroupno integer;
BEGIN



insert into TempTable
RETURN QUERY
select GroupNo from ContactsGroup where ParentGNo=contacts_getchildgroupbygroupno.groupno

insert into TableGroupNo(GroupNo) values(GroupNo)

insert into TableGroupNo
RETURN QUERY
select GroupNo from ContactsGroup where ParentGNo=contacts_getchildgroupbygroupno.groupno



set RowIndex =1
set MaxIndex= (select max(RowNum) from TempTable)


	while (RowIndex < MaxIndex) BEGIN
		select TemGroupNo = contacts_getchildgroupbygroupno.groupno from TempTable where RowNum=RowIndex

		insert into TableGroupNo
		RETURN QUERY
		select GroupNo from ContactsGroup where ParentGNo= TemGroupNo

		Set RowIndex =RowIndex+1
	END

	--select * from TableGroupNo
	

return;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
