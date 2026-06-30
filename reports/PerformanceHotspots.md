# Performance Hotspots Report

This report analyzes the performance bottlenecks within the database converter codebase, identifying large regex operations, nested loops, repeated parsing, and $O(n^2)$ hotspots, and recommends technical optimizations.

---

## 1. Performance Hotspots & Bottlenecks

### 1. Sequential Regex Passes on Immutable Strings (GC Pressure)
*   **Location:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs) (`Convert` method)
*   **Complexity:** $O(m \times n)$ where $m$ is the number of transformation phases (11 phases) and $n$ is the character length of the routine body.
*   **Description:** The converter passes the entire routine body string through 11 separate methods (`ConvertTryCatch` $\rightarrow$ `StripBoilerplate` $\rightarrow$ `ConvertCursors` $\rightarrow$ `ConvertTempTables` $\rightarrow$ `ConvertExec`, etc.). Each phase performs multiple global `Regex.Replace` operations. Because C# strings are immutable, this process instantiates dozens of large, temporary string allocations in memory.
*   **Impact:** When processing large database catalogs (5,052 objects), this pattern triggers intense Garbage Collector (GC) pressure, degrading conversion throughput.

### 2. $O(n^2)$ Control Flow Line Scans
*   **Location:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs#L729) (`ConvertControlFlow` method)
*   **Complexity:** Worst-case $O(L^2)$ where $L$ is the number of lines in a single stored procedure.
*   **Description:** The method splits the routine body into lines and iterates over them. Inside the loop, it performs multiple look-ahead scans:
    *   `CollectMultiLineCond` loops forward through subsequent lines to find matching parentheses.
    *   `NextLineStartsElse` loops forward through lines to check if the next block represents an `ELSE` statement.
*   **Impact:** For very large stored procedures (procedures exceeding 1,000 lines), this nested iteration yields quadratic execution times.

### 3. Large Backtracking Regexes
*   **Location:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs#L569) (`ConvertMerge`) and [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs#L245) (`ConvertCursors`)
*   **Complexity:** Exponential $O(2^d)$ in backtracking edge cases.
*   **Description:** Patterns like the MERGE match block use multiple wildcards `[\s\S]+?` to parse columns, sources, and statements. If the matching block lacks clear terminators, the engine backtracks extensively.
*   **Impact:** Can trigger regex timeout exceptions (safeguarded at 5 seconds), causing the converter to skip parsing steps and emit raw SQL instead.

### 4. Repeated Table DDL Type Mapping Scans
*   **Location:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L642) (`ConvertTable`) and [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L1317) (`ConvertTableFromCatalog`)
*   **Complexity:** $O(c)$ where $c$ is the number of columns in a table.
*   **Description:** Duplicate type mapping passes are performed. `ConvertTable` performs multiple regex swaps over the raw column list text block, while `ConvertTableFromCatalog` maps individual catalog metadata structures.
*   **Impact:** Redundant processing of table column structures.

---

## 2. Recommended Optimizations

1.  **Transition to a Single-Pass Tokenizer (AST-based):**
    *   *Approach:* Rather than performing sequential regex replacements on raw text, write a lightweight lexical analyzer/tokenizer. Tokenize the input string once into a stream of tokens (Identifiers, Keywords, Operators, Literal Strings, Comments).
    *   *Benefits:* Eliminates intermediate string copies, improves translation accuracy, and reduces execution complexity to $O(n)$ linear time.
2.  **Optimize Control Flow using Stack-Based Single Pass:**
    *   *Approach:* Replace the forward-scanning helper methods (`NextLineStartsElse` and `CollectMultiLineCond`) with a single-pass parser utilizing a state stack. As lines are scanned, push block types (IF, WHILE) onto the stack and pop them on matching boundaries.
    *   *Benefits:* Reduces line processing complexity from $O(L^2)$ to $O(L)$ linear time.
3.  **Utilize `RegexOptions.Compiled` or Source-Generated Regexes:**
    *   *Approach:* Declare regex patterns as static, compiled read-only fields or leverage .NET source generators for regex matching:
        ```csharp
        [GeneratedRegex(@"\bISNULL\s*\(", RegexOptions.IgnoreCase)]
        private static partial Regex IsNullRegex();
        ```
    *   *Benefits:* Bypasses JIT regex compilation overhead during runtime execution.
4.  **Use `ReadOnlySpan<char>` and `StringBuilder`:**
    *   *Approach:* Leverage `Span<T>` representations for slicing strings during parameter list splitting (`SplitParams`) and name extractions, bypassing temporary string heap allocations.
