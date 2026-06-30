SELECT
    (SELECT count(*) FROM public."Users") AS users,
    (SELECT count(*) FROM public."Orders") AS orders,
    (SELECT count(*) FROM pg_indexes WHERE schemaname = 'public') AS indexes,
    (SELECT count(*) FROM pg_proc p
        JOIN pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public') AS functions,
    (SELECT count(*) FROM information_schema.table_constraints
        WHERE constraint_schema = 'public'
          AND constraint_type = 'FOREIGN KEY') AS foreign_keys;
