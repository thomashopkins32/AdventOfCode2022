use std::fs;
use std::time::{Instant};

fn solution1() -> i32 {
    let all_lines = fs::read_to_string("../files/input1.txt").unwrap();
    let by_elf = all_lines.split("\n\n");
    let mut elf_cal_counts = Vec::new();
    for e in by_elf {
        let by_food = e.split("\n");
        let mut total = 0;
        for f in by_food {
            if f != "" {
                total += f.parse::<i32>().unwrap();
            }
        }
        elf_cal_counts.push(total);
    }
    elf_cal_counts.sort();
    elf_cal_counts.reverse();
    return elf_cal_counts[0];
}

fn solution2() -> i32 {
    let all_lines = fs::read_to_string("../files/input1.txt").unwrap();
    let by_elf = all_lines.split("\n\n");
    let mut elf_cal_counts = Vec::new();
    for e in by_elf {
        let by_food = e.split("\n");
        let mut total = 0;
        for f in by_food {
            if f != "" {
                total += f.parse::<i32>().unwrap();
            }
        }
        elf_cal_counts.push(total);
    }
    elf_cal_counts.sort();
    elf_cal_counts.reverse();
    return elf_cal_counts.iter().take(3).sum();
}

fn main() {
    let now = Instant::now();
    let sol1 = solution1();
    println!("Solution 1: {}; Time: {}", sol1, (now.elapsed().subsec_nanos() as f64) * 1e-9);
    let now = Instant::now();
    let sol2 = solution2();
    println!("Solution 2: {}; Time: {}", sol2, (now.elapsed().subsec_nanos() as f64) * 1e-9);
}
