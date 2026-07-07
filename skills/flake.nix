{
  description = "声明式 agent skills：拼 bundle 并软链到 ~/.claude/skills 与 ~/.agents/skills";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # skill 公共源（flake=false，直接当 store 路径用）；byted 内网源在 skills.local.nix 内联 fetchGit
    smux = {
      url = "github:ShawnPana/smux";
      flake = false;
    };
    lark-cli = {
      url = "github:larksuite/cli";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    emilkowalski-skills = {
      url = "github:emilkowalski/skills";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs
    , ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      # 公共 skill：源 + 子目录 + 名字，一处集中声明（flake input，可 nix flake update 升级）
      commonSkills = [
        {
          name = "smux";
          path = "${inputs.smux}/skills/smux";
        }
        {
          name = "lark-doc";
          path = "${inputs.lark-cli}/skills/lark-doc";
        }
        {
          name = "lark-whiteboard";
          path = "${inputs.lark-cli}/skills/lark-whiteboard";
        }
        {
          name = "grill-me";
          path = "${inputs.mattpocock-skills}/skills/productivity/grill-me";
        }
        {
          name = "emil-design";
          path = "${inputs.emilkowalski-skills}/skills/emil-design-eng";
        }
      ];
      # 本机专属 skill（byted 内网源，gitignore 不进 git；缺此文件即只装公共部分）
      localSkills = if builtins.pathExists ./skills.local.nix then import ./skills.local.nix else [ ];
      skillsBundle = pkgs.linkFarm "agent-skills" (commonSkills ++ localSkills);

      # 安装目标目录：与 skill 源并列的一份可配置输入。增删目标只改这里，$HOME 运行时展开。
      targets = [
        "$HOME/.claude/skills" # Claude 自身
        "$HOME/.agents/skills" # 其他 agent CLI 共用
      ];

      # 单命令安装：把 bundle 里每个 skill 软链进各 target，并清理上一版残留。
      # 精准 prune：只删「指向本 flake 生成的 agent-skills bundle、但已不在当前 bundle 里」的软链；
      # 本地手装（npx skills 等）的普通目录 / 指向别处的软链一律不碰。
      targetsShell = pkgs.lib.concatMapStringsSep " " (t: "\"${t}\"") targets;
      skillsSync = pkgs.writeShellApplication {
        name = "skills-sync";
        text = ''
          bundle="${skillsBundle}"
          for dest in ${targetsShell}; do
            mkdir -p "$dest"
            # 清理：删掉本 flake 之前装、如今已从 flake 移除的 skill
            for f in "$dest"/*; do
              [ -L "$f" ] || continue                 # 非软链（本地目录）→ 跳过
              tgt=$(readlink "$f")
              case "$tgt" in
                *-agent-skills/*) ;;                  # 是我们装的，继续判断
                *) continue ;;                        # 指向别处的本地软链 → 跳过
              esac
              [ -e "$bundle/$(basename "$f")" ] || rm "$f"  # 当前 bundle 已无 → 删
            done
            # 安装 / 更新
            for s in "$bundle"/*; do
              ln -sfn "$s" "$dest/$(basename "$s")"
            done
          done
          n=$(find "$bundle" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')
          echo "$n skills → ${pkgs.lib.concatStringsSep "、" targets}"
        '';
      };
    in
    {
      packages.${system} = {
        skills = skillsSync;
        skills-bundle = skillsBundle;
      };
      apps.${system} = {
        skills = {
          type = "app";
          program = "${skillsSync}/bin/skills-sync";
        };
        default = {
          type = "app";
          program = "${skillsSync}/bin/skills-sync";
        };
      };
    };
}
