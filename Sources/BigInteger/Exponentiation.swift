//
//  Exponentiation.swift
//  
//
//  Created by Louis Shen on 2022/3/2.
//

extension BigInteger {
    /*
     * Returns a BigInteger whose value is a ** b.
     */
    public static func pow(_ a : BigInteger, _ b : BigInteger) -> BigInteger {
        var a = a
        var b = b
        var res = BigInteger.ONE
        while b > BigInteger.ZERO {
            if (b & BigInteger.ONE) == BigInteger.ONE {
                res *= a
            }
            a *= a
            b >>= 1
        }
        
        return res
    }
    
    /*
     * Returns a BigInteger whose value is a ** b. (where b is Int)
     */
    public static func pow(_ a : BigInteger, _ b : Int) -> BigInteger {
        var a = a
        var b = b
        var res = BigInteger.ONE
        while b > 0 {
            if (b & 1) == 1 {
                res *= a
            }
            a *= a
            b >>= 1
        }
        
        return res
    }
}
