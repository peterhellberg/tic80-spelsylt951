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
    x: i32 = 75,
    y: i32 = 75,

    fn update(p: *Player) void {
        p.move();
    }

    fn move(p: *Player) void {
        if (tic.btn(0)) p.y -= 1;
        if (tic.btn(1)) p.y += 1;
        if (tic.btn(2)) p.x -= 1;
        if (tic.btn(3)) p.x += 1;
    }

    fn draw(p: *Player) void {
        tic.spr(256, p.x, p.y, .{
            .w = 2,
            .h = 2,
            .transparent = &[_]u8{0},
        });
    }
};

export fn TIC() void {
    game.update();
    game.draw();

    if (tic.btn(4)) tic.exit();
}
