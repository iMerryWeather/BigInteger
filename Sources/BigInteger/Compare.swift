extension BigInteger {
    /*
     * (check leading zeros first)
     * 1) Longer is bigger
     * 2) if both have the same length, then compare from index 0.
     *
     * return true if mag1 ≥ mag2
     */
    static func compareMag(mag1 : [UInt32], mag2 : [UInt32]) -> Bool {
        let mag1 = removeLeadingZeros(mag: mag1)
        let mag2 = removeLeadingZeros(mag: mag2)

        //Longer is bigger
        if mag1.count != mag2.count {
            return mag1.count > mag2.count
        }

        //compare from high to low
        for i in (0 ..< mag1.count).reversed() {
            if mag1[i] != mag2[i] {
                return !(mag1[i] < mag2[i]) //#!#
            }
        }
        return true
    }
}

//Operator wrappers >, >=, <, <=, !=
extension BigInteger {
    public static func > (lhs : BigInteger, rhs : BigInteger) -> Bool {
        if lhs.signum == rhs.signum {
            if lhs.mag == rhs.mag {
                return false
            }
            if lhs.signum { // both positive
                return compareMag(mag1: lhs.mag, mag2: rhs.mag)
            } else {
                return compareMag(mag1: rhs.mag, mag2: lhs.mag)
            }
        } else {
            return lhs.signum
        }
    }
    
    /*
     * Return true if lhs != rhs
     */
    public static func != (lhs : BigInteger, rhs : BigInteger) -> Bool {
        return !(lhs == rhs)
    }
}
