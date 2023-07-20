/// Client
const std = @import("std");

pub fn main() !void {
    // General Purpose Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.allocator();
    const allocator = gpa.allocator();

    // Command Line Arguments
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    switch (args.len) {
        3 => {
            const arg: u8 = args[1][0];
            if (arg == 'i') {
                _ = try send_message_to_server(args[2]);
            } else {
                std.debug.print("Option does not exist!\n", .{});
            }
        },
        2 => {
            const arg: u8 = args[1][0];
            if (arg == 'd') {
                // send message to server
                const client_msg: []const u8 = "Hello";
                _ = try send_message_to_server(client_msg);
            } else if (arg == 'i') {
                std.debug.print("Missing input value!\n", .{});
            } else {
                std.debug.print("Option does not exist!\n", .{});
            }
        },
        1 => {
            const stdin = std.io.getStdIn();

            // Get user input
            std.debug.print("Enter your message here: ", .{});
            const input = try stdin.reader().readUntilDelimiterAlloc(allocator, '\n', 1024);
            defer allocator.free(input);

            _ = try send_message_to_server(input);
        },
        else => {
            std.debug.print("Too many commnd line arguments!\n", .{});
        },
    }
}

fn send_message_to_server(msg: []const u8) !void {
    // Send a message to the server
    const server_address = std.net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);

    // Connect to the server
    const conn = try std.net.tcpConnectToAddress(server_address);
    defer conn.close();

    // Send a message to the server
    _ = try conn.write(msg);

    // Notify the client that the message was sent
    std.debug.print("Message was sent to the server!\n", .{});
}
