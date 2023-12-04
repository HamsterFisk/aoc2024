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

get_surroundings :: proc(schema: []int, stride: int, pos: int) -> (surroundings: [8]int) {
    first_row := pos - stride < 0
    last_row := pos + stride >= len(schema)
    first_col := (pos % stride) - 1 < 0
    last_col := (pos % stride) + 1 >= stride

    if !first_row {
        if !first_col do surroundings[0] = schema[(pos - stride) -1]
        surroundings[1] = schema[pos - stride]
        if !last_col do surroundings[2] = schema[(pos - stride) +1]
    }

    if !first_col do surroundings[3] = schema[pos -1]
    if !last_col do surroundings[4] = schema[pos +1]

    if !last_row {
        if !first_col do surroundings[5] = schema[(pos + stride) -1]
        surroundings[6] = schema[pos + stride]
        if !last_col do surroundings[7] = schema[(pos + stride) +1]
    }

    return
}

main :: proc() {
    fmt.println("Hello day3!")

    data, s_f := os.read_entire_file("input.txt")
    assert(s_f, "Failed to read file")

    puzzle_input := strings.string_from_ptr(raw_data(data), len(data))
    lines, _ := strings.split_lines(puzzle_input, context.temp_allocator)
    lines = lines[0:len(lines) -1]

    defs := make([dynamic]int)
    append(&defs, 0)

    stride := len(lines[0])
    schema := make([]int, len(lines[0]) * len(lines))

    symbols := make([dynamic]int)

    nr_builder := strings.builder_make(context.temp_allocator)
    for line, lidx in lines {
        for i := 0; i < len(line); i += 1 {
            if is_digit(line[i]) {
                strings.write_byte(&nr_builder, line[i])
                schema[i + stride * lidx] = len(defs)
                continue
            }

            if strings.builder_len(nr_builder) > 0 {
                nr, s_conv := strconv.parse_int(strings.to_string(nr_builder))
                assert(s_conv, fmt.tprintf("Failed to convert %s to an int", strings.to_string(nr_builder)))
                append(&defs, nr)
                strings.builder_reset(&nr_builder)
            }

            if is_empty(line[i]) {
                schema[i + stride * lidx] = 0
            } else {
                schema[i + stride * lidx] = -1
                append(&symbols, i + stride * lidx)
            }
        }
    }

    for i := 0; i < len(schema); i += 1 {
        if i % stride == 0 {
            fmt.println("")
        }
        fmt.printf("%i, ", schema[i])
    }

    /*
    fmt.println("\nDefs:")
    fmt.println(defs)

    fmt.println("Symbols:")
    fmt.println(symbols)
    for i in symbols {
        fmt.println(cast(rune)puzzle_input[i])
    }
    */

    unique_part_nrs := make([dynamic]int, context.temp_allocator)
    for symbol in symbols {
        for i in get_surroundings(schema, stride, symbol) {
            excists := false
            for pnr in unique_part_nrs {
                if defs[i] == pnr {
                    excists = true
                    break
                }
            }

            if !excists do append(&unique_part_nrs, defs[i])
        }
    }

    pnr_sum := 0
    for pnr in unique_part_nrs {
        fmt.println(pnr)
        pnr_sum += pnr
    }

    fmt.printf("Part nr sum: %i\n", pnr_sum)
}





