extension BigInteger {
    /*
     * Adds the contents of the uint32 arrays mag1 and mag2. This method
     * allocates a new uint32 array to hold the answer and returns that array.
     *
     * Knuth's Algorithm A
     * See Knuth, Donald,  _The Art of Computer Programming_, Vol. 2, (4.3)
     */
    func add(mag1 : [UInt32], mag2 : [UInt32]) -> [UInt32] {
        var mag1 = mag1
        var mag2 = mag2
        //Add zeros if two mags don't have same length
        if mag1.count < mag2.count {
            for _ in mag1.count ..< mag2.count {
                mag1.append(0)
            }
        } else {
            for _ in mag2.count ..< mag1.count {
                mag2.append(0)
            }
        }
        let n = mag1.count
        var res = [UInt32]()

        //variable carry will keep track of carries at each step
        var carry : UInt32 = 0
        for j in 0 ..< n {
            let delta = UInt64(mag1[j]) + UInt64(mag2[j]) + UInt64(carry)
            res.append(UInt32(truncatingIfNeeded: delta))
            carry = UInt32(delta >> 32)
        }

        //means mag1[n] + mag2[n] > BASE, extra space needed
        if carry != 0 {
            res.append(carry)
        }

        return res
    }

    /*
     * Subtracts the contents of the second uint32 arrays (little) from the
     * first (big).  The first int array (big) must represent a larger number
     * than the second.  This method allocates the space necessary to hold the
     * answer.
     *
     * Knuth's Algorithm S
     * See Knuth, Donald,  _The Art of Computer Programming_, Vol. 2, (4.3)
     */
/*
    func subtract(mag1 : [UInt32], mag2 : [UInt32]) -> [UInt32] {
        var mag2 = mag2
        //Add zeros if two mags don't have same length
        if mag1.count > mag2.count {
            for _ in mag2.count ..< mag1.count {
                mag2.append(0)
            }
        }

        let n = mag1.count
        var res = [UInt32]()

        var borrow : UInt32 = 0
        for j in 0 ..< n {
            res.append((mag1[j] - mag2[j] + borrow) % BASE)
            borrow = (mag1[j] - mag2[j] + borrow) / BASE
        }

        return removeLeadingZeros(mag: res) //when a - a = 0, shrink mag to [0]
    }*/
}
