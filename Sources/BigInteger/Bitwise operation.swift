//
//  Bitwise operation.swift
//  
//
//  Created by Louis Shen on 2022/2/2.
//

extension BigInteger {
    /*
     * Returns the number of bits in the minimal two's-complement
     * representation of this BigInteger, excluding a sign bit.
     * For positive BigIntegers, this is equivalent to the number of bits in
     * the ordinary binary representation.  For zero this method returns 0.
     * (Computes (ceil(log2(this < 0 ? -this : this+1))).)
     * For negative BigIntegers, when the mag.last is power of 2, the highest
     * binary bit of mag.last is also the sign bit, so the length needs to be
     * reduced by one after removing the sign bit.
     */
    
    public func bitLength() -> Int {
        //remove leading zeros first
        let mag = BigInteger.removeLeadingZeros(mag: mag)
        var res = 0
        if mag.count == 1 && mag[0] == 0 {
            res = 1
        } else {
            //Calculate the bit length of the magnitude
            res = ((mag.count - 1) << 5) + 32 - mag.last!.leadingZeroBitCount
            if !signum {
                // Check if magnitude is a power of two (only single one)
                var isPow2 = mag.last!.nonzeroBitCount == 1
                for i in 0 ..< mag.count - 1 {
                    isPow2 = mag[i] == 0
                }
                res = isPow2 ? res - 1 : res
            }
        }
        return res
    }
}
