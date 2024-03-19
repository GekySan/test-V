// https://projecteuler.net/problem=549

import math

fn calculate_prime_based_sum(n int) i64 {
    mut prime_values := []i64{len: n + 1, init: 1}
    prime_values[0] = 0
    prime_values[1] = 0
    for i := 2; i <= n; i++ {
        if prime_values[i] == 1 {
            mut factor := i
            mut exponent := 1
            for factor <= n {
                minimum_value := find_minimum_prime_exponent_product(i, exponent)
                for j := factor; j <= n; j += factor {
                    if prime_values[j] < minimum_value {
                        prime_values[j] = minimum_value
                    }
                }
                if i64(factor) * i64(i) > i64(n) {
                    break
                }
                factor *= i
                exponent++
            }
        }
    }

    mut sum := i64(0)
    for val in prime_values {
        sum += val
    }
    return sum
}

fn find_minimum_prime_exponent_product(prime int, exponent int) i64 {
    mut lower_bound := 1
    mut upper_bound := exponent
    for lower_bound <= upper_bound {
        middle := (lower_bound + upper_bound) / 2
        middle_value := calculate_adic_valuation(middle * prime, prime)
        if middle_value < exponent {
            lower_bound = middle + 1
        } else if middle_value == exponent {
            return i64(middle * prime)
        } else {
            upper_bound = middle - 1
        }
    }
    return i64(lower_bound * prime)
}

fn calculate_adic_valuation(number int, prime int) int {
    mut count := 0
    mut divisor := prime
    for divisor <= number {
        count += number / divisor
        if number / divisor < prime {
            break
        }
        divisor *= prime
    }
    return count
}


fn main() {
    // println(calculate_prime_based_sum(int(math.pow10(2)))) // output : 2012
	// println(calculate_prime_based_sum(int(math.pow10(6)))) // output : 64938007616
    println(calculate_prime_based_sum(int(math.pow10(8)))) // output : 476001479068717
}
