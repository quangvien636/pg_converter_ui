# Regex Patterns Inventory

This document details key regular expressions used in the parser and converter, identifying their file locations, weaknesses, and optimization/correction strategies.

---

## Regex Inventory List

### 1. Procedure/Function Header Extractor
*   **Regex Pattern:**
    ```regex
    (?:CREATE\s+OR\s+ALTER|ALTER|CREATE)\s+(?:PROCEDURE|PROC)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?\s*([\s\S]*?)(?:AS\s*$|AS\s*BEGIN)
    ```
*   **Purpose:** Matches the start of stored procedures to extract their name and parameters.
*   **File Location:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L61-L63)
*   **Known Weakness:** Relies on matching `AS` or `AS BEGIN` at line end. If the keyword `AS` appears inside comments, column lists, or parameter default strings, it matches prematurely, cutting the parameter block short.
*   **Replacement Suggestion:** Restrict `AS` matching to line boundaries, ignoring comment trails:
    ```regex
    (?im)^[ \t]*(?:CREATE\s+OR\s+ALTER|ALTER|CREATE)\s+(?:PROCEDURE|PROC)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?\s*([\s\S]*?)(?=\bAS\b\s*(?:--.*|\r?\n|\z))
    ```

### 2. Local Variable Declarations Scanner
*   **Regex Pattern:**
    ```regex
    (?m)^[ \t]*DECLARE\s+([^\r\n]+)\r?$
    ```
*   **Purpose:** Identifies local variable declarations (`DECLARE @var INT`) to strip them and place them in the PL/pgSQL `DECLARE` section.
*   **File Location:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L74-L75) and [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs#L72-L73)
*   **Known Weakness:** Fails to match variable declarations that span multiple lines under a single `DECLARE` statement.
*   **Replacement Suggestion:** Parse multi-line blocks starting from the `DECLARE` keyword up to the statement terminator (semicolon or next keyword like `SELECT` / `SET`).

### 3. MERGE Block Converter
*   **Regex Pattern:**
    ```regex
    MERGE\s+(?:INTO\s+)?(?:\[?dbo\]?\.)?\[?(\w+)\]?\s+(?:AS\s+)?(\w+)\s*\r?\n\s*USING\s+([\s\S]+?)\s+(?:AS\s+)?(\w+)\s+ON\s*\(([^)]+)\)([\s\S]+?)(?=;|\r?\n\s*GO\b|\z)
    ```
*   **Purpose:** Extracts `MERGE` clauses and outputs equivalent `UPDATE` and `INSERT` sequences.
*   **File Location:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs#L570-L571)
*   **Known Weakness:** Possesses high complexity due to `[\s\S]+?` wildcards, risking catastrophic backtracking or incorrect block matching on nested structures.
*   **Replacement Suggestion:** Tokenize the body and split the statement into structured segments based on keyword boundaries (`USING`, `ON`, `WHEN MATCHED`, `WHEN NOT MATCHED`).

### 4. Semicolon Terminator Injector
*   **Regex Pattern:**
    ```regex
    (?<![;,])(?=\r?\n|$)
    ```
*   **Purpose:** Appends semicolons at the end of execution lines inside routine bodies.
*   **File Location:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L1070)
*   **Known Weakness:** If trailing comments (`-- comment`) are on the same line, or if lines end with `\r` (carriage return), the lookbehind checks the wrong character and fails, yielding double semicolons `;;` or missing statement terminators.
*   **Replacement Suggestion:** Strip trailing carriage returns early, strip trailing single-line comments before running checks, or append the terminator before comments.

### 5. Cursor Declarations Extractor
*   **Regex Pattern:**
    ```regex
    DECLARE\s+@?(\w+)\s+CURSOR\s+(?:(?:LOCAL|GLOBAL|FORWARD_ONLY|SCROLL|STATIC|KEYSET|DYNAMIC|FAST_FORWARD|READ_ONLY|SCROLL_LOCKS|OPTIMISTIC|TYPE_WARNING)\s+)*FOR\s+([\s\S]+?)(?=\n[ \t]*(?:OPEN|DECLARE\s+@|GO\b|--|\z))
    ```
*   **Purpose:** Scans the body for cursor definitions to rewrite them as PL/pgSQL loops.
*   **File Location:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs#L245-L246)
*   **Known Weakness:** The `[\s\S]+?` matcher can span past the true cursor body if the next expected keyword (`OPEN`) is missing, resulting in matching other code blocks.
*   **Replacement Suggestion:** Force matching up to the statement terminator `;`:
    ```regex
    \bDECLARE\s+@?(\w+)\s+CURSOR\s+[^;]+;?
    ```
