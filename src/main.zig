const tic = @import("tic");

export fn TIC() void {
    tic.cls(0);
    if (tic.btn(4)) tic.exit();
}
