---
name: readme-write
description: >
  Write or restructure a repository README to Thomas's house template. Use when
  the user says "write a README", "update the README", "the README needs work",
  when creating a new repo, or when a README is missing its Author or License
  section.
user-invocable: true
---

# README

The canonical template lives at `~/repos/dot-github/templates/README.md`. Read
it before writing — it is the source of truth and it changes without this skill
changing.

## Structure

Badges (CI, language/version, license) → `# name` → one-line italic tagline →
the hook: what it is and why it matters, in one or two sentences → **a concrete
example that shows the thing working** (config plus output beats prose) →
features → documentation links → Author → License.

## House rules

- **The README sells, `docs/` teaches.** Quick start is 3–5 commands. Depth goes
  in `docs/` and gets linked, not inlined.
- **Author section at the bottom of every README, always:**
  `Thomas Skovlund Hansen — [skovlund.dev](https://skovlund.dev) · [thomas@skovlund.dev](mailto:thomas@skovlund.dev)`
- **License section after it** when the repo is licensed, linking the LICENSE file.
- Documentation links are grouped by Diataxis mode (Tutorials / How-to /
  Reference / Explanation) with the mode bolded — see `qed/README.md` for the
  pattern worth copying.
