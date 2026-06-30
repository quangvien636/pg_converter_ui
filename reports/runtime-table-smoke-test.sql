INSERT INTO public."Users" (tenantid, name, guid)
VALUES (1, 'QA', '00000000-0000-0000-0000-000000000001')
RETURNING id, isactive;
