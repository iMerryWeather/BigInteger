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
        let count = max(lhs.mag.count, rhs.mag.count)
        if !lhs.signum {
            lhs.mag.twosComplement()
        }
        if !rhs.signum {
            rhs.mag.twosComplement()
        }
        for i in 0 ..< count {
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

//Operator wrappers &
extension BigInteger {
    public static func & (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return and(lhs: lhs, rhs: rhs)
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
        let count = max(lhs.mag.count, rhs.mag.count)
        if !lhs.signum {
            lhs.mag.twosComplement()
        }
        if !rhs.signum {
            rhs.mag.twosComplement()
        }
        for i in 0 ..< count {
            res.append(lhs.mag[i] | rhs.mag[i])
        }
        if lhs.signum && rhs.signum {
            return BigInteger(signum: true, mag: res)
        }
        res.twosComplement()
        return BigInteger(signum: false, mag: res)
    }
}

//Operator wrappers &
extension BigInteger {
    public static func | (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return or(lhs: lhs, rhs: rhs)
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
