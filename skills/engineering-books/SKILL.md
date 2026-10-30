---
name: engineering-books
description: Software engineering rules distilled from 14 classic books (a philosophy of software design, clean architecture, clean code, code complete, designing data intensive applications, domain driven design distilled, domain driven design, implementing domain driven design, patterns of enterprise application architecture, refactoring guru, refactoring, release it, the pragmatic programmer, working effectively with legacy code). Use when designing, implementing, refactoring, testing, or reviewing code, architecture, domain models, data systems, or production reliability.
---

# engineering books

Rules from 14 books, one folder each under `books/`. Do not load them all.

1. Pick the one book whose description below fits the task best. Take a second only if the task clearly spans two areas.
2. Read `books/<book>/INSTRUCTIONS.md` and follow it. It says which rule file to load.
3. When books overlap (for example several on domain-driven design), prefer the most specific match.

| Book | Use when |
|---|---|
| `a-philosophy-of-software-design` | Apply John Ousterhout-inspired software design rules when reducing complexity, designing module boundaries, or reviewing APIs and abstractions. |
| `clean-architecture` | Apply Robert C. Martin-inspired architecture rules when separating business policy from frameworks, databases, UI, or infrastructure details. |
| `clean-code` | Apply Robert C. Martin-inspired clean code rules when improving readability, naming, function design, responsibilities, or testable everyday code. |
| `code-complete` | Apply Steve McConnell-inspired construction rules when implementing routines, variables, classes, control flow, defensive code, or tests. |
| `designing-data-intensive-applications` | Apply Martin Kleppmann-inspired data-system rules when designing reliability, scalability, consistency, replication, transactions, streams, or schema evolution. |
| `domain-driven-design-distilled` | Apply Vaughn Vernon-inspired lightweight DDD rules when using bounded contexts, subdomains, context maps, and tactical modeling without excess ceremony. |
| `domain-driven-design` | Apply Eric Evans-inspired DDD rules when modeling a complex domain, defining bounded contexts, protecting ubiquitous language, or designing aggregates. |
| `implementing-domain-driven-design` | Apply Vaughn Vernon-inspired implementation DDD rules when building aggregates, domain events, repositories, application services, or context integrations. |
| `patterns-of-enterprise-application-architecture` | Apply Martin Fowler-inspired enterprise architecture rules when choosing layers, service layers, transaction scripts, domain models, repositories, mappers, or DTOs. |
| `refactoring-guru` | Apply Refactoring.Guru-inspired rules when diagnosing code smells, choosing refactoring techniques, and stopping cleanup before uncontrolled redesign. |
| `refactoring` | Apply Martin Fowler-inspired refactoring rules when improving existing code structure while preserving observable behavior. |
| `release-it` | Apply Michael T. Nygard-inspired production reliability rules when designing failure handling, timeouts, retries, circuit breakers, observability, or deployment behavior. |
| `the-pragmatic-programmer` | Apply Hunt and Thomas-inspired pragmatic programming rules when improving engineering judgment, feedback loops, DRY knowledge, orthogonality, automation, or adaptability. |
| `working-effectively-with-legacy-code` | Apply Michael Feathers-inspired legacy-code rules when changing hard-to-test code safely with characterization tests, seams, sprout methods, or wrap methods. |

