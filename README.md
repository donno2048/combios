# combios

A minimal BIOS that allows embedding simple COM files in the BIOS itself.

Made specifically to make [biosnake](https://github.com/donno2048/biosnake), so if you need something less specific you have to modify it a little.

## Usage

To generate X.raw where X.com is the input COM file just run:

```sh
nasm bios.asm -D COM=X.com -o X.raw
```

