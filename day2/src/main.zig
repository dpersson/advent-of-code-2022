const std = @import("std");
const allocator = std.heap.page_allocator;
const split = std.mem.split;

const Data = struct {
  opponent: u8,
  me: u8,
};

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    const List = std.ArrayList(Data);
    var list = List.init(allocator);
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // std.debug.print("{s}\n", .{line});
        var splitter = split(u8, line, " ");


        const opponent = splitter.next().?;
        const me = splitter.next().?;
        list.append(Data{.opponent = opponent[0], .me = me[0]}) catch unreachable;
    }

    calcPart2(list);
}

// A: Rock      1
// B: Paper     2
// C: Scissor   3
// X: Rock      1
// Y: Paper     2
// Z: Scissor   3
// Win          6
// Draw         3
// Loose        0
pub fn calcPart1(list: std.ArrayList(Data)) void {
    var localscore: i32 = 0;
    var totalscore: i32 = 0;
    var x = list.items;
    for (x) |item| {
        localscore = 0;
        std.debug.print("opponent: {c}, me: {c}\n", .{item.opponent, item.me});
        if(item.opponent == 'A' and item.me == 'Y') {
            localscore = 2 + 6;
        }
        if(item.opponent == 'B' and item.me == 'X') {
            localscore = 1 + 0;
        }
        if(item.opponent == 'C' and item.me == 'Z') {
            localscore = 3 + 3;
        }
        if(item.opponent == 'A' and item.me == 'X') {
            localscore = 1 + 3;
        }
        if(item.opponent == 'A' and item.me == 'Z') {
            localscore = 3 + 0;
        }
        if(item.opponent == 'B' and item.me == 'Y') {
            localscore = 2 + 3;
        }
        if(item.opponent == 'B' and item.me == 'Z') {
            localscore = 3 + 6;
        }
        if(item.opponent == 'C' and item.me == 'X') {
            localscore = 1 + 6;
        }
        if(item.opponent == 'C' and item.me == 'Y') {
            localscore = 2 + 0;
        }

        totalscore = totalscore + localscore;
    }

    std.debug.print("{d}\n", .{totalscore});
}

// A: Rock      1
// B: Paper     2
// C: Scissor   3
// X: Loose
// Y: Draw
// Z: Win
// Win          6
// Draw         3
// Loose        0
pub fn calcPart2(list: std.ArrayList(Data)) void {
    var localscore: i32 = 0;
    var totalscore: i32 = 0;
    var x = list.items;
    for (x) |item| {
        localscore = 0;
        // std.debug.print("opponent: {c}, me: {c}\n", .{item.opponent, item.me});
        if(item.opponent == 'A' and item.me == 'Y') {
            localscore = 1 + 3;
        }
        else if(item.opponent == 'B' and item.me == 'X') {
            localscore = 1 + 0;
        }
        else if(item.opponent == 'C' and item.me == 'Z') {
            localscore = 1 + 6;
        }
        else if(item.opponent == 'A' and item.me == 'X') {
            localscore = 3 + 0;
        }
        else if(item.opponent == 'A' and item.me == 'Z') {
            localscore = 2 + 6;
        }
        else if(item.opponent == 'B' and item.me == 'Y') {
            localscore = 2 + 3;
        }
        else if(item.opponent == 'B' and item.me == 'Z') {
            localscore = 3 + 6;
        }
        else if(item.opponent == 'C' and item.me == 'X') {
            localscore = 2 + 0;
        }
        else if(item.opponent == 'C' and item.me == 'Y') {
            localscore = 3 + 3;
        }
        else {
            std.debug.print("unhandled case: {d}\n", .{totalscore});
        }

        totalscore = totalscore + localscore;
    }

    std.debug.print("{d}\n", .{totalscore});
}

test "calcPart1" {
    var list = std.ArrayList(Data).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    list.append(Data{.opponent = 'A', .me = 'Y'}) catch unreachable;
    list.append(Data{.opponent = 'B', .me = 'X'}) catch unreachable;
    list.append(Data{.opponent = 'C', .me = 'Z'}) catch unreachable;
    calcPart2(list);
}
