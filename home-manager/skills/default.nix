# home-manager module：读 source → fetchGit 进 store → 声明成 home.file 软链到各 target。
# 软链/prune（删声明即删链）/gcroot 全由 home-manager 接管，本文件只做「source → home.file」的纯声明。
# 刷 rev 是正交的命令式操作，见同目录独立脚本 ./update（不经 nix）。
{ config, lib, pkgs, ... }:

let
  # 纯数据源：source.nix（公共，进 git）+ source.local.nix（本机，gitignore，缺失即空）。
  readSources = f: if builtins.pathExists f then import f else [ ];
  sourceGroups = readSources ./source.nix ++ readSources ./source.local.nix;

  # 一个 git 仓库可以声明多个 skills，避免重复 url/ref/rev。
  # name 可省略，默认取 dir 的最后一段；显式 name 可用于别名。
  # 带 unified 的源不展开为 N 条，产出一条合并 skill（见 mergeSkill）。
  # 旧的单 skill 项和 { name; path; } 本地源仍保持兼容。
  expandSource =
    source:
    if source ? unified then
      [ (source // { name = source.unified.name; }) ]
    else if source ? skills then
      map (skill: removeAttrs source [ "skills" ] // skill) source.skills
    else
      [ source ];
  withDefaultName =
    source:
    source
    // {
      name =
        if source ? name then
          source.name
        else if source ? dir then
          builtins.baseNameOf source.dir
        else
          throw "skill source must define name or dir";
    };
  sources = map withDefaultName (lib.concatMap expandSource sourceGroups);

  # 合并 skill：把上游仓库按 glob 匹配的子域目录拷进 router 的 dest 下，
  # 再铺上 router（个人仓库的 SKILL.md 等）。子域互为兄弟目录，内部 ../ 相对引用保持成立。
  # srcGlob 相对上游仓库根（如 "skills/lark-*"）；dest 相对 skill 根（如 "references/subskills"）。
  # derivation 输出是真实 store path，与 fetchGit 分支同样「纯 eval 直接软链」。
  mergeSkill =
    s:
    let
      u = s.unified;
      repo = builtins.fetchGit { inherit (s) url ref rev; };
      r = u.router;
      routerRepo = builtins.fetchGit { inherit (r) url ref rev; } + "/${r.dir}";
    in
    pkgs.runCommand "${u.name}-skill" { } ''
      mkdir -p "$out/${u.dest}"
      cp -R "${repo}"/${u.srcGlob}/ "$out/${u.dest}/"
      chmod -R u+w "$out/${u.dest}"
      # 宿主会递归发现子目录里的 SKILL.md 并当成独立 skill：子域入口统一改名 GUIDE.md，
      # 并把树内所有 SKILL.md 引用一并改写；router 自身的 SKILL.md 最后拷入，不受影响。
      find "$out/${u.dest}" -name SKILL.md -execdir mv {} GUIDE.md \;
      grep -rl 'SKILL\.md' "$out/${u.dest}" --include='*.md' \
        | xargs -r sed -i 's/SKILL\.md/GUIDE.md/g'
      # 还原指向外部运行时文件的路径（不在本树内，真实文件名就是 SKILL.md，不该改写）。
      grep -rl 'plugin-guide/GUIDE\.md' "$out/${u.dest}" --include='*.md' \
        | xargs -r sed -i 's#plugin-guide/GUIDE\.md#plugin-guide/SKILL.md#g'
      cp -R ${routerRepo}/. $out/
    '';

  # 安装目标（相对 $HOME）。增删只改这里。
  targets = [
    ".agents/skills"
    ".claude/skills"
  ];
  home = config.home.homeDirectory;

  # 每个 skill × 每个 target 一个 home.file 条目。
  #   git 源      → fetchGit 进 store 取 dir（store 路径，纯 eval 允许直接软链）。
  #   unified 源  → mergeSkill 合并上游子域与 router，软链整个 derivation 输出。
  #   纯本地目录  → mkOutOfStoreSymlink 软链到原地（不拷进 store；纯 eval 不读绝对路径，故不报错）。
  # 跳过自引用：本地目录已实体位于某 target 下时（如 aside-browser 在 ~/.agents/skills），
  # 不对该 target 建软链，否则会软链到自身。
  entriesFor =
    s:
    let
      isUnified = s ? unified;
      isGit = !isUnified && s ? url;
      loc =
        if isUnified then mergeSkill s
        else if isGit then builtins.fetchGit { inherit (s) url ref rev; } + "/${s.dir}"
        else s.path;
      source = if isUnified || isGit then loc else config.lib.file.mkOutOfStoreSymlink s.path;
    in
    lib.pipe targets [
      (map (
        t:
        let
          link = "${home}/${t}/${s.name}";
        in
        if toString loc == link then null else lib.nameValuePair "${t}/${s.name}" { inherit source; }
      ))
      (lib.filter (e: e != null))
    ];
in
{
  home.file = builtins.listToAttrs (lib.concatMap entriesFor sources);
}
