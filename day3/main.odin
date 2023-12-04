package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

is_digit :: proc(c: u8) -> bool {
    return c >= '0' && c <= '9'
}
is_empty :: proc(c: u8) -> bool {
    return c == '.'
}

main :: proc() {
    fmt.println("Hello day3!")

    data, s_f := os.read_entire_file("input.txt")
    assert(s_f, "Failed to read file")

    puzzle_input := strings.string_from_ptr(raw_data(data), len(data))
    lines, _ := strings.split_lines(puzzle_input, context.temp_allocator)

    defs := make([dynamic]int)
    append(&defs, 0)

    stride := len(lines[0])
    schema := make([]int, len(puzzle_input))

    symbols := make([dynamic]int)

    nr_builder := strings.builder(context.temp_allocator)
    for line, lidx in lines {
        for i := 0; i < len(line); i += 1 {
            if is_empty(line[i]) {
                schema[i][lidx] = 0
                continue
            }

            for true {
                if !is_digit(line[i]) || i >= len(line) {
                    nr, s_conv := strconv.parse_int(strings.to_string(nr_builder))
                    assert(s_conv, fmt.tprintf("Failed to convert %s to an int", strings.to_string(nr_builder), context.temp_allocator))
                    append(&defs, nr)
                    break
                }
                schema[i + stride * lidx] = len(defs)
                i += 1
            }

            strings.builder_reset(&nr_builder)
            append(&symbols, i + stride * lidx)
        }
    }

    for i := 0; i < len(lines); i += 1 {
        for j := 0; j < stride; j += 1 {
            fmt.printf("%i, ", 
        }
    }
}
