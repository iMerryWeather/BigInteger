/*extension BigInteger {
    /*
     * Calculates the quotient of mag1 div mag2 and the quotient and
     * the remainder mags are returned.
     *
     * Uses Algorithm D in Knuth section 4.3.1.
     *
     * let mag1 = (u_{m+n-1} ... u1 u0)
     * let mag2 = (v_{n - 1} ... v1 v0) (v_{n-1} != 0 and n > 1)
     * then this func will return:
     * quo = (q_m q_{m-1} ... q0)
     *   r = (r_{n - 1} ... r1 r0)
     */
    func divide(mag1 : [UInt32], mag2 : [UInt32])
            -> (quo : [UInt32], rem : [UInt32]) {
        var mag1 = mag1
        var mag2 = mag2
        //calculate m & n first
        //mag1.count = m + n
        //mag2.cout = n
        let m = mag1.count - mag2.count
        let n = mag2.count

        //compare dividend & divisor
        //TO-DO

        //Special case one word divisor
        if n == 1 {

        }

        var d = BASE / (mag2[n - 1] + 1) // Algo. D, D1
        mag1 = multiply(mag1: mag1, mag2: [d])
        if mag1.count != m + n + 1 {
            mag1.append(0)
        }
        mag2 = multiply(mag1: mag2, mag2: [d])

        var j = m
        while j >= 0 {
            var q = (mag1[j + n] * BASE + mag1[j + n - 1]) / mag2[n - 1]
            var r = (mag1[j + n] * BASE + mag1[j + n - 1]) % mag2[n - 1]

            //test q
            while r < BASE {
                if q == BASE || q * mag2[n - 2] > BASE * r + mag1[j + n - 2] {
                    q -= 1
                    r += mag2[n - 1]
                }
            }
        }
    }
}*/