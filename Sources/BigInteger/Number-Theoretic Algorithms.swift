//
//  Number-Theoretic Algorithms.swift
//  
//
//  Created by Louis Shen on 2022/2/28.
//

import Darwin

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
    
    /*
     * Returns a BigInteger whose value consisted of `width` random bits.
     */
    public static func
            randomBigInteger(withMaximumWidth width : Int) -> BigInteger {
        var rng = SystemRandomNumberGenerator()
        if width < 32 {
            return BigInteger(signum: true, mag: [rng.next() % UInt32.max])
        }
        let count = width / 32
        let rem = width % 32
        var mag = [UInt32]()
        mag.reserveCapacity(count + (rem == 0 ? 0 : 1))
        for _ in 0 ..< count {
            mag.append(rng.next() % UInt32.max)
        }
        for _ in count ..< mag.count {
            mag.append((rng.next() % UInt32.max) & ((1 << (32 - rem)) - 1))
        }
        return BigInteger(signum: true, mag: mag)
    }
    
    private static func witness(_ a : BigInteger, _ n : BigInteger) -> Bool {
        let nMinusOne = n - BigInteger.ONE
        let t = nMinusOne.trailingZeroBitCount()
        let u = nMinusOne >> UInt(t)
        var x = [BigInteger]()
        
        x.append(BigInteger.pow(a, u, n))
        for i in 1 ... t {
            x.append(x[i - 1] * x[i - 1] % n)
            if x[i] == BigInteger.ONE &&
               x[i - 1] != BigInteger.ONE &&
               x[i - 1] != nMinusOne {
                return true
            }
        }
        if x[t] != BigInteger.ONE {
            return true
        }
        return false
    }
    
    /*
     * Returns true if this BigInteger is probably prime,
     * false if it's definitely composite.
     *
     * Error rate: 4 ** (-rounds)
     *
     * See CLRS, _Introduction to Algorithms_, 3e, Chapter 31.
     */
    public func primeToCertainty(_ rounds : Int) -> Bool {
        for _ in 1 ... rounds {
            let length = arc4random() % UInt32(bitLength())
            let a = BigInteger.randomBigInteger(withMaximumWidth: Int(length))
            if BigInteger.witness(a, self) {
                return false
            }
        }
        return true
    }
}
