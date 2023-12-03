package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

Game :: struct {
    id:         int,
    rounds:     []Round,
}
Round :: struct {
    red:        int,
    green:      int,
    blue:       int,
}
main :: proc() {
    fmt.println("Hello day 2!")

    f_data, s_fr := os.read_entire_file("input.txt")
    assert(s_fr, "Failed to read the input file")

    puzzle_input := strings.string_from_ptr(raw_data(f_data), len(f_data))
    lines := strings.split_lines(puzzle_input)

    games := make([]Game, len(lines))
    for line, lidx in lines {
        if len(line) < 1 {
            continue
        }

        game: Game
        s_idp: bool
        game_and_rounds := strings.split(line, ": ", context.temp_allocator)
        game.id, s_idp = strconv.parse_int(strings.split(game_and_rounds[0], " ", context.temp_allocator)[1])
        assert(s_idp, "failed to parse id")

        rounds := strings.split(game_and_rounds[1], "; ", context.temp_allocator)
        game.rounds = make([]Round, len(rounds))
        for round, ridx in rounds {
            round_results := strings.split(round, ", ", context.temp_allocator)
            for res in round_results {
                nr_and_color := strings.split(res, " ", context.temp_allocator)
                nr, s_pn := strconv.parse_int(nr_and_color[0])
                assert(s_pn, "failed to parse res nr")

                switch nr_and_color[1] {
                case "red":
                    game.rounds[ridx].red += nr
                case "green":
                    game.rounds[ridx].green += nr
                case "blue":
                    game.rounds[ridx].blue += nr
                }
            }
        }
        games[lidx] = game
    }

    for game in games {
        fmt.println(game.id)
        for round in game.rounds {
            fmt.printf("red: %i, green: %i, blue: %i\n", round.red, round.green, round.blue)
        }
    }
}
