const std = @import("std");
const fmt = std.fmt;
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

fn cmpByData(_: void, a: Data, b: Data) bool {
    if (a.data < b.data) {
      return true;
    } else {
      return false;
    }
}

const Data = struct {
  data: i32,
};

pub fn main() anyerror!void {
    var file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var localmax: i32 = 0;
    var max: i32 = 0;
    const List = std.ArrayList(Data);
    var list = List.init(allocator);

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (std.mem.eql(u8, "", line)) {
            std.debug.print("{d}\n", .{localmax});
            list.append(Data{.data = localmax}) catch unreachable;
            if (localmax > max) {
                max = localmax;
            }
            localmax = 0;
        } else {
            const localtemp =  fmt.parseUnsigned(i32, line, 10) catch |err| {
                std.debug.print("I jar!\n{s}\n", .{ @errorName(err) });
                continue;
            };
            localmax = localmax + localtemp;
        }
    }

    var x = list.items;
    std.sort.sort(Data, x, {}, cmpByData);
    for (x) |item| {
        std.debug.print("{},", .{item});
    }
    allocator.free(x);
}

