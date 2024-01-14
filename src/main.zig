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
            if (tic.btn(0) or tic.btn(1) or tic.btn(2) or tic.btn(3)) {
                p.f = if (p.f == 3) 0 else p.f + 1;
            } else {
                p.f = 0;
            }
        }

        if (tic.btn(2)) p.flip = .horizontal;
        if (tic.btn(3)) p.flip = .no;

        p.move();
    }

    fn move(p: *Player) void {
        const lx = p.x;
        const ly = p.y;

        if (tic.btn(0)) p.y -= 1;
        if (tic.btn(1)) p.y += 1;
        if (tic.btn(2)) p.x -= 1;
        if (tic.btn(3)) p.x += 1;

        if (tic.fget(tic.mget(@divFloor(p.x + 4, 8), @divFloor(p.y + 15, 8)), 0) or
            tic.fget(tic.mget(@divFloor(p.x + 11, 8), @divFloor(p.y + 15, 8)), 0))
        {
            p.x = lx;
            p.y = ly;
        }

        // Wrap around the map for now
        if (p.x < -16) p.x = 235;
        if (p.x > 240) p.x = -16;
        if (p.y < -16) p.y = 136;
        if (p.y > 136) p.y = -16;
    }

    fn draw(p: *Player) void {
        tic.spr(p.frames[p.f], p.x, p.y, .{
            .w = 2,
            .h = 2,
            .scale = 1,
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
