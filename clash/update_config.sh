#!/usr/bin/env bash
dir=$HOME/.config/clash

mv -f $dir/config.yaml $dir/config.yaml.bak
wget -O $dir/config.yaml $(cat url)
sed -i "/external/a external-ui: '${dir}/dashboard'" $dir/config.yaml
