# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ActiveRecord::HealthCheck is a Ruby gem that validates ActiveRecord models and their associations recursively. It traverses model associations (has_many, has_one, belongs_to, has_and_belongs_to_many, polymorphic) and returns validation errors for any invalid records found.

## Development Commands

**Run tests:**
```bash
rake spec
# or
bundle exec rspec
```

**Run single test file:**
```bash
bundle exec rspec spec/lib/active_record/health_check/check_spec.rb
```

**Run single test by line number:**
```bash
bundle exec rspec spec/lib/active_record/health_check/check_spec.rb:16
```

**Lint code:**
```bash
rake rubocop
# or
bundle exec rubocop
```

**Auto-fix linting issues:**
```bash
bundle exec rubocop -a
```

**Run all checks (tests + linting):**
```bash
rake
```

**Interactive console:**
```bash
bin/console
```

## Code Style

- Ruby version: >= 3.2.0
- String literals: Use double quotes (enforced by RuboCop)
- Frozen string literals: Required at top of all Ruby files

## Architecture

**Core components:**

1. **Check** (`lib/active_record/health_check/check.rb`): Main validation orchestrator
   - Validates the root model and recursively checks all associations
   - Handles different association types: CollectionProxy (has_many, HABTM) and Base (has_one, belongs_to)
   - Supports skipping specific associations via `skips` parameter
   - Uses `_reflections` to discover model associations

2. **Result** (`lib/active_record/health_check/result.rb`): Factory for creating standardized error hashes
   - Returns hash with keys: `:class`, `:id`, `:error_messages`

3. **Skips** (`lib/active_record/health_check/skips.rb`): Parser for association skip list
   - Normalizes association names to symbols for filtering

**Test setup:**
- Uses in-memory SQLite database (configured in `spec/spec_helper.rb`)
- Test models include complex association scenarios: User -> Posts -> Tags, User -> Profile -> Address, polymorphic Comments
- Database transactions are rolled back after each test
