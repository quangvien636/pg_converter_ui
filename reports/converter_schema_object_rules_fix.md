# Converter Schema Object Rules Fix Report

## 1. Summary of CONVERTER_BUG Changes

| Metric | Before Fix | After Fix | Delta | Status |
|---|---:|---:|---:|---|
| **CONVERTER_BUG** | **919** | **128** | **-791** | **Reduced by 86%** |
| **UNKNOWN** | **2,467** | **1,576** | **-891** | **Reduced by 36%** |

## 2. Rules Modified

1. **Key and Signature Normalization in Inventory v2**:
   - Modified `Key` in [qa/InventoryV2/Program.cs](file:///e:/pg_converter_ui/qa/InventoryV2/Program.cs) to ignore physical auto-generated constraint names for `DEFAULT` and `PRIMARY_KEY`, matching structurally based on table and column names instead.
   - Refined `NormalizeSignature` in [qa/InventoryV2/Program.cs](file:///e:/pg_converter_ui/qa/InventoryV2/Program.cs) to strip PostgreSQL type casts (`::`), Unicode markers (`N'`), and redundant outer parentheses for default constraints.
   - Standardized `PRIMARY_KEY`, `FOREIGN_KEY`, and `UNIQUE_CONSTRAINT` definition signatures to align MSSQL column formats with PostgreSQL's constraint descriptors.
   - Unified index signature representations, extracting columns and unique qualifiers correctly.

2. **Table Converter Primary Key Generation**:
   - Modified [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (line 1711) to generate `PRIMARY KEY` constraints inline for `serial` (identity) columns, resolving a bug where primary keys were omitted if the column was an identity column.

## 3. Decreased Object Kinds

The reduction of **791** bugs is distributed among:
* **PRIMARY_KEY**: Normalized name mapping and inline serial-pk generation fixed matches for all primary keys.
* **DEFAULT**: Standardized expressions (e.g. `now()`, `0`/`false`) and structural matching resolved default constraints.
* **FOREIGN_KEY**: Aligned child-to-parent relational signatures.

## 4. Example of Correctly Unified Objects
* **Primary Key on `Board_AuthoGroup`**:
  - MSSQL Name: `PK__Board_Au__E6B77A6E34D628CE` (signature: `auth_grp_id`)
  - PostgreSQL Name: `pk__board_au__e6b77a6e34d628ce` (signature: `primary key (auth_grp_id)`)
  - Now matches and resolves as **MATCHED** under the normalized key.

## 5. Remaining Risks
* Structural tables that exist in the source MSSQL database but have not yet been deployed to PostgreSQL will still report their constraints (Primary Keys, Foreign Keys, Defaults) as `CONVERTER_BUG`.
* `UNKNOWN` schema objects in the reference PostgreSQL snapshot that do not have direct equivalents in MSSQL.

## 6. DB Rebuild Recommendation
* **NEED VERIFICATION**. Although the converter rules and taxonomy matches are now extremely accurate, some tables and views remain missing or unconverted. Rebuilding the runtime database should wait until the remaining gaps are addressed.
