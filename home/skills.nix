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

    skill-pr-review-loop = {
      file = ../secrets/skill-pr-review-loop.age;
      path = "${skillsDir}/pr-review-loop/SKILL.md";
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
  };
}
