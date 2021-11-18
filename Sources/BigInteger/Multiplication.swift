extension BigInteger {
    /*
     * Multiplies uint32 arrays mag1 and mag2 and places the result into res.
     * There will be no leading zeros in the resultant array.
     *
     * Knuth's Algorithm M
     * See Knuth, Donald,  _The Art of Computer Programming_, Vol. 2, (4.3)
     */
    func multiply(mag1 : [UInt32], mag2 : [UInt32]) -> [UInt32] {
        let m = mag1.count
        let n = mag2.count

        var res = [UInt32](repeating: 0, count: m + n) // Algo. M, M1
        var carry : UInt64 = 0
        for j in 0 ..< n {
            if mag2[j] == 0 { // Algo. M, M2
                continue
            }
            carry = 0
            for i in 0 ..< m { // Algo. M, M3
                let t = UInt64(mag1[i]) * UInt64(mag2[j]) +
                        UInt64(res[i + j]) + carry
                res[i + j] = UInt32(truncatingIfNeeded: t)
                carry = t >> 32
            }
            res[j + m] = UInt32(truncatingIfNeeded: carry)
        }

        if carry != 0 {
            res[m + n - 1] = UInt32(truncatingIfNeeded: carry)
        }

        return BigInteger.removeLeadingZeros(mag: res)
    }
}
