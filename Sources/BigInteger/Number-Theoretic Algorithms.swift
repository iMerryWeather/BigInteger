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
        print("(\(a),\(b))")
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
            randomBigInteger(withMaximumWidth width : Int,
                    _ RNG : inout SystemRandomNumberGenerator) -> BigInteger {
        if width <= 32 {
            return BigInteger(signum: true,
                              mag: [RNG.next(upperBound: UInt32.max)])
        }
        let count = width / 32
        let rem = width % 32
        var mag = [UInt32]()
        mag.reserveCapacity(count + (rem == 0 ? 0 : 1))
        for _ in 0 ..< count {
            mag.append(RNG.next(upperBound: UInt32.max))
        }
        for _ in count ..< mag.count {
            mag.append(RNG.next(upperBound: UInt32.max) & ((1 << (32-rem)) - 1))
        }
        return BigInteger(signum: true, mag: mag)
    }
    
    private static func witness(_ a : BigInteger, _ n : BigInteger) -> Bool {
        let nMinusOne = n - BigInteger.ONE
        //print("n - 1 = \(nMinusOne)")
        //if nMinusOne.mag[0] & 1 == 1 {
            //return true
        //}
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
    public func primeToCertainty(_ rounds : Int,
                            _ RNG : inout SystemRandomNumberGenerator) -> Bool {
        for _ in 1 ... rounds {
            let length = RNG.next(upperBound: UInt(bitLength()))
            let a = BigInteger.randomBigInteger(withMaximumWidth: Int(length),
                                                &RNG)
            if BigInteger.witness(a, self) {
                return false
            }
        }
        return true
    }
    
    /*
     * Returns a BigInteger who is probably prime,
     */
    public static func
        nextProbablePrime(withMaximumWidth width : Int,
                    _ RNG : inout SystemRandomNumberGenerator) -> BigInteger {
        while true {
            var a = BigInteger.randomBigInteger(withMaximumWidth: width, &RNG)
            //a |= BigInteger.ONE
            a.mag[0] |= 1
            if a.primeToCertainty(4, &RNG) {
                return a
            }
        }
    }
    
    private static func getPrimeSearchLen(_ bitLength : Int) -> Int {
        return bitLength / 20 * 64
    }
    
    public static func largePrime(withMaximumWidth width : Int ,
                                   _ certainty : Int,
                            _ RNG : inout SystemRandomNumberGenerator) -> BigInteger {
        var p = BigInteger.randomBigInteger(withMaximumWidth: width, &RNG)
        p.mag[0] &= 0xfffffffe
        
        var searchLen = getPrimeSearchLen(width)
        var searchSieve = BitSieve(p, searchLen)
        var candidate = searchSieve.retrieve(p, 4, &RNG)

        while (candidate == nil) || (candidate!.bitLength() != width) {
            //NEED OPTM !!!
            p += BigInteger(2 * searchLen) //BigInteger(from: String(2*searchLen))
            //if p.bitLength() != width {
                //p = new BigInteger(bitLength, rnd).setBit(bitLength-1);
            //}
            p.mag[0] &= 0xfffffffe
            searchSieve = BitSieve(p, searchLen)
            candidate = searchSieve.retrieve(p, certainty, &RNG)
        }
        return candidate!;
    }
}

struct BitSieve {
    /*
     * Stores the bits in this bitSieve.
     */
    private var bits : [Int64]
    
    /*
     * Length is how many bits this sieve holds.
     */
    private var length : Int
    
    /*
     * A small sieve used to filter out multiples of small primes in a search
     * sieve.
     */
    private static var smallSieve = BitSieve()
    
    /*
     * Construct a "small sieve" with a base of 0.  This constructor is
     * used internally to generate the set of "small primes" whose multiples
     * are excluded from sieves generated by the main (package private)
     * constructor, BitSieve(BigInteger base, int searchLen).  The length
     * of the sieve generated by this constructor was chosen for performance;
     * it controls a tradeoff between how much time is spent constructing
     * other sieves, and how much time is wasted testing composite candidates
     * for primality.  The length was chosen experimentally to yield good
     * performance.
     */
    private init() {
        length = 9600//150 * 64
        bits = [Int64](repeating: 0, count: BitSieve.unitIndex(length - 1) + 1)
        
        // Mark 1 as composite
        set(0)
        var nextIndex = 1
        var nextPrime = 3
        
        repeat {
            sieveSingle(length, nextIndex + nextPrime, nextPrime)
            nextIndex = sieveSearch(length, nextIndex + 1)
            nextPrime = 2 * nextIndex + 1
        } while ((nextIndex > 0) && (nextPrime < length))
    }
    
    /*
     * Construct a bit sieve of searchLen bits used for finding prime number
     * candidates. The new sieve begins at the specified base, which must
     * be even.
     */
    init(_ base : BigInteger, _ searchLen : Int) {
        /*
         * Candidates are indicated by clear bits in the sieve. As a candidates
         * nonprimality is calculated, a bit is set in the sieve to eliminate
         * it. To reduce storage space and increase efficiency, no even numbers
         * are represented in the sieve (each bit in the sieve represents an
         * odd number).
         */
        bits = [Int64](repeating: 0, count: BitSieve.unitIndex(searchLen - 1) + 1)
        length = searchLen
        var start = 0
        
        var step = BitSieve.smallSieve.sieveSearch(BitSieve.smallSieve.length, start)
        var convertedStep = (step * 2) + 1

        // Construct the large sieve at an even offset specified by base
        //MutableBigInteger b = new MutableBigInteger(base)
        //MutableBigInteger q = new MutableBigInteger()
        var b = base
        //var q = BigInteger.ZERO
        repeat {
            // Calculate base mod convertedStep
            // NEED OPTM!!!!!
            let divisor = BigInteger(convertedStep)
            start = Int(String(b % divisor))!//b.divideOneWord(convertedStep, q)
            //q = b / divisor
            b /= divisor

            // Take each multiple of step out of sieve
            start = convertedStep - start
            if start % 2 == 0 {
                start += convertedStep
            }
            sieveSingle(searchLen, (start-1)/2, convertedStep)

            // Find next prime from small sieve
            step = BitSieve.smallSieve.sieveSearch(BitSieve.smallSieve.length, step+1)
            convertedStep = (step * 2) + 1
        } while (step > 0)
        
    }
    
    //>>>
    private static func unitIndex(_ bitIndex : Int) -> Int {
        return bitIndex >> 6
    }
    
    /*
     * This method returns the index of the first clear bit in the search
     * array that occurs at or after start. It will not search past the
     * specified limit. It returns -1 if there is no such clear bit.
     */
    private func sieveSearch(_ limit : Int, _ start : Int) -> Int {
        if start >= limit {
            return -1
        }

        var index = start
        repeat {
            if !get(index) {
                return index
            }
            index += 1
        } while (index < limit-1)
        return -1
    }
    
    /*
     * Sieve a single set of multiples out of the sieve. Begin to remove
     * multiples of the specified step starting at the specified start index,
     * up to the specified limit.
     */
    private mutating func sieveSingle(_ limit : Int, _ start : Int, _ step : Int) {
        var start = start
        while(start < limit) {
            set(start)
            start += step
        }
    }
    
    /*
     * Return a unit that masks the specified bit in its unit.
     */
    private static func bit(_ bitIndex : Int) -> Int64 {
        return 1 << (bitIndex & ((1<<6) - 1))
    }
    
    /*
     * Set the bit at the specified index.
     */
    private mutating func set(_ bitIndex : Int) {
        let unitIndex = BitSieve.unitIndex(bitIndex)
        bits[unitIndex] |= BitSieve.bit(bitIndex)
    }
    
    /*
     * Get the value of the bit at the specified index.
     */
    private func get(_ bitIndex : Int) -> Bool {
        let unitIndex = BitSieve.unitIndex(bitIndex)
        return (bits[unitIndex] & BitSieve.bit(bitIndex)) != 0
    }
    
    /*
     * Test probable primes in the sieve and return successful candidates.
     */
    func retrieve(_ initValue : BigInteger, _ certainty : Int, _ RNG : inout SystemRandomNumberGenerator) -> BigInteger? {
        // Examine the sieve one long at a time to find possible primes
        var offset = 1
        //for (int i=0 i<bits.length i++) {
        for i in 0 ..< bits.count {
            var nextLong = ~bits[i]
            //for (int j=0 j<64 j++) {
            for _ in 0 ..< 64 {
                if (nextLong & 1) == 1 {
                    let candidate = initValue + BigInteger(offset)
                    if candidate.primeToCertainty(certainty, &RNG) {
                        return candidate
                    }
                }
                nextLong >>= 1
                offset += 2
            }
        }
        return nil
    }
}
