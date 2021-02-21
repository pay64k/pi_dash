[![build](https://github.com/pay64k/pi_dash/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/pay64k/pi_dash/actions/workflows/build.yml)

https://www.csselectronics.com/screen/page/simple-intro-obd2-explained/language/en, "Raw OBD2 frame details" chapter

OBD codes: https://en.wikipedia.org/wiki/OBD-II_PIDs#Service_01

elm emulator: https://github.com/Ircama/ELM327-emulator
switch to car, after running `elm` - `scenario car`

progress bar: https://loading.io/progress/

draw here: https://www.drawsvg.org/drawsvg.html and convert here: https://editor.method.ac/

elm commands: https://www.elmelectronics.com/wp-content/uploads/2016/07/ELM327DS.pdf

%{
  "/dev/cu.Bluetooth-Incoming-Port" => %{},
  "/dev/cu.LGSH2DD-BTSPP1" => %{},
  "/dev/cu.LGSH2DD-BTSPP2" => %{},
  "/dev/cu.LGSH2DD-BTSPP3" => %{},
  "/dev/cu.usbserial-1420" => %{
    manufacturer: "Prolific Technology Inc.",
    product_id: 8963,
    vendor_id: 1659
  }
}

https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
