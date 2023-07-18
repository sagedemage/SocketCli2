/// Client
const std = @import("std");

pub fn main() !void {
    const client_msg = "Hello";
    const server_address = std.net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);

    // Connect to the server
    const conn = try std.net.tcpConnectToAddress(server_address);
    defer conn.close();

    // Send a message to the server
    _ = try conn.write(client_msg);

    // Notify the client that the message was sent
    std.debug.print("Message was sent to the server!\n", .{});
}
