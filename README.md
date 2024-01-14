# tic80-spelsylt951 :zap:

Using [Zig](https://ziglang.org/) to compile a `.wasm` that is
then imported into a [TIC-80](https://tic80.com/) cart.

## Jam :sweden:

Kodsnacks spelsylt9.5.1
<https://itch.io/jam/spelsylt9punkt5punkt1>

Typ fyra timmar under en söndag.
Den halvofficiella spelsylt 9.5.1.

> Streckfigur på omöjligt uppdrag.

> [!IMPORTANT]
> Du måste rita alla sprites i paint (eller liknande program, ni fattar). Gör lite som ni vill med annan grafik men huvudkaraktären ska vara (ful)ritad iaf. Tänk doodles ni gör under ett halvkul möte.
> Spelbart i browser helst.

## Development

File watcher can be started by calling:
```sh
zig build spy
```

Running TIC-80 (Pro) is done via:
```sh
zig build run
```

After exiting the cart, you can
`import binary zig-out/bin/cart.wasm`
and then `run` to load new code.

> [!Note]
> I've bound **button 4** to exit the cart.

