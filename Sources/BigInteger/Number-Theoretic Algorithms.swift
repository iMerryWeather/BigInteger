//
//  Number-Theoretic Algorithms.swift
//  
//
//  Created by Louis Shen on 2022/2/28.
//

extension BigInteger {
    /*
     * Returns a BigInteger whose value is the greatest common divisor of
     * abs(lhs) and abs(rhs).  Returns 0 if lhs == 0 && rhs == 0.
     *
     * Euclid's Algorithm
     *   gcd(a, b) = gcd(b, a mod b)
     *   gcd(a, b) = gcd(|a|, |b|)
     *
     * See CLRS, _Introduction to Algorithms_, 3e, (31.8, Thm. 31.9)
     */
    public static func gcd(_ lhs: BigInteger, _ rhs: BigInteger) -> BigInteger {
        return euclid(lhs.abs(), rhs.abs())
    }
    
    private static func euclid(_ a : BigInteger,
                               _ b : BigInteger) -> BigInteger {
        if b == BigInteger.ZERO {
            return a
        } else {
            return euclid(b, a % b)
        }
    }
}
