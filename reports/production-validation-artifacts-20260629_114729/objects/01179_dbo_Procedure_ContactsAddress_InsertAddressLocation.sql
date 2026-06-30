-- ─── PROCEDURE→FUNCTION: contactsaddress_insertaddresslocation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contactsaddress_insertaddresslocation(integer, integer, smallint, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.contactsaddress_insertaddresslocation(
    IN userno integer,
    IN seq integer,
    IN type smallint,
    IN typename character varying,
    IN address character varying,
    IN contactaddressid integer
) RETURNS void
AS $function$
BEGIN

	IF ContactAddressId=0 THEN;
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
		 END IF;
	ELSE;
		UPDATE ContactsAddress
		RegUserNo := contactsaddress_insertaddresslocation.userno,;
				UserSeq=contactsaddress_insertaddresslocation.seq,
				Type=contactsaddress_insertaddresslocation.type,
				TypeName= contactsaddress_insertaddresslocation.typename,
				Address=contactsaddress_insertaddresslocation.address								
		WHERE Seq=contactsaddress_insertaddresslocation.contactaddressid
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
