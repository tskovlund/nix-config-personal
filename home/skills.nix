{ config, ... }:

let
  homeDir = config.home.homeDirectory;
  skillsDir = "${homeDir}/.claude/skills";
in
{
  age.secrets = {
    skill-linear-triage = {
      file = ../secrets/skill-linear-triage.age;
      path = "${skillsDir}/linear-triage/SKILL.md";
      mode = "0644";
    };

    skill-linear-hygiene = {
      file = ../secrets/skill-linear-hygiene.age;
      path = "${skillsDir}/linear-hygiene/SKILL.md";
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

    skill-linear-track = {
      file = ../secrets/skill-linear-track.age;
      path = "${skillsDir}/linear-track/SKILL.md";
      mode = "0644";
    };

    skill-add = {
      file = ../secrets/skill-add.age;
      path = "${skillsDir}/skill-add/SKILL.md";
      mode = "0644";
    };
  };
}
