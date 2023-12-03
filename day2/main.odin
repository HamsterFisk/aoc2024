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
//Naked return
game_max_cubes :: proc(game: ^Game) -> (red: int, green: int, blue: int) {
    red = 0
    green = 0
    blue = 0
    for round in game.rounds {
        if round.red    > red   do red = round.red
        if round.green  > green do green = round.green
        if round.blue   > blue  do blue = round.blue
    }
    return
}
//Feed multi return into proc
rgb_power_ser :: proc(red: int, green: int, blue: int) -> int {
    return red * green * blue
}
main :: proc() {
    total_red, _   := strconv.parse_int(os.args[1])
    total_green, _ := strconv.parse_int(os.args[2])
    total_blue, _  := strconv.parse_int(os.args[3])
    
    valid_games_cumulative_id := 0

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

    //Part 1
    for game in games {
        valid := true
        for round in game.rounds {
            if round.red > total_red || round.green > total_green || round.blue > total_blue {
                valid = false
                break
            }
        }
        if valid {
            valid_games_cumulative_id += game.id
        }
    }

    fmt.println("Valid games cumulative id", valid_games_cumulative_id)

    //Part 2
    pow_prod := 0
    for game in &games {
        pow_set := rgb_power_ser(game_max_cubes(&game))
        pow_prod += pow_set
        fmt.println(pow_set)
    }
    fmt.println("Power prod:", pow_prod)
}
