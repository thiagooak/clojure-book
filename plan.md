# The Clojure Book — A "Rust Book" for clojure.org

Status: draft v1 (for socialization with Clojure/core + community, not yet approved)
Author: drafted with Claude Code, 2026-09-10

## 1. Problem Statement

Hypothesis: newcomers abandon Clojure not because the language is unusually
hard, but because there is no guided path from "hello world" to "I have a
real thing running in production." Without that win, there's nothing to
sustain motivation through the genuinely unfamiliar parts (REPL workflow,
immutability, Lisp syntax). The Rust Book solves this for Rust: it gets you
to a running program in minutes, keeps you inside one blessed toolchain the
whole way, and structures itself around three increasingly real projects,
ending in a from-scratch multithreaded web server.

Clojure has no equivalent. This plan proposes one, scoped for clojure.org.

## 2. What We Confirmed by Researching the Current State

### 2.1 The Rust Book's mechanics (what to replicate)

- **Immediate win, single toolchain.** Chapter 1 is install → hello world →
  hello Cargo. No detours. `rustup` + `cargo` are used for everything,
  start to finish — no competing tool ever enters the narrative.
- **Interleaved project checkpoints, not one final project.** Three project
  chapters (guessing game → ch. 2, minigrep → ch. 12, multithreaded web
  server → ch. 21) are spaced through 21 chapters, each forcing the reader
  to integrate everything learned so far into something runnable.
- **Hard concept front-loaded.** Ownership (ch. 4) — Rust's single hardest
  idea — is taught early, before structs/enums, so every later chapter can
  assume it.
- **Errors as a teaching surface.** Compiler errors are reproduced verbatim
  and explained line by line, not treated as a failure state to route
  around.
- **Code samples are executable and CI-verified.** Built with **mdBook**;
  every fenced Rust block is compiled/tested via `mdbook test` (rustdoc
  doctests under the hood), so the book cannot silently drift out of sync
  with the compiler. mdBook itself is generic (MPL-2.0, reusable for
  prose/nav/search), but the *code-testing* feature is Rust-specific.
- **Lives in the open, with real governance.** `rust-lang/book` on GitHub,
  `CONTRIBUTING.md`, `E-help-wanted` labels, explicit policy that non-error
  PRs may wait out of sync with edition cycles. It is simultaneously a free
  web book and a commercially printed one (No Starch Press).

### 2.2 clojure.org today (what already exists — and the real gap)

- **`guides/getting_started`** is a shallow hub: install instructions +
  hand-off links to third-party books and practice sites (Brave and True,
  Living Clojure, 4Clojure, Exercism). No original teaching content.
- **`guides/learn/clojure`** is the closest thing to a book that exists,
  and it is explicitly self-labeled a **work in progress**: Introduction →
  Syntax → Functions → Sequential Collections → Hashed Collections → Flow
  Control → Namespaces, then it stops. Nothing on state, concurrency, error
  handling, testing, packaging, or deployment.
- **`guides/*`** otherwise is a flat, disconnected bucket (spec,
  destructuring, threading macros, `tools.build`, deps/CLI...) — reference
  material, not a narrative.
- **`reference/*`** (27 pages) is pure spec-style reference.
- **Deploy-to-production guidance does not exist on clojure.org at all.**
  The closest page (`guides/tools_build`) stops at "here's how you build an
  uberjar."
- **Infra**: clojure.org is built with **JBake** from **AsciiDoc** source
  (not Markdown), repo `clojure/clojure-site`. Content is licensed
  **EPL-1.0**, owned by Rich Hickey; contributors must sign the **Clojure
  Contributor Agreement** (joint copyright), the same CA used for Clojure
  core. Governance is informal (reviewer label → an "Editor" merges);
  Alex Miller is the named author of most existing guides.
- **Tooling in 2026**: `clojure`/`clj` CLI + `deps.edn` + `tools.build` is
  the official blessed path for building things. Project *scaffolding*
  (`deps-new`, Sean Corfield) is excellent and actively maintained but is
  **third-party and not referenced on clojure.org** — there is no `cargo
  new` equivalent in the official story. Leiningen survives on inertia, not
  endorsement.
- No evidence of any current documentation/onboarding working group at
  Clojure/core — this is a green field, not a project we'd be duplicating.

### 2.3 Community resources (what's reusable vs. inspiration-only)

| Resource | License | Verdict |
|---|---|---|
| clojure.org "Learn Clojure" guide | EPL-1.0 (already clojure.org's) | **Absorb directly** as the seed of the foundations chapters — it's already in-voice and in-repo. |
| clojure.org other guides (`deps_and_cli`, `tools_build`) | EPL-1.0 | **Base material** for the tooling chapters. |
| Practicalli Clojure (practical.li) | **CC BY-SA 4.0** | **Reusable/adaptable** with attribution + share-alike. Strong existing coverage of CLI/REPL workflow, testing, spec, CI. Its own deployment-focused guide was archived/deprecated — confirms the gap independently. License-compatibility with EPL-1.0 + the Contributor Agreement needs a real check before merging text (see Risks). |
| ClojureBridge curriculum | **CC BY 4.0** | Reusable. Good model for Part 1 beginner framing/workshop exercises. |
| Clojure Koans | unverified | Exercise engine, not narrative prose. Reference only for now. |
| Exercism Clojure track | free, exercise-level | Not reusable as prose; good "further practice" pointer. |
| Clojure Applied (Pragmatic) | commercial | **Not reusable.** Notable precedent though — its Part 3 is the only existing Clojure book that treats testing/integration/deployment as first-class. Use its *shape* as inspiration only. |
| Living Clojure (O'Reilly) | commercial | Not reusable. Reference/further-reading only. |
| Brave and True | all rights reserved | **Not reusable**, despite being free to read. No deploy capstone anyway. Link as further reading. |

### 2.4 The "hello world → deployed" path in 2026

No canonical path exists yet, but a workable default is visible across
current tutorials: **Ring + reitit (or Compojure) + http-kit/Jetty →
`tools.build` uberjar → multi-stage Docker → Fly.io / Railway / Render**.
Railway has an official one-click Luminus guide. Heroku is fading (Clojure
unsupported on its newest runtime). GraalVM native-image is a viable but
more fragile advanced option. Babashka has no mature "script to a deployed
service" pattern at all — an interesting, currently-empty niche for a
lower-friction alternate track. **This fragmentation is exactly the
opportunity**: the book can be the thing that picks one opinionated path,
the way Cargo picked one path for Rust.

## 3. Design Principles (translated from the Rust Book, adapted to the hypothesis)

1. **Deploy early, deploy often — not once at the end.** Rust's model is
   three separate projects culminating in one final capstone. This book's
   central bet is different and more targeted at the stated hypothesis:
   **one running project, deployed to a real free host in the first
   sitting (Part 1), then iteratively upgraded and *redeployed* as each new
   concept is introduced.** The reader should never go more than a couple
   of chapters without pushing a change live. The motivational win isn't a
   single climax — it's a habit loop.
2. **One blessed toolchain, no branching.** `clj`/deps.edn + `tools.build`
   + (new) an official-or-adopted scaffolding tool, one HTTP stack, one
   deploy target as the *default* path. Alternatives get an appendix, not
   airtime in the main narrative.
3. **Executable, CI-verified code samples.** No code block ships that
   isn't actually run in CI against a real Clojure version.
4. **Errors are taught, not hidden.** Clojure's stack traces and spec
   error output are a well-known onboarding pain point; treat reading them
   as a core skill with dedicated worked examples, the way Rust treats
   borrow-checker errors.
5. **The hard concept gets its own room.** Immutability + state
   (atoms/refs/agents) is Clojure's "ownership" — the idea that reframes
   everything else. Give it a full, early, unhurried chapter rather than
   folding it into "misc topics."
6. **Reuse clojure.org's own infrastructure and voice.** Don't build a
   satellite site. Land inside `clojure-site`, in AsciiDoc, under the
   existing governance model — this is what makes it *actually* clojure.org
   rather than "yet another unofficial Clojure book" (of which there are
   already several).

## 4. Proposed Table of Contents

**Part 0 — Before You Start**
- 0.1 Who this book is for, and how to read it
- 0.2 Install the one blessed toolchain (Clojure CLI, an editor/REPL
  integration, Docker, git) — mirrors `rustup`'s "one install, one path"

**Part 1 — First Win (Hello, Production)** *— the hypothesis-critical part*
- 1.1 Hello, REPL — start it, evaluate expressions, feel the loop
- 1.2 Hello, Program — scaffold a real deps.edn project, run it locally
- 1.3 **Hello, Production** — containerize the trivial program and deploy
  it to a live URL before touching any "real" language concept. Target:
  under an hour, start to finish.

**Part 2 — Foundations** *(seeded from clojure.org's existing "Learn
Clojure" guide + Practicalli, redeploying the Part 1 project as each
concept lands)*
- 2. Syntax & the Reader
- 3. Values & Immutable Data (vectors, maps, sets, lists)
- 4. Functions & Namespaces
- 5. Flow Control & Destructuring
- 6. **Project checkpoint**: a small CLI tool (own "guessing game" moment)

**Part 3 — Making It Real**
- 7. State & Identity (atoms/refs/agents) — the front-loaded hard concept
- 8. Error Handling & Reading Stack Traces
- 9. Testing (`clojure.test`, REPL-driven testing habits)
- 10. **Project checkpoint**: add a real web API (Ring + reitit +
  http-kit) plus persistence to the Part-1 project; redeploy

**Part 4 — Going Deeper**
- 11. Concurrency (`pmap`, futures, intro `core.async`)
- 12. Java Interop
- 13. Polymorphism (protocols, multimethods, records)
- 14. Macros (survey-level — "know it exists, here's why")
- 15. Tooling deep dive (`tools.build`, deps.edn profiles/aliases, uberjars)

**Part 5 — Ship It For Real** *(capstone, mirrors Rust ch. 21's ambition)*
- 16. Hardening for production (config/secrets via env, logging, health
  checks)
- 17. Packaging & deploy options (uberjar+Docker in depth, GraalVM
  native-image tradeoffs, a Babashka-based lightweight alternative)
- 18. Final project: take the app that's been live since Part 1 through a
  real CI/CD pipeline, then a "where to go next" retrospective
  (ClojureScript/frontend, Datomic/datalog, distributed systems)

**Appendices**: editor/REPL setup per editor (Calva, Cursive, CIDER),
glossary for newcomers from other language families, map of community
resources for further learning, how to contribute to this book.

## 5. Reuse vs. Net-New Summary

**Reuse as-is or adapt:**
- clojure.org's `guides/learn/clojure` content → seed of Part 2
- clojure.org's `deps_and_cli` / `tools_build` guides → seed of tooling
  chapters (5, 15, 17)
- `clojure-site` infra itself (JBake, hosting, CI skeleton, nav, existing
  contribution process) — build *inside* it, don't replace it
- Practicalli Clojure prose (CC BY-SA 4.0) for testing/CLI/CI material,
  with attribution — pending the licensing check below
- ClojureBridge curriculum (CC BY 4.0) for Part 1 workshop-style framing
- The official CLI + deps.edn + `tools.build` toolchain as the backbone
- `deps-new` as the scaffolding tool — needs a conversation with its
  maintainer about being referenced/blessed the way Cargo blesses `cargo
  new`

**Must be built net-new:**
- The entire narrative arc and progressive project design — nothing like
  it exists today, in or outside clojure.org
- **Deploy-to-production content** — confirmed gap everywhere, including
  in community resources (Practicalli deprecated theirs); this is the
  single highest-priority net-new deliverable since it's the direct answer
  to the stated hypothesis
- A standardized, opinionated "default stack" for the running example
  (Ring/reitit/http-kit → Docker → one recommended host)
- A code-sample verification harness — Clojure has no mdBook/rustdoc-test
  equivalent. Needs a small tool (likely a Babashka or Clojure script) that
  extracts fenced code blocks with test annotations and evaluates them in
  CI, failing the build on drift. This is a genuine build task, not just
  content.
- Original worked "reading a stack trace" / "reading a spec error" content
- A style guide for voice consistency if multiple people author chapters
- The governance/contribution process specific to a book-length doc living
  inside `clojure-site` (labels, review flow, how chapters get frozen vs.
  actively edited)

## 6. Technical Architecture

- **Format & home**: author in AsciiDoc, inside `clojure/clojure-site`,
  under a new top-level section (e.g. `/guides/book/` or `/learn/`), so it
  is literally clojure.org from day one — not a satellite site that later
  needs a migration and a second buy-in conversation. *(Open question,
  flagged in §8: a Markdown/mdBook-style alternative is more contributor-
  friendly and eases reuse of Markdown-sourced community content, but
  costs a parallel-infra conversation with Clojure/core. Recommendation is
  to stay in JBake/AsciiDoc unless that conversation goes well.)*
- **Code verification tool**: a small CLI (working name: `book-test`) that
  walks chapter source files, extracts fenced `clojure` blocks tagged with
  a lightweight convention (e.g. a leading `;; test` comment plus expected
  output), evaluates each in a scratch process against a pinned Clojure
  version, and fails CI on mismatch or unexpected exception. This becomes
  a reusable artifact in its own right and should be designed so it could
  later be offered back to the wider Clojure docs community.
- **CI**: GitHub Actions running (a) JBake site build, (b) `book-test`,
  (c) a link checker, (d) a spellcheck pass (mirrors `rust-lang/book`'s
  `ci/spellcheck.sh`).
- **Reference deploy target for Part 1/Part 3/Part 5**: pick one primary
  host (Fly.io or Railway, per current research both have solid free-tier
  Clojure/Docker paths) as *the* documented default, with alternates in an
  appendix — avoid presenting deployment as an open-ended menu, which is
  the exact fragmentation this book exists to fix.

## 7. Governance & Path to Landing on clojure.org

1. **Socialize this plan** with Clojure/core (Alex Miller is the de facto
   owner of the existing guides) and the community (Clojurians Slack,
   Ask Clojure, ClojureVerse) before writing substantial content — get
   directional agreement on scope, hosting location, and the "one
   opinionated deploy path" call before investing further.
2. **Resolve licensing up front**: clojure.org content is EPL-1.0 with a
   joint-copyright Contributor Agreement; Practicalli content is
   CC BY-SA 4.0. Get an explicit answer (from Clojure/core, ideally with
   input from Practicalli's maintainer) on whether/how adapted CC BY-SA
   text can be relicensed into EPL-1.0-owned clojure.org content before
   adapting any of it verbatim.
3. **Prototype outside official infra first** to de-risk the ask: write
   Part 1 (the highest-value, most novel part) and the `book-test` harness
   in a standalone repo under a permissive license, pilot it with real
   newcomers (a ClojureBridge cohort is a natural test audience), and bring
   working, validated material to the "should this be on clojure.org"
   conversation rather than a pitch alone.
4. Only after prototype validation: formal proposal to merge into
   `clojure-site`, contributors sign the CA, content is relicensed to
   EPL-1.0, ongoing edits follow the existing informal reviewer/editor
   process.

## 8. Roadmap

- **Phase 0 (socialize, ~4 weeks)**: share this plan, get directional
  buy-in, resolve the licensing question, settle the format decision
  (AsciiDoc/JBake vs. an alternative).
- **Phase 1 (prototype, ~6 weeks)**: build Part 1 + `book-test` MVP in a
  standalone repo; pilot with a small newcomer group; iterate on the
  "time to first deploy" experience specifically, since that's the whole
  bet.
- **Phase 2 (foundations, ~10 weeks)**: Parts 2–3, recruit additional
  authors/reviewers, formalize a style guide.
- **Phase 3 (depth + capstone, ~10 weeks)**: Parts 4–5, full CI (test
  harness + link check + spellcheck), full technical review pass.
- **Phase 4 (land it)**: formal merge proposal into `clojure-site`, CA
  signing, relicensing, editorial sign-off.
- **Phase 5 (ongoing)**: maintenance tied to Clojure release cadence;
  community contribution process; translations considered only after the
  English version is stable (mirrors Rust's own sequencing, which blocked
  translation merges until tooling supported it).

## 9. Success Metrics (validating the hypothesis, not just "book shipped")

- **Time-to-first-deploy**: minutes from opening the book to a live URL in
  Part 1 — target under 60 minutes; this is the number that most directly
  tests the hypothesis.
- Chapter-level drop-off/completion data once hosted.
- Direct qualitative feedback: "did this get you to production?" surveyed
  from pilot participants and later from clojure.org visitors.
- Adoption of the scaffolding/deploy template outside the book itself
  (stars/uses of the companion repo).
- Reduction over time in "how do I even start" threads on Clojurians Slack
  / r/Clojure (qualitative, not a hard KPI).

## 10. Risks & Open Questions

- **Cultural fit risk**: Clojure/core has historically kept clojure.org
  guides terse and reference-oriented; a long narrative book is a
  different kind of artifact and may meet resistance regardless of merit.
  This is why Phase 0 socialization comes before any content investment.
- **Licensing**: CC BY-SA (Practicalli) vs. EPL-1.0 + Contributor
  Agreement (clojure.org) compatibility is unresolved — treat as a
  blocking legal question, not a detail.
- **Format decision**: AsciiDoc/JBake (zero migration cost, but less
  familiar to contributors and no existing code-testing tooling) vs. a
  Markdown-based approach (better contributor ergonomics, easier reuse of
  Markdown-sourced community content, but requires a parallel-infra
  conversation). Documented here as open; recommend defaulting to
  AsciiDoc/JBake unless Phase 0 socialization surfaces strong pushback.
- **Picking one deploy vendor** risks reading as clojure.org endorsing a
  commercial host. Mitigate by framing it as "the path this book teaches"
  with alternatives in an appendix, not an endorsement.
- **Maintenance burden**: the code-verification harness and the examples
  it guards need a long-term owner tied to Clojure's release cycle, or the
  book will rot exactly like the problem it's trying to solve.
- **Scope discipline**: Parts 4–5 are large. Treat Parts 1–3 as the true
  MVP — they alone already test the hypothesis (early deploy + one
  redeploy checkpoint) — and only commit to Parts 4–5 after Phase 1
  validates the core bet.
- **Volunteer bandwidth**: this is a multi-month effort even at MVP scope;
  the roadmap above assumes real authoring commitments, not a solo
  side-project pace.
