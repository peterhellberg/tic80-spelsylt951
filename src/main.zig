const std = @import("std");
const tic = @import("tic");

var prng = std.rand.DefaultPrng.init(0);
const random = prng.random();

const Game = struct {
    a: i32 = 0,

    player: Player = .{},

    blobs: std.BoundedArray(Blob, 256) = .{},

    fn update(g: *Game) void {
        g.a += 1;

        if (@mod(g.a, 60) == 0) {
            g.addBlob();
        }

        g.player.update();

        for (g.blobs.slice()) |*b| {
            b.update(&g.player);
        }
    }

    fn addBlob(g: *Game) void {
        const above = random.boolean();
        const left = random.boolean();

        const b: Blob = .{
            .x = if (left) random.intRangeAtMost(i32, -120, 0) else random.intRangeAtMost(i32, 240, 320),
            .y = if (above) random.intRangeAtMost(i32, -120, 0) else random.intRangeAtMost(i32, 136, 200),
            .f = random.intRangeAtMost(usize, 0, 2),
        };

        g.blobs.append(b) catch {
            _ = g.blobs.orderedRemove(0);
            g.blobs.appendAssumeCapacity(b);
        };
    }

    fn draw(g: *Game) void {
        tic.map(.{});

        g.player.draw();

        for (g.blobs.slice()) |*b| b.draw();
    }
};

var game = Game{};

const Player = struct {
    a: i32 = 0,
    x: i32 = 95,
    y: i32 = 30,

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

        if (tic.fget(tic.mget(@divFloor(p.x + 3, 8), @divFloor(p.y + 7, 8)), 0) or
            tic.fget(tic.mget(@divFloor(p.x - 3, 8), @divFloor(p.y + 7, 8)), 0))
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
        tic.spr(p.frames[p.f], p.x - 8, p.y - 8, .{
            .w = 2,
            .h = 2,
            .scale = 1,
            .transparent = &[_]u8{0},
            .flip = p.flip,
        });
    }
};

const Blob = struct {
    a: i32 = 0,
    x: i32,
    y: i32,
    f: usize,
    frames: [3]i32 = .{ 288, 289, 290 },

    fn update(b: *Blob, p: *Player) void {
        b.a += 1;

        if (@mod(b.a, 8) == 0) b.f = if (b.f == 2) 0 else b.f + 1;

        b.move(p);
    }

    fn move(b: *Blob, p: *Player) void {
        const lx = b.x;
        const ly = b.y;

        if (random.boolean()) {
            if (b.x < p.x) b.x += 1;
            if (b.x > p.x) b.x -= 1;
        } else {
            if (b.y < p.y) b.y += 1;
            if (b.y > p.y) b.y -= 1;
        }

        if (tic.fget(tic.mget(@divFloor(b.x, 8), @divFloor(b.y, 8)), 0)) {
            b.x = lx;
            b.y = ly;
        }
    }

    fn draw(b: *Blob) void {
        tic.spr(b.frames[b.f], b.x - 4, b.y - 4, .{
            .scale = 1,
            .transparent = &[_]u8{0},
        });
    }
};

export fn TIC() void {
    game.update();
    game.draw();

    if (tic.btn(4)) tic.exit();
}
