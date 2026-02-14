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
    "planning"
    "memory-manage"
    "skill-evolve"
    "skill-add"
  ];

  managedSkillsStr = lib.concatStringsSep " " managedSkills;
in
{
  age.secrets = {
    skill-issue-triage = {
      file = ../secrets/skill-issue-triage.age;
      path = "${skillsDir}/issue-triage/SKILL.md";
      mode = "0644";
    };

    skill-issue-hygiene = {
      file = ../secrets/skill-issue-hygiene.age;
      path = "${skillsDir}/issue-hygiene/SKILL.md";
      mode = "0644";
    };

    skill-issue-track = {
      file = ../secrets/skill-issue-track.age;
      path = "${skillsDir}/issue-track/SKILL.md";
      mode = "0644";
    };

    skill-pr-review = {
      file = ../secrets/skill-pr-review.age;
      path = "${skillsDir}/pr-review/SKILL.md";
      mode = "0644";
    };

    skill-planning = {
      file = ../secrets/skill-planning.age;
      path = "${skillsDir}/planning/SKILL.md";
      mode = "0644";
    };

    skill-memory-manage = {
      file = ../secrets/skill-memory-manage.age;
      path = "${skillsDir}/memory-manage/SKILL.md";
      mode = "0644";
    };

    skill-evolve = {
      file = ../secrets/skill-evolve.age;
      path = "${skillsDir}/skill-evolve/SKILL.md";
      mode = "0644";
    };

    skill-add = {
      file = ../secrets/skill-add.age;
      path = "${skillsDir}/skill-add/SKILL.md";
      mode = "0644";
    };
  };

  # Clean up stale skill directories after renames.
  # When a skill is renamed, agenix creates the new directory but doesn't
  # remove the old one (it leaves a broken symlink). This activation removes
  # any directory in ~/.claude/skills/ that:
  #   1. Contains a SKILL.md that is a symlink (i.e., agenix-managed)
  #   2. Is NOT in the current managedSkills list
  # Project skills (regular files, not symlinks) are never touched.
  home.activation.cleanStaleSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${skillsDir}" ]; then
      managed="${managedSkillsStr}"
      for dir in "${skillsDir}"/*/; do
        [ -d "$dir" ] || continue
        name="$(basename "$dir")"
        skill_file="$dir/SKILL.md"

        # Skip if not agenix-managed (no symlink = project skill)
        [ -L "$skill_file" ] || continue

        # Skip if in the managed list
        case " $managed " in
          *" $name "*) continue ;;
        esac

        # Stale agenix directory — remove it
        run rm -rf "$dir"
      done
    fi
  '';
}
