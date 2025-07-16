#!/bin/sh

echo "💗 Support the Project 💗"
echo "This project is only maintained by one person, Fabio Cicerchia <https://github.com/fabiocicerchia>."
echo "It started as a simple docker image, now it updates automatically periodically and provides support for multiple distro 😎"
echo "Maintaining a project is a very time consuming activity, especially when done alone 💪"
echo "I really want to make this project better and become super cool 🚀"
echo ""
echo "If you'd like to support this open-source project I'll appreciate any kind of contribution <https://github.com/sponsors/fabiocicerchia>."
echo ""
echo "---"
echo ""

# track execution runs
if [ "$SKIP_TRACK" != "1" ]; then
    . /etc/os-release
    curl -m 5 "https://kodebeat.com/nginx-lua/stats/hit/boot.php?os=$ID&v=$VER_NGINX"
fi
