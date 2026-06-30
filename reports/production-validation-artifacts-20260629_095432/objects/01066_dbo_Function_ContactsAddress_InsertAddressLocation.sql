-- ─── FUNCTION: contactsaddress_insertaddresslocation ───────────────────────────────
DROP FUNCTION IF EXISTS public.contactsaddress_insertaddresslocation(integer, integer, smallint, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.contactsaddress_insertaddresslocation(
    userno integer,
    seq integer,
    type smallint,
    typename character varying,
    address character varying,
    contactaddressid integer
) RETURNS void
AS $function$
BEGIN

	IF ContactAddressId=0
		BEGIN;
				INSERT INTO ContactsAddress
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Address,
				IsDefault,
				RegDate,
				ModDate
			)
				 VALUES(UserNo, Seq, Type, TypeName, Address, '1', NOW(), NOW()) 
		 END
	ELSE
	BEGIN;
		UPDATE ContactsAddress
		SET
			RegUserNo=contactsaddress_insertaddresslocation.userno,
				UserSeq=contactsaddress_insertaddresslocation.seq,
				Type=contactsaddress_insertaddresslocation.type,
				TypeName= contactsaddress_insertaddresslocation.typename,
				Address=contactsaddress_insertaddresslocation.address								
		WHERE Seq=contactsaddress_insertaddresslocation.contactaddressid
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
