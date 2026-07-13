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
      {
        dir = "skills/smux";
      }
    ];
  }

  {
    url = "https://github.com/mattpocock/skills.git";
    ref = "refs/heads/main";
    rev = "391a2701dd948f94f56a39f7533f8eea9a859c87";
    skills = [
      {
        dir = "skills/productivity/grill-me";
      }
      {
        dir = "skills/engineering/grill-with-docs";
      }
      {
        dir = "skills/engineering/diagnosing-bugs";
      }
      {
        dir = "skills/engineering/improve-codebase-architecture";
      }
      {
        dir = "skills/engineering/tdd";
      }
      {
        dir = "skills/engineering/codebase-design";
      }
      {
        dir = "skills/productivity/grilling";
      }
      {
        dir = "skills/engineering/domain-modeling";
      }
      {
        dir = "skills/engineering/code-review";
      }
      {
        dir = "skills/engineering/setup-matt-pocock-skills";
      }
    ];
  }

  {
    url = "https://github.com/emilkowalski/skills.git";
    ref = "refs/heads/main";
    rev = "7bb7061b5cf7de15ea1aeaf00fbd9e6592a20fce";
    skills = [
      {
        dir = "skills/emil-design-eng";
      }
      {
        dir = "skills/apple-design";
      }
    ];
  }
]
