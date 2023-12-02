package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"


NrTxt :: struct {
    plane: string,
    digit: rune,
}
NR_DEFS : []NrTxt : {
    {"one",     '1'},
    {"two",     '2'},
    {"three",   '3'},
    {"four",    '4'},
    {"five",    '5'},
    {"six",     '6'},
    {"seven",   '7'},
    {"eight",   '8'},
    {"nine",    '9'},
}

query_digits :: proc(line: string, digits: ^[dynamic]rune) {
    for rn, i in line {
        for def in NR_DEFS {
            if def.digit == rn || 
                i + len(def.plane) <= len(line) &&
                line[i:i + len(def.plane)] == def.plane {

                append(digits, def.digit)
            }
        }
    }
}

main :: proc() {
    data, fr_success := os.read_entire_file("input_p1.txt")
    assert(fr_success)
    data_str := strings.string_from_ptr(raw_data(data), len(data))
    lines, _ := strings.split_lines(data_str)

    builder := strings.builder_make(context.temp_allocator)
    digits_in_line := make([dynamic]rune, context.temp_allocator)
    total := 0
    for l, idx in lines {
        if len(l) == 0 {
            continue
        }

        strings.builder_reset(&builder)
        clear(&digits_in_line)

        query_digits(l, &digits_in_line)

        assert(len(digits_in_line) > 0, fmt.tprintf("At line nr: %i", idx))
        strings.write_rune(&builder, digits_in_line[0])
        strings.write_rune(&builder, digits_in_line[len(digits_in_line) -1])

        nr, success := strconv.parse_int(strings.to_string(builder))

        assert(success)
        total += nr
    }

    fmt.println(total)
}
