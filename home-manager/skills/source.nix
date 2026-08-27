# 公共 skill 源（进 git，可跨机复现）。纯数据，每项描述一个仓库。
# git 源：{ url; ref; rev; skills = [ { dir; name ? basename(dir); } ... ]; }
# 同一仓库的多个 skills 共享 url/ref/rev，fetchGit 后分别取 dir 子目录。
# rev 由 `skills-update` 用 git ls-remote 刷到上游最新。
[

  {
    # lark-cli 统一入口：上游全部 lark-* 子域合并进个人仓库 router 的 references/subskills/ 下。
    url = "https://github.com/larksuite/cli.git";
    ref = "refs/heads/main";
    rev = "0d5334a0cdfdf18b0313ba051befb2848493ecda";
    unified = {
      name = "lark-cli";
      srcGlob = "skills/lark-*";
      dest = "references/subskills";
      router = {
        url = "https://github.com/yangtau/skills.git";
        ref = "refs/heads/main";
        rev = "f61733fd9a5bba88aeb288a0aea04ff0747ea95c";
        dir = "skills/lark-cli";
      };
    };
  }

  {
    url = "https://github.com/ShawnPana/smux.git";
    ref = "refs/heads/main";
    rev = "f8f591b0b7966b210aa0b68f4f3bce54cf64e07b";
    skills = [
      { dir = "skills/smux"; }
    ];
  }

  {
    url = "https://github.com/mattpocock/skills.git";
    ref = "refs/heads/main";
    rev = "6654f6b60cd9d5be8b54c6fafe44346dabeb3b76";
    skills = [
      # call by user
      # { dir = "skills/engineering/ask-matt"; }
      { dir = "skills/engineering/grill-with-docs"; }
      # { dir = "skills/engineering/triage"; }
      { dir = "skills/engineering/improve-codebase-architecture"; }
      # { dir = "skills/engineering/setup-matt-pocock-skills"; }
      { dir = "skills/engineering/to-spec"; }
      # { dir = "skills/engineering/to-tickets"; }
      # { dir = "skills/engineering/implement"; }
      # { dir = "skills/engineering/wayfinder"; }

      { dir = "skills/productivity/grill-me"; }
      { dir = "skills/productivity/handoff"; }
      # { dir = "skills/productivity/wait-what"; }

      # call by model
      # { dir = "skills/engineering/prototype"; }
      # { dir = "skills/engineering/diagnosing-bugs"; }
      # { dir = "skills/engineering/research"; }
      { dir = "skills/engineering/tdd"; }
      { dir = "skills/engineering/domain-modeling"; }
      { dir = "skills/engineering/codebase-design"; }
      # { dir = "skills/engineering/code-review"; }
      { dir = "skills/engineering/resolving-merge-conflicts"; }
      # { dir = "skills/engineering/wizard"; }

      { dir = "skills/productivity/grilling"; }
      { dir = "skills/productivity/writing-for-agents"; }
    ];
  }

  {
    url = "https://github.com/emilkowalski/skills.git";
    ref = "refs/heads/main";
    rev = "d23d7f88a2e21c9e4b1418c7abe420f5c1052ba7";
    skills = [
      # { dir = "skills/emil-design-eng"; }
      { dir = "skills/apple-design"; }
    ];
  }
]
