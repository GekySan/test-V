fn fibonacci(n i64) i64 {
    if n <= 0 {
        return 0
    } else if n == 1 {
        return 1
    } else if 1 <= n && n <= 92 {
		mut a := i64(0)
        asm amd64 {
            mov rcx, n
            mov rdi, 0
            mov rsi, 1
        loop_start:
            mov rax, rdi
            add rax, rsi
            mov rdi, rsi
            mov rsi, rax
            dec rcx
            jnz loop_start
            mov a, rdi
            ; =r (a)
            ; r (n)
        }
		return a
    } else {
        println('Value of n is outside the calculable range for i64.')
        return -1
    }
}

fn main() {
    for i := 0; i <= 60; i++ {
        fib_n := fibonacci(i64(i))
        println('Fibonacci($i) = $fib_n')
    }
}