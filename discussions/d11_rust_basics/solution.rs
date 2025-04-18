fn main() {
    let mut x = 0; // need x to be mutable!
    for i in 1..=500 { // loop from 1 to 500 inclusive
        if is_prime(i) {
            println!("{:?} is prime!", i);
            x += 1; // increment x if prime
        } else {
            println!("{:?} is composite!", i);
        }
    }
    println!("We found {:?} primes from 1 to 500!", x);
}

fn is_prime(n: u32) -> bool {
    if n <= 1 {
        return false; // 0 and 1 are not prime
    }

    // Check for factors from 2 to the square root of n
    for i in 2..=(n as f64).sqrt() as u32 { // equal sign is for inclusive
        if n % i == 0 {
            return false; // If divisible by any number, it's not prime
        }
    }

    true // If no factors found, it's prime
}
