# Contributing

This is a pre-proposal prototype (see `plan.md`, Phase 1) and not yet an
official Clojure/core project. Until it's socialized with Clojure/core and
the wider community, treat this as a working draft — expect structure and
even the license situation to be revisited before any proposal to merge
into clojure.org.

## Content policy: how we reference other people's work

The whole point of this book is to get newcomers further than existing
resources do — but that doesn't give us license to lift other people's
writing. The rule:

1. **clojure.org's own existing guide content may be reused directly.**
   It's already licensed EPL-1.0 — the same license this repo uses — and
   it's the property of the very project this book hopes to join. When
   adapting it: keep the original author/copyright notice, note what was
   changed, and record it in `NOTICE.md` (see that file for the current
   ledger).
2. **Everything else is inspiration, not source material.** Practicalli
   Clojure, ClojureBridge, Clojure for the Brave and True, Clojure
   Applied, Living Clojure, Exercism, and similar resources may inform
   *scope and pedagogy* (what to cover, what order, what a good exercise
   looks like) — ideas and structure aren't copyrightable, prose is. Link
   to these resources as further reading. Do not paraphrase or lightly
   edit their text into a chapter.
3. If a future contributor genuinely wants to adapt permissively licensed
   community text (e.g. Practicalli's CC BY-SA 4.0 material) beyond
   inspiration, that requires a real license-compatibility check first
   (CC BY-SA's share-alike terms vs. this repo's EPL-1.0) and should be
   raised as an issue before any content lands — don't do it unilaterally
   in a PR.
4. Code samples should be written fresh for this book unless they're
   trivial enough to have no reasonable claim of originality (e.g.
   `(+ 1 2)`).

## How to propose changes

Open an issue before any change larger than a typo/wording fix, describing
what you want to add or change and why — this is a narrative book, so
changes to one chapter often have ripple effects on chapters before and
after it. Once there's rough agreement, send a PR.

## Style

A full style guide doesn't exist yet (tracked as future Phase 2 work per
`plan.md`). Until then: match the voice of the already-adapted chapters in
`content/part2-foundations/` — direct, REPL-example-driven, short
paragraphs, one concept per section.
