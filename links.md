

https://www.csselectronics.com/screen/page/simple-intro-obd2-explained/language/en, "Raw OBD2 frame details" chapter

OBD codes: https://en.wikipedia.org/wiki/OBD-II_PIDs#Service_01

https://python-obd.readthedocs.io/en/latest/Command%20Tables/

elm emulator: https://github.com/Ircama/ELM327-emulator
switch to car, after running `elm` - `scenario car`

elm commands: https://www.elmelectronics.com/wp-content/uploads/2016/07/ELM327DS.pdf


https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

https://www.pi-shop.ch/5-inch-capacitive-touch-screen-800x480-hdmi-monitor-tft-lcd-display-fuer-raspberry-pi
framebuffer_width=800
framebuffer_height=480
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=87
hdmi_cvt  800  480  60  6  0  0  0

https://desertbot.io/blog/headless-raspberry-pi-4-ssh-wifi-setup
https://desertbot.io/blog/raspberry-pi-4-touchscreen-kiosk-setup
install lightdm
change raspi-config to autologin to dektop

for vnc:
https://askubuntu.com/a/1068322
$ sudo apt-get install gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal
Then I added the lines below to ~/.vnc/xstartup:

gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
chmod +x ~/.vnc/xstartup

https://asdf-vm.com/#/core-manage-asdf
https://github.com/asdf-vm/asdf-erlang
    sudo apt-get install -y libssl-dev libncurses5-dev
https://github.com/asdf-vm/asdf-elixirasdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
https://github.com/asdf-vm/asdf-nodejs

install hex
mix local.rebar --force

add react to phoenix https://dewetblomerus.com/2018/11/30/react-on-phoenix-1-4.html
