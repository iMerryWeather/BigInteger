extension BigInteger {
    /*
     * Calculates the quotient of mag1 div mag2 and the quotient and
     * the remainder mags are returned.
     *
     * Uses Algorithm D in Knuth section 4.3.1.
     *
     * let mag1 = (u_{m+n-1} ... u1 u0)
     * let mag2 = (v_{n - 1} ... v1 v0) (v_{n-1} != 0 and n > 1)
     * then this func will return:
     * q = (q_m q_{m-1} ... q0)
     * r = (r_{n - 1} ... r1 r0)
     *
     * - version: 1.1 beta 1
     */

    private func nlz(_ x : UInt32) -> Int {
        var x = x
        var n = 0
        if x == 0 { return 32 }
        if x <= 0x0000FFFF { n += 16; x <<= 16 }
        if x <= 0x00FFFFFF { n +=  8; x <<= 8  }
        if x <= 0x0FFFFFFF { n +=  4; x <<= 4  }
        if x <= 0x3FFFFFFF { n +=  2; x <<= 2  }
        if x <= 0x7FFFFFFF { n +=  1;          }

        return n
    }

    func divide(mag1 : [UInt32], mag2 : [UInt32]) -> ([UInt32], [UInt32]) {
        let u = mag1
        let v = mag2
        //calculate m & n first

        let m = u.count
        let n = v.count

        var q = [UInt32](repeating: 0, count: m - n + 1)
        var r = [UInt32](repeating: 0, count: n)
        var k : Int64 = 0
        var t : Int64 = 0
        var p : UInt64 = 0

        //compare dividend & divisor
        //TO-DO

        //Special case one word divisor
        if n == 1 {
            k = 0
            for j in (0 ..< m).reversed() {
                q[j] = UInt32(truncatingIfNeeded:
                            ((k << 32) + Int64(u[j])) / Int64(v[0]))
                k = ((k << 32) + Int64(u[j])) - Int64(q[j]) * Int64(v[0])
            }
            r.append(UInt32(k))
            return (q, r)
        }

        //normalize v & n
        let s = nlz(v[n - 1])
        var vn = [UInt32](repeating: 0, count: n)
        for i in (1 ..< n).reversed() {
            vn[i] = (v[i] << s) | UInt32((UInt64(v[i - 1]) >> (32 - s)))
        }
        vn[0] = v[0] << s

        var un = [UInt32](repeating: 0, count: m + 1)
        un[m] = UInt32((UInt64(u[m - 1]) >> (32 - s)))

        for i in (1 ..< m).reversed() {
            un[i] = UInt32(UInt64(u[i] << s) | (UInt64(u[i - 1]) >> (32 - s)))
        }
        un[0] = u[0] << s

        //main loop
        for j in (0 ... m - n).reversed() {
            //compute estimate q_hat of q[j]
            var q_hat : UInt64 =
        ((UInt64(un[j + n]) << 32) + UInt64(un[j + n - 1])) / UInt64(vn[n - 1])
            var r_hat : UInt64 =
                ((UInt64(un[j + n]) << 32) + UInt64(un[j + n - 1])) -
                    q_hat * UInt64(vn[n - 1])

            //since the while loop changes q_hat & r_hat
            //we need to re-check the condition
            func getRunning() -> Bool {
                return (q_hat >= BASE) ||
                       (q_hat * UInt64(vn[n - 2]) >
                            (UInt64(r_hat) << 32) + UInt64(un[j + n - 2]))
            }
            if getRunning() {
                    q_hat -= 1
                    r_hat += UInt64(vn[n - 1])
                while r_hat < BASE && getRunning() {
                    q_hat -= 1
                    r_hat += UInt64(vn[n - 1])
                }
            }

            //multiplication & subtraction
            k = 0
            for i in 0 ..< n {
                p = q_hat * UInt64(vn[i])
                t = Int64(un[i + j]) - k - Int64(p & 0xFFFFFFFF)
                un[i + j] = UInt32(truncatingIfNeeded: t)

                k = Int64(p >> 32) - (t >> 32)
            }
            t = Int64(un[j + n]) - k
            un[j + n] = UInt32(t)

            q[j] = UInt32(q_hat) //store quotient digit
            if t < 0 {           //if we subtracted too, add back
                q[j] -= 1
                k = 0
                for i in 0 ..< n {
                    t = Int64(un[i + j]) + Int64(vn[i]) + k
                    un[i + j] = UInt32(t)
                    k = t >> 32
                }
                un[j + n] += UInt32(k)
            }
        }

        for i in 0 ..< n {
            r[i] = (un[i] >> s) |
                   UInt32(truncatingIfNeeded: (UInt64(un[i + 1]) << (32 - s)))
        }
        r[n - 1] = un[n - 1] >> s

        return (q, r)
    }
}
