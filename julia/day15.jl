function parse_locations()
    lines = readlines("../files/input15.txt")
    sensors_and_beacons = []
    for l in lines
        # split on ":"
        sensor, beacon = split(l, ":")
        # split on ", "
        sx_raw, sy_raw = split(sensor, ", ")
        bx_raw, by_raw = split(beacon, ", ")
        # split on "x="
        sx = parse(Int, split(sx_raw, "x=")[2])
        bx = parse(Int, split(bx_raw, "x=")[2])
        # split on "y="
        sy = parse(Int, split(sy_raw, "y=")[2])
        by = parse(Int, split(by_raw, "y=")[2])
        push!(sensors_and_beacons, [(sx, sy), (bx, by)])
    end
    return sensors_and_beacons
end

function distance(source, dest)
    return abs(source[1] - dest[1]) + abs(source[2] - dest[2])
end

function solution1()
    sensors_and_beacons = parse_locations()
    target_y = 2_000_000
    # fill set of x locations where a beacon cannot possibly be
    no_beacons_here = Set()
    for (sensor, beacon) in sensors_and_beacons
        scan_distance = distance(sensor, beacon)
        to_target = abs(target_y - sensor[2])
        coverage_size = 2 * (scan_distance - to_target) + 1
        coverage_offset = scan_distance - to_target
        if coverage_size > 0
            # add x locations covered by current sensor
            coverage_range = collect((sensor[1] - coverage_offset):(sensor[1] + coverage_offset))
            union!(no_beacons_here, Set(coverage_range))
        end
    end

    # remove beacons present on target line
    for (_, beacon) in sensors_and_beacons
        if beacon[2] == target_y && beacon[1] in no_beacons_here
            pop!(no_beacons_here, beacon[1])
        end
    end
    return length(no_beacons_here)
end


function solution2()
    sensors_and_beacons = parse_locations()
    minimum = 0
    maximum = 4_000_000
    db = (0, 0)
    i = 0
    j = 0
    # scan every position; skip over as many as possible
    while true
        found = true
        for (sensor, beacon) in sensors_and_beacons
            max_distance = distance(sensor, beacon)
            # move as far out of range as possible, then continue
            while distance(sensor, (i, j)) <= max_distance && i <= 4_000_000
                found = false
                i += (max_distance - distance(sensor, (i, j))) + 1
                if i >= 4_000_000
                    j += 1
                    i = 0
                end
            end
        end
        if found
            db = (i, j)
            break
        end
    end
    return db[1] * 4_000_000 + db[2]
end
