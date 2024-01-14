const tic = @import("tic");

const Game = struct {
    player: Player = .{},

    fn update(g: *Game) void {
        g.player.update();
    }

    fn draw(g: *Game) void {
        tic.map(.{});

        g.player.draw();
    }
};

var game = Game{};

const Player = struct {
    a: i32 = 0,
    x: i32 = 55,
    y: i32 = 25,

    f: usize = 0,
    frames: [4]i32 = .{ 256, 258, 260, 262 },
    flip: tic.Flip = .no,

    fn update(p: *Player) void {
        p.a += 1;

        if (@mod(p.a, 8) == 0) {
            p.f = if (p.f == 3) 0 else p.f + 1;
        }

        p.move();
    }

    fn move(p: *Player) void {
        if (tic.btn(0)) p.y -= 1;
        if (tic.btn(1)) p.y += 1;
        if (tic.btn(2)) p.x -= 1;
        if (tic.btn(3)) p.x += 1;

        if (tic.btn(2)) p.flip = .horizontal;
        if (tic.btn(3)) p.flip = .no;
    }

    fn draw(p: *Player) void {
        tic.spr(p.frames[p.f], p.x, p.y, .{
            .w = 2,
            .h = 2,
            .scale = 4,
            .transparent = &[_]u8{0},
            .flip = p.flip,
        });
    }
};

export fn TIC() void {
    game.update();
    game.draw();

    if (tic.btn(4)) tic.exit();
}
