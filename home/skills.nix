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

  # Helper: create a skill home.file entry with force = true.
  # Force is needed because agenix may have created symlinks at the same paths.
  mkSkill = name: {
    ".claude/skills/${name}/SKILL.md" = {
      source = ../skills/${name}.md;
      force = true;
    };
  };

  # Merge all skill entries into a single attrset.
  skillFiles = lib.foldl' (acc: name: acc // mkSkill name) { } managedSkills;
in
{
  home.file = skillFiles;

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
