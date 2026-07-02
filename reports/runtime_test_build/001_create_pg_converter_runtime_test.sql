-- REVIEW-ONLY. Run from an administrative database, never from a customer database.
-- No DROP is included. Database creation must be explicitly approved after backup.
SELECT 'pg_converter_runtime_test creation/rebuild requires explicit operator approval' AS status;