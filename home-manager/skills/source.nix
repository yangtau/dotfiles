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
    rev = "e9fcdf95b402d360f90f1db8d776d5dd450f9234";
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
    rev = "6bf24434f7730ad169077756cf9c7cd7bd675fc6";
    skills = [
      { dir = "skills/emil-design-eng"; }
      { dir = "skills/apple-design"; }
    ];
  }
]
