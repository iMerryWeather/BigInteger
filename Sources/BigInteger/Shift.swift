//
//  Shift.swift
//  
//
//  Created by Louis Shen on 2022/2/12.
//

extension BigInteger {
    /*
     * Returns a BigInteger whose value is this << n.
     */
    /*
     * shift 32-bits per step (simply add a zero mag-term in mag[])
     */
    private static func leftShift(this : BigInteger, n : UInt) -> BigInteger {
        var this = this
        let bitGroupCount = n / 32
        let rem = n % 32 //remainder
        
        //may get a performance improvement. ( O(mag.count) )
        //shift 32 * bitGroupCount bits, with rem bits not shifted
        for _ in 0 ..< bitGroupCount {
            this.mag.insert(0, at: 0)
        }
        if rem == 0 {
            return this
        }
        //perform rem-bits shift, from high to low. (0 < rem < 32)
        //perform first bits group
        var delta : UInt64 = UInt64(this.mag[this.mag.count - 1]) << rem
        this.mag.append(UInt32(delta >> 32)) // append overflow
        this.mag[this.mag.count - 2] = UInt32(truncatingIfNeeded: delta)
        
        //process remaining bits group
        for i in (0 ..< this.mag.count - 2).reversed() {
            delta = UInt64(this.mag[i]) << rem
            this.mag[i + 1] += UInt32(delta >> 32) //add overflow
            this.mag[i] = UInt32(truncatingIfNeeded: delta)
        }
        
        this.mag = BigInteger.removeLeadingZeros(mag: this.mag)
        
        return this
    }
}

//Operator wrappers <<
extension BigInteger {
    public static func << (this : BigInteger, n : UInt) -> BigInteger {
        return leftShift(this: this, n: n)
    }
}

