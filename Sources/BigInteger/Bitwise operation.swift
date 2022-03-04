//
//  Bitwise operation.swift
//  
//
//  Created by Louis Shen on 2022/2/2.
//

extension BigInteger {
    /*
     * Returns a BigInteger whose value is lhs & rhs.  (This function returns
     * a negative BigInteger if and only if this and val are both negative.)
     */
    private static func and(lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        var lhs = lhs
        var rhs = rhs
        var res = [UInt32]()
        //let count = max(lhs.mag.count, rhs.mag.count)
        //Add zeros if two mags don't have same length
        if lhs.mag.count < rhs.mag.count {
            for _ in lhs.mag.count ..< rhs.mag.count {
                lhs.mag.append(0)
            }
        } else {
            for _ in rhs.mag.count ..< lhs.mag.count {
                rhs.mag.append(0)
            }
        }
        if !lhs.signum {
            lhs.mag.twosComplement()
        }
        if !rhs.signum {
            rhs.mag.twosComplement()
        }
        for i in 0 ..< lhs.mag.count {
            res.append(lhs.mag[i] & rhs.mag[i])
        }
        //both negative, which means `res` is negative
        if !lhs.signum && !rhs.signum {
            res.twosComplement()
            return BigInteger(signum: false, mag: res)
        }
        return BigInteger(signum: true, mag: res)
    }
}

//Operator wrappers &, &=
extension BigInteger {
    public static func & (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return and(lhs: lhs, rhs: rhs)
    }
    
    public static func &= (lhs : inout BigInteger, rhs : BigInteger) {
        lhs = lhs & rhs
    }
}

extension BigInteger {
    /*
     * Returns a BigInteger whose value is lhs | rhs.  (This function returns
     * a negative BigInteger if and only if either this or val is negative.)
     */
    private static func or(lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        var lhs = lhs
        var rhs = rhs
        var res = [UInt32]()
        //let count = max(lhs.mag.count, rhs.mag.count)
        //Add zeros if two mags don't have same length
        if lhs.mag.count < rhs.mag.count {
            for _ in lhs.mag.count ..< rhs.mag.count {
                lhs.mag.append(0)
            }
        } else {
            for _ in rhs.mag.count ..< lhs.mag.count {
                rhs.mag.append(0)
            }
        }
        if !lhs.signum {
            lhs.mag.twosComplement()
        }
        if !rhs.signum {
            rhs.mag.twosComplement()
        }
        for i in 0 ..< lhs.mag.count {
            res.append(lhs.mag[i] | rhs.mag[i])
        }
        if !lhs.signum || !rhs.signum {
            res.twosComplement()
            return BigInteger(signum: false, mag: res)
        }
        return BigInteger(signum: true, mag: res)
    }
}

//Operator wrappers |, |=
extension BigInteger {
    public static func | (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return or(lhs: lhs, rhs: rhs)
    }
    
    public static func |= (lhs : inout BigInteger, rhs : BigInteger) {
        lhs = lhs | rhs
    }
}

extension BigInteger {
    /*
     * Returns a BigInteger whose value is ~this.  (This function returns a
     * negative value if and only if this BigInteger is non-negative.)
     */
    private static func not(this : BigInteger) -> BigInteger {
        var this = this
        var res = [UInt32]()
        if !this.signum {
            this.mag.twosComplement()
        }
        for i in 0 ..< this.mag.count {
            res.append(~this.mag[i])
        }
        if this.signum {
            res.twosComplement()
            return BigInteger(signum: false, mag: res)
        }
        return BigInteger(signum: true, mag: res)
    }
}

//Operator wrappers ~
extension BigInteger {
    public static prefix func ~ (this : BigInteger) -> BigInteger {
        return not(this: this)
    }
}

extension BigInteger {
    /*
     * Returns a BigInteger whose value is ~this.  (This function returns a
     * negative BigInteger if and only if exactly one of this and val are
     * negative.)
     */
    private static func xor(lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        var lhs = lhs
        var rhs = rhs
        var res = [UInt32]()
        //let count = max(lhs.mag.count, rhs.mag.count)
        //Add zeros if two mags don't have same length
        if lhs.mag.count < rhs.mag.count {
            for _ in lhs.mag.count ..< rhs.mag.count {
                lhs.mag.append(0)
            }
        } else {
            for _ in rhs.mag.count ..< lhs.mag.count {
                rhs.mag.append(0)
            }
        }
        if !lhs.signum {
            lhs.mag.twosComplement()
        }
        if !rhs.signum {
            rhs.mag.twosComplement()
        }
        for i in 0 ..< lhs.mag.count {
            res.append(lhs.mag[i] ^ rhs.mag[i])
        }
        // `^` and `!=` are logically equivalent, they have the same
        // truth table
        if lhs.signum != rhs.signum {
            res.twosComplement()
            return BigInteger(signum: false, mag: res)
        }
        return BigInteger(signum: true, mag: res)
    }
}

//Operator wrappers ^, ^=
extension BigInteger {
    public static func ^ (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return xor(lhs: lhs, rhs: rhs)
    }
    
    public static func ^= (lhs : inout BigInteger, rhs : BigInteger) {
        lhs = lhs ^ rhs
    }
}


extension BigInteger {
    /*
     * Return a Int whose value is the number of bits equal to 1 in this
     * value's binary representation. Notice that negative big integer has
     * infinity numbers of 1s. Absolute value result will be returned.
     *
     * Complexity: O(mag.count)
     */
    public func nonzeroBitCount() -> Int {
        var res = 0
        for i in mag {
            res += i.nonzeroBitCount
        }
        return res
    }
    
    /*
     * Return a Int whose value is the number of trailing zeros in this
     * value's binary representation.
     *
     * Complexity: O(1)
     */
    public func trailingZeroBitCount() -> Int {
        return mag[0].trailingZeroBitCount
    }
}

/*
 * Return two's-complement representation of this array, do not use on sigum is
 * TRUE
 */
extension Array where Element == UInt32 {
    mutating func twosComplement() {
        var isOverflow = true
        for i in 0 ..< self.count {
            if isOverflow {
                (self[i], isOverflow) = (~self[i]).addingReportingOverflow(1)
            } else {
                self[i] = ~self[i]
            }
        }
    }
}
