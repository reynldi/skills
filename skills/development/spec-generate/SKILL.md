---
name: spec-generate
description: Trace a feature through the codebase and generate it as an product spec or technical spec.
disable-model-invocation: true
---

Generate product or technical spec by tracing it through the code. This is extraction, not evaluation: document what exists. No critique, no best-practice commentary, no "should", no severity labels. One exception: internal contradictions (two places in the codebase or its docs disagreeing with each other) are facts and are recorded as such. Judging code against external best practice is not. Where code and docs disagree, code wins.

**Context budget**: apply the "Risk and token budget" protocol in
../development-workflow/SKILL.md; load more only when it changes the current decision.

## Inputs

- The feature to document (e.g. "authentication process", "project flow").
- Optional supporting docs: markdown files, pasted content, or Confluence.
  A Confluence URL is fetched via the Atlassian MCP; anything else is read as
  provided. Docs are secondary sources. The code is the single source of truth.

## Steps

1. **Discover.** Enumerate every flow of the feature by hunting each category
   of the discovery checklist below through the codebase. Done when every
   category is either populated with named flows or explicitly marked absent.

2. **Scope lock.** Present in one message: a one-sentence restatement of the
   feature, the discovered flow list grouped by category, and two run options:
   (a) one combined document or separate product/technical files,
   (b) detail all discovered flows or only the ones the user names.
   Done when the user confirms the flow list and both options. Do not trace
   before this.

3. **Trace.** Follow each confirmed flow from entry point to exit (response,
   persistence, event, external call). Record every file, symbol, branch, and
   error path on the route. Stop at the codebase boundary: name third-party
   calls, never descend into their internals.
   Done when every confirmed flow has an unbroken route from entry to exit.

4. **Cross-check.** Map each claim in the supporting docs to the trace, and
   run the consistency sweep: compare contract vs implementation, naming and
   taxonomy across layers, and security enforcement across entry points.
   Done when every doc claim is marked confirmed, contradicted, or out of
   scope, and every contradiction found in the sweep is recorded factually
   with both sides cited.

5. **Write.** Before writing, read the template files in this skill folder:
   `templates/PRODUCT-SPEC.md`, `templates/TECHNICAL-SPEC.md`, and, when the
   trace touches endpoints/schemas/events, `templates/CONTRACT-SPEC.md`. The
   generated documents must follow those templates' section structure and
   intent. Do not invent a different section hierarchy unless the user provides
   a replacement template.

   Fill the templates into the following output structure:
  ```md
    {target path asked by user}/
      {feature name}/
        - {feature name}-product-spec.md
        - {feature name}-technical-spec.md
        - {contract name}-contract.md
  ```
   Overview before flows in both. Section names come from the feature's own
   flows, never generic tier labels. Every claim carries a file path. If the
   trace touched no endpoint or schema, omit the contract section entirely;
   never write "N/A".
   Done when the linkage rule holds: every node in the overview chart maps to
   exactly one flow section or is marked trivial (passthrough, no internal
   branching), and every endpoint in the trace appears in the contract section.

6. **Save.** Match the repo's existing documentation convention. If none
   exists, ask where to save before writing any file.

## Discovery checklist

Hunt every category. A category with no hits is reported as absent, not skipped.

- **Lifecycle**: create, read, list, update/rename/edit, delete, archive.
- **Membership and access**: invite, assign, roles and what each role can do,
  leave, remove, transfer.
- **Visibility boundaries**: what a user outside the feature's scope sees, and
  where that boundary is enforced.
- **Propagation**: how changes reach other users and sessions (realtime events,
  websockets, notifications, cache invalidation).
- **Consumption surfaces**: every place the feature is rendered or fetched
  (lists, sidebars, detail views, each tab of a config popup), and what data
  each surface loads.
- **Bootstrap**: first-run and empty-state paths (first entity for a new
  workspace, defaults, seeding, onboarding).
- **Cross-cutting**: API contracts, data structures, security enforcement,
  naming and taxonomy across layers.

## Writing

Write every section as narration: walk the reader through the flow the way a
senior engineer explains it to a new teammate, cause to effect. "When a user
submits the login form, the request reaches AuthController, which asks
TokenService to verify the credentials. If they match, a session is created
and the client receives a JWT."

Use bullet points or numbered lists in the output as necessary to breakdown some point need to point out. No file paths inside prose; Name a class or function only when the reader needs the anchor, not for every step.
Short sentences, active voice, one flow per section, no filler.
