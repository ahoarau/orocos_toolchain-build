#!/usr/bin/env bash
set -e

repo_url=https://api.github.com/repos/ahoarau/orocos_toolchain-build/releases

list_of_tags=$(curl -s $repo_url | grep tag_name | cut -d '"' -f 4)

echo "List of tags :\n$list_of_tags"

for tag in $list_of_tags; do
    latest_release_url=$(curl -s $repo_url | grep $tag | grep browser_download_url | cut -d '"' -f 4 | grep $ROS_DISTRO)
    if [ ! -z $latest_release_url ]; then
        break
    fi
done

if [ -z $latest_release_url ]; then
    echo "Could not find release for $ROS_DISTRO at URL $repo_url"
    exit 1
fi

echo "Latest URL : $latest_release_url"

cd $HOME/catkin_ws

mkdir -p $HOME/catkin_ws/install

curl -L $latest_release_url | tar xz -C $HOME/catkin_ws/install
# Avoid duplicates
rm -r $HOME/catkin_ws/install/share/industrial_ci

. $HOME/catkin_ws/install/setup.bash

