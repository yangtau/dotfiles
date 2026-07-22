# 公共 skill 源（进 git，可跨机复现）。纯数据，每项描述一个仓库。
# git 源：{ url; ref; rev; skills = [ { dir; name ? basename(dir); } ... ]; }
# 同一仓库的多个 skills 共享 url/ref/rev，fetchGit 后分别取 dir 子目录。
# rev 由 `skills-update` 用 git ls-remote 刷到上游最新。
[
  {
    url = "https://github.com/ShawnPana/smux.git";
    ref = "refs/heads/main";
    rev = "70a6899bdec5d3d3b51d9b927c0c0db0e22bb73f";
    skills = [
      { dir = "skills/smux"; }
    ];
  }

  {
    url = "https://github.com/mattpocock/skills.git";
    ref = "refs/heads/main";
    rev = "ed37663cc5fbef691ddfecd080dff42f7e7e350d";
    skills = [
      # call by user
      { dir = "skills/engineering/grill-with-docs"; }
      { dir = "skills/engineering/improve-codebase-architecture"; }
      { dir = "skills/engineering/setup-matt-pocock-skills"; }
      { dir = "skills/engineering/to-spec"; }
      { dir = "skills/engineering/to-issue"; }
      { dir = "skills/engineering/implement"; }
      { dir = "skills/engineering/wayfinder"; }
      { dir = "skills/productivity/grill-me"; }

      # call by model
      { dir = "skills/engineering/prototype"; }
      { dir = "skills/engineering/diagnosing-bugs"; }
      { dir = "skills/engineering/research"; }
      { dir = "skills/engineering/tdd"; }
      { dir = "skills/engineering/domain-modeling"; }
      { dir = "skills/engineering/codebase-design"; }
      { dir = "skills/engineering/code-review"; }
      { dir = "skills/engineering/resolving-merge-conflicts"; }
      { dir = "skills/productivity/grilling"; }
    ];
  }

  {
    url = "https://github.com/emilkowalski/skills.git";
    ref = "refs/heads/main";
    rev = "f6f79ca1d8e9e2d82c8b90d7481b70ca66f4adfb";
    skills = [
      { dir = "skills/emil-design-eng"; }
      { dir = "skills/apple-design"; }
    ];
  }
]
