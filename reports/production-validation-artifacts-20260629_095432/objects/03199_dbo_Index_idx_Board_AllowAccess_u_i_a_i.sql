-- ─── INDEX: idx_board_allowaccess_u_i_a_i ON Board_AllowAccess ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_board_allowaccess_u_i_a_i') THEN
        CREATE INDEX idx_board_allowaccess_u_i_a_i ON public."Board_AllowAccess" (UserNo, ItemType);
    END IF;
END;
$$;
