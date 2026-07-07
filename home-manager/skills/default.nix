# home-manager module：读 source → fetchGit 进 store → 声明成 home.file 软链到各 target。
# 软链/prune（删声明即删链）/gcroot 全由 home-manager 接管，本文件只做「source → home.file」的纯声明。
# 刷 rev 是正交的命令式操作，见同目录独立脚本 ./update（不经 nix）。
{ config, lib, ... }:

let
  # 纯数据源：source.nix（公共，进 git）+ source.local.nix（本机，gitignore，缺失即空）。
  readSources = f: if builtins.pathExists f then import f else [ ];
  sources = readSources ./source.nix ++ readSources ./source.local.nix;

  # 安装目标（相对 $HOME）。增删只改这里。
  targets = [
    ".claude/skills"
    ".agents/skills"
  ];
  home = config.home.homeDirectory;

  # 每个 skill × 每个 target 一个 home.file 条目。
  #   git 源      → fetchGit 进 store 取 dir（store 路径，纯 eval 允许直接软链）。
  #   纯本地目录  → mkOutOfStoreSymlink 软链到原地（不拷进 store；纯 eval 不读绝对路径，故不报错）。
  # 跳过自引用：本地目录已实体位于某 target 下时（如 aside-browser 在 ~/.agents/skills），
  # 不对该 target 建软链，否则会软链到自身。
  entriesFor =
    s:
    let
      isGit = s ? url;
      loc = if isGit then builtins.fetchGit { inherit (s) url ref rev; } + "/${s.dir}" else s.path;
      source = if isGit then loc else config.lib.file.mkOutOfStoreSymlink s.path;
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
