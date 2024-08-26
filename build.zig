const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // zacc_types
    const zacc_types = b.addStaticLibrary(.{
        .name = "zacc_types",
        .root_source_file = b.path("src/types.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(zacc_types);

    // zacc_reader
    const zacc_reader = b.addStaticLibrary(.{
        .name = "zacc_reader",
        .root_source_file = b.path("src/reader.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(zacc_reader);

    // zacc_utils
    const zacc_utils = b.addStaticLibrary(.{
        .name = "zacc_utils",
        .root_source_file = b.path("src/utils.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(zacc_utils);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
