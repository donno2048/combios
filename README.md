# combios

A minimal BIOS that allows embedding simple COM files in the BIOS itself.

It could be even smaller but I tried making it so that it would work on as much hardware as I can, not only on qemu.

## Usage

To generate X.raw where X.com is the input COM file just run:

```sh
nasm bios.asm -D COM=X.com -o X.raw
```

[CP437.F16](./CP437.F16) was taken from https://github.com/viler-int10h/vga-text-mode-fonts
