extension BigInteger {
    /*
     * Adds the contents of the uint32 arrays mag1 and mag2. This method
     * allocates a new uint32 array to hold the answer and returns that array.
     *
     * Knuth's Algorithm A
     * See Knuth, Donald,  _The Art of Computer Programming_, Vol. 2, (4.3)
     */
    static func add(mag1 : [UInt32], mag2 : [UInt32]) -> [UInt32] {
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

    static func subtract(mag1 : [UInt32], mag2 : [UInt32]) -> [UInt32] {
        var mag2 = mag2
        //Add zeros if two mags don't have same length
        if mag1.count > mag2.count {
            for _ in mag2.count ..< mag1.count {
                mag2.append(0)
            }
        }

        let n = mag1.count
        var res = [UInt32]()

        var borrow : Int64 = 0
        for j in 0 ..< n {
            //borrow is either -1 or 0, which is signed
            let delta = Int64(mag1[j]) &- Int64(mag2[j]) + borrow
            res.append(UInt32(truncatingIfNeeded: delta))
            borrow = delta >> 32
        }

        return BigInteger.removeLeadingZeros(mag: res) //when a - a = 0, shrink mag to [0]
    }
}

//Add two BigIntegers
extension BigInteger {
    /*
     * Add two BigInteger
     * We use |a| to represent mag of a here.
     *     a   |   b   |        c
     *   sign1 | sign2 |      result
     *   ------|-------|-----------------
     *     +   |   +   |     c = |a| + |b|    //case 1
     *     +   |   -   |     c = |a| - |b|    //case 2, go subtract
     *     -   |   +   |     c = |b| - |a|    //case 3, go subtract
     *     -   |   -   |     c = -(|a| + |b|) //case 4
     */
    private static func add(lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        var lhs = lhs
        var rhs = rhs
        if lhs.signum && rhs.signum { //case 1
            return BigInteger(signum: true,
                              mag: add(mag1: lhs.mag, mag2: rhs.mag))
        } else if lhs.signum && (!rhs.signum) { //case 2
            rhs.negate()
            return lhs - rhs
        } else if (!lhs.signum) && rhs.signum { //case 3
            lhs.negate()
            return rhs - lhs
        } else { //case 4
            return BigInteger(signum: false,
                              mag: add(mag1: lhs.mag, mag2: rhs.mag))
        }
    }
}

//Operator wrappers +
extension BigInteger {
    public static func + (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return add(lhs: lhs, rhs: rhs)
    }
}

//Subtract two BigIntegers
extension BigInteger {
    /*
     * Sub two BigInteger
     * We use |a| to represent mag of a here.
     *
     *     a   |   b   |        c
     *   sign1 | sign2 |      result
     *   ------|-------|-----------------
     *     +   |   +   |     c = |a| - |b|                      //case 1
     *     +   |   -   |     c = |a| + |b|                      //case 2, go add
     *     -   |   +   |     c = (-|a|) - (+|b|) = -(|a| + |b|) //case 3, go add
     *     -   |   -   |     c = -(|a|) - (-|b|) = |b| - |a|    //case 4
     * In subtractMag(), we need to make sure always big - small
     */
    private static func subtract(lhs : BigInteger, rhs : BigInteger)
                        -> BigInteger {
        var rhs = rhs
        var c : BigInteger
        if lhs.signum && rhs.signum {
            if BigInteger.compareMag(mag1: lhs.mag, mag2: rhs.mag) { //gets a-b
                c = BigInteger(signum: true, mag: subtract(mag1: lhs.mag,
                                                           mag2: rhs.mag))
            } else { //gets -(b - a)
                c = BigInteger(signum: false, mag: subtract(mag1: rhs.mag,
                                                            mag2: lhs.mag))
            }
        } else if lhs.signum && !rhs.signum {
            rhs.negate()
            return lhs + rhs
        } else if !lhs.signum && rhs.signum {
            rhs.negate()
            return lhs + rhs
        } else {
            if BigInteger.compareMag(mag1: rhs.mag, mag2: lhs.mag) { //gets b-a
                c = BigInteger(signum: true, mag: subtract(mag1: rhs.mag,
                                                           mag2: lhs.mag))
            } else { //gets -(a - b)
                c = BigInteger(signum: false, mag: subtract(mag1: lhs.mag,
                                                            mag2: rhs.mag))
            }
        }
        return c
    }
}

//Operator wrappers -
extension BigInteger {
    public static func - (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return subtract(lhs: lhs, rhs: rhs)
    }
}