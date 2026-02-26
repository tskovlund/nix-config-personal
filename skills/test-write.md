---
name: test-write
description: >
  Generate comprehensive tests for a module or function. Auto-triggers when
  new modules are added without tests, when the user says "write tests",
  "add tests", "test this", "cover this", or when implementing a feature
  and no test file exists yet. Do NOT use for running existing tests
  (just run pytest/jest directly) or for debugging test failures.
user-invocable: true
argument-hint: "[file-or-module]"
allowed-tools: Bash(pytest *), Bash(npx jest *), Bash(nix develop --command *), Bash(devbox run *), Read, Grep, Glob, Edit, Write, Task
metadata:
  author: tskovlund
  version: "1.1"
---

# Write tests

Generate comprehensive, idiomatic tests for a module, class, or function.

## Before writing anything

1. **Read CONVENTIONS.md** in the project root (or `~/.claude/CONVENTIONS.md` as fallback). The Testing section defines naming, structure, coverage, and philosophy. Every test you write must follow those rules exactly.
2. **Read the source** — understand the module's public API, edge cases, error paths
3. **Check for existing tests** — extend, don't duplicate. Match their patterns.
4. **Identify the test framework** — match what the project already uses

```sh
# Find existing tests to match patterns
find . -name "test_*" -o -name "*_test.*" -o -name "*.test.*" -o -name "*.spec.*" | head -20

# Read project conventions
cat CONVENTIONS.md 2>/dev/null | head -200
```

## CONVENTIONS.md rules (summary)

These come from CONVENTIONS.md — always re-read the source file for the latest version:

- **Naming:** `test_<action>_<expected_outcome>`
- **Structure:** Arrange / Act / Assert comments in every test
- **Lean:** every test must earn its place — no trivial tests, no testing library/built-in functionality
- **No duplication:** shared logic tested once in the base, not per subclass
- **Complete coverage:** every error path, edge case, and branching condition that could fail in production
- **Integration tests alongside unit tests** — both complement each other

If the project's CONVENTIONS.md has additional or different test rules, those take precedence over this summary.

## Test categories

Write tests in this priority order:

1. **Happy path** — core functionality with valid inputs
2. **Edge cases** — boundary values, empty inputs, None/null, single-element collections
3. **Error paths** — invalid inputs raise appropriate exceptions with clear messages
4. **Integration points** — external interactions (API, DB, filesystem) tested with mocks/fixtures

## Framework scaffolding

### Python (pytest)

```python
# File: tests/test_<module>.py
import pytest
from <package>.<module> import <function_or_class>


class TestFunctionName:
    """Tests for function_name."""

    def test_valid_input_returns_expected(self):
        # Arrange
        input_data = create_valid_input()
        # Act
        result = function_name(input_data)
        # Assert
        assert result == expected

    @pytest.mark.parametrize("input_val,expected", [
        ("normal", "result"),
        ("edge", "edge_result"),
        ("", "empty_result"),
    ])
    def test_various_inputs_return_correct_values(self, input_val, expected):
        # Arrange / Act
        result = function_name(input_val)
        # Assert
        assert result == expected

    def test_invalid_input_raises_value_error(self):
        # Arrange
        bad_input = create_invalid_input()
        # Act / Assert
        with pytest.raises(ValueError, match="specific message"):
            function_name(bad_input)
```

- Group related tests in classes (`TestClassName`)
- Use `@pytest.mark.parametrize` for input variations
- Use fixtures for shared setup, `conftest.py` for cross-file fixtures
- Use `tmp_path` fixture for filesystem tests

### TypeScript/JavaScript (jest)

```typescript
// File: src/<module>.test.ts
import { functionName } from "./<module>";

describe("functionName", () => {
  it("returns expected result for valid input", () => {
    // Arrange
    const input = createValidInput();
    // Act
    const result = functionName(input);
    // Assert
    expect(result).toBe(expected);
  });

  it.each([
    ["normal", "result"],
    ["edge", "edge_result"],
  ])("handles %s input", (input, expected) => {
    expect(functionName(input)).toBe(expected);
  });
});
```

## Test file placement

Follow what the project already does. If no tests exist yet:

- **Python:** `tests/test_<module>.py` (mirror source structure)
- **TypeScript:** `src/<module>.test.ts` (co-located)

## After writing tests

Run them to verify they pass:

```sh
# Python
pytest tests/test_<module>.py -v

# TypeScript
npx jest src/<module>.test.ts
```

If tests fail, fix the tests (not the source) — unless you discover an actual bug, in which case flag it to the user.

## Examples

### Example 1: Python module

User says: "write tests for src/parser.py"

Actions:
1. Read `CONVENTIONS.md` — note naming convention, AAA structure requirement
2. Read `src/parser.py` — find `parse_config(text: str) -> Config` and `validate_schema(config: Config) -> list[Error]`
3. Check `tests/` — no existing `test_parser.py`, but `test_engine.py` exists — match its patterns
4. Write `tests/test_parser.py` following CONVENTIONS.md rules:
   - `TestParseConfig`: `test_valid_yaml_returns_config`, `test_invalid_yaml_raises_parse_error`, `test_empty_input_raises_value_error`
   - `TestValidateSchema`: `test_valid_config_returns_no_errors`, `test_unknown_keys_returns_warnings`, `test_type_mismatch_returns_error`
5. Run `pytest tests/test_parser.py -v` — all pass
6. Report: "Wrote 10 tests in 2 classes following CONVENTIONS.md (AAA structure, test_action_outcome naming)."

### Example 2: Auto-trigger

Agent just created `src/utils/rate_limiter.py` with no corresponding test file.

Actions:
1. Detect: new module created without tests
2. Suggest: "I notice `rate_limiter.py` has no tests. Want me to write them?"
3. If confirmed, read CONVENTIONS.md, write tests following its rules

## What NOT to do

- Don't test private/internal methods directly — test through the public API
- Don't mock everything — only mock external I/O (network, filesystem, time)
- Don't write tests that just repeat the implementation logic
- Don't ignore CONVENTIONS.md — it's the source of truth for test style
