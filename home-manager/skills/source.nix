# 公共 skill 源（进 git，可跨机复现）。纯数据，每项描述一个源。
# git 源：{ name; url; ref; rev; dir; }  —— fetchGit 进 store 后取 dir 子目录。
# rev 由 `skills-update` 用 git ls-remote 刷到上游最新。
[
  {
    name = "smux";
    url = "https://github.com/ShawnPana/smux.git";
    ref = "refs/heads/main";
    rev = "70a6899bdec5d3d3b51d9b927c0c0db0e22bb73f";
    dir = "skills/smux";
  }
  {
    name = "grill-me";
    url = "https://github.com/mattpocock/skills.git";
    ref = "refs/heads/main";
    rev = "d574778f94cf620fcc8ce741584093bc650a61d3";
    dir = "skills/productivity/grill-me";
  }
  {
    name = "emil-design-eng";
    url = "https://github.com/emilkowalski/skills.git";
    ref = "refs/heads/main";
    rev = "f76beceb7d3fc8c43309cefad5a095a206103a4e";
    dir = "skills/emil-design-eng";
  }
]
