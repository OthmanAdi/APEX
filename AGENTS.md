# AGENTS.md — Project Intelligence

> This file is the project's living memory. It is read by AI agents before every task.
> Rules are added automatically via `apex-learn` when patterns are discovered.
> Do not delete rules without understanding why they were added.

## Identity

- Project: {PROJECT_NAME}
- Stack: {TECH_STACK}
- Package Manager: {PACKAGE_MANAGER}

## Code Style

## Architecture Rules

## Workflow

- Always create a feature branch before making changes
- Run the full validation chain (lint, types, tests, build) before committing
- Open draft PRs for review — never push directly to main
- Write descriptive commit messages: `type(scope): description`

## Boundaries

- Never modify files outside the assigned task scope
- Never commit secrets, API keys, or credentials
- Never remove failing tests — fix them or flag for review
- Never push to main or production branches directly

## Preferences

## Tools

## Learnings Log

<!-- New learnings are appended here by apex-learn -->
