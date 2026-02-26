{ config, lib, ... }:

let
  homeDir = config.home.homeDirectory;
  skillsDir = "${homeDir}/.claude/skills";

  # List of skill directory names managed by this module.
  # Used by the cleanup activation to remove stale directories after renames.
  managedSkills = [
    "issue-triage"
    "issue-hygiene"
    "issue-track"
    "pr-review"
    "pr-review-loop"
    "pr-fix"
    "planning"
    "memory-recall"
    "memory-store"
    "skill-evolve"
    "skill-add"
    "skill-update"
    "repo-sync"
    "docs"
    "skill-write"
    "test-write"
    "dep-update"
    "onboard"
  ];

  managedSkillsStr = lib.concatStringsSep " " managedSkills;
in
{
  home.file = {
    ".claude/skills/issue-triage/SKILL.md".source = ../skills/issue-triage.md;
    ".claude/skills/issue-hygiene/SKILL.md".source = ../skills/issue-hygiene.md;
    ".claude/skills/issue-track/SKILL.md".source = ../skills/issue-track.md;
    ".claude/skills/pr-review/SKILL.md".source = ../skills/pr-review.md;
    ".claude/skills/pr-review-loop/SKILL.md".source = ../skills/pr-review-loop.md;
    ".claude/skills/pr-fix/SKILL.md".source = ../skills/pr-fix.md;
    ".claude/skills/planning/SKILL.md".source = ../skills/planning.md;
    ".claude/skills/memory-recall/SKILL.md".source = ../skills/memory-recall.md;
    ".claude/skills/memory-store/SKILL.md".source = ../skills/memory-store.md;
    ".claude/skills/skill-evolve/SKILL.md".source = ../skills/skill-evolve.md;
    ".claude/skills/skill-add/SKILL.md".source = ../skills/skill-add.md;
    ".claude/skills/skill-update/SKILL.md".source = ../skills/skill-update.md;
    ".claude/skills/repo-sync/SKILL.md".source = ../skills/repo-sync.md;
    ".claude/skills/docs/SKILL.md".source = ../skills/docs.md;
    ".claude/skills/skill-write/SKILL.md".source = ../skills/skill-write.md;
    ".claude/skills/test-write/SKILL.md".source = ../skills/test-write.md;
    ".claude/skills/dep-update/SKILL.md".source = ../skills/dep-update.md;
    ".claude/skills/onboard/SKILL.md".source = ../skills/onboard.md;
  };

  # Clean up stale skill directories after renames.
  # When a skill is renamed, home-manager creates the new directory but doesn't
  # remove the old one (it leaves a broken symlink). This activation removes
  # any directory in ~/.claude/skills/ that:
  #   1. Contains a SKILL.md that is a symlink (i.e., home-manager-managed)
  #   2. Is NOT in the current managedSkills list
  # Project skills (regular files, not symlinks) are never touched.
  home.activation.cleanStaleSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${skillsDir}" ]; then
      managed="${managedSkillsStr}"
      for dir in "${skillsDir}"/*/; do
        [ -d "$dir" ] || continue
        name="$(basename "$dir")"
        skill_file="$dir/SKILL.md"

        # Skip if not home-manager-managed (no symlink = project skill)
        [ -L "$skill_file" ] || continue

        # Skip if in the managed list
        case " $managed " in
          *" $name "*) continue ;;
        esac

        # Stale home-manager directory — remove it
        run rm -rf "$dir"
      done
    fi
  '';
}
