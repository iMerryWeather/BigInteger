import Foundation

public struct BigInteger : Equatable {
    //FALSE for negative, TRUE for zero & positive
    var signum : Bool

    var mag : [UInt32]

    /*
     *
     */
    static let BASE : UInt64 = 4294967296 // 1 << 32

    /*
     * The following two values are used for fast String conversions.
     * intRadix = 10 ** DIGITS_PER_INT = 10 ** 9
     */
    let intRadix : UInt32 = 0x3b9aca00 //1000000000
    /*
     * This value is the number of digits of the decimal radix that can fit in
     * a UInt32 without overflowing.
     */
    let DIGITS_PER_INT = 9
    let longRadix : UInt64 = 0xde0b6b3a7640000 // 10 ** 18

    /*
     * bitsPerDigit in the decimal times 1024. (1 << 10)
     * Rounded up to avoid under-allocation.
     *
     * Suppose we have a m digits decimal number, bitsPerDigit is how many bits
     * needed by converting it to binary. (Assume x bits.)
     * We have 10 ** m - 1 = 2 ** x - 1, then x = m * log2(10).
     *
     * bitsPerDigit = log2(10) * 1024 ≈ 3401.654369164659
     * When we use it, remember to divide 1024 (>> 10)
     */
    private let bitsPerDigit : UInt64 = 3402

    /*
     * The BigInteger constant ZERO
     */
    public static let ZERO = BigInteger(signum: true, mag: [0])
    
    /*
     * The BigInteger constant ONE
     */
    public static let ONE = BigInteger(signum: true, mag: [1])
    
    /*
     * The BigInteger constant TWO
     */
    public static let TWO = BigInteger(signum: true, mag: [2])
    
    /*
     * The BigInteger constant product of 256 primes in [3, 1621].
     */
    public static let PRODUCT_OF_PRIMES =
        BigInteger(signum: true,
                   mag: [1180380767, 2049642305, 4256528931, 2494506831,
                         3767536489, 2987356538, 3419236816, 415997047 ,
                         647784465 , 2065212227, 3411486685, 4033609938,
                         735865894 , 997923493 , 1632766510, 3723949609,
                         4178825839, 492540082 , 282070566 , 2433112483,
                         1798672574, 2640288240, 923789122 , 2224341713,
                         3090845571, 3596717470, 1258945425, 1479568952,
                         672622793 , 1821856559, 3068649185, 2424608606,
                         2259581805, 3863104578, 1469203687, 2422066404,
                         3843473144, 684933527 , 1732234523, 2405148923,
                         612181479 , 2243658181, 3239173220, 983150911 ,
                         4181791623, 1547700944, 275181481 , 3169613336,
                         2932821511, 1485381611, 2518857041, 253419701 ,
                         3989251425, 1001195206, 1885571329, 898881731 ,
                         678399785 , 1661917169, 1594613432, 2280192063,
                         1078437598, 1346185943, 782963204 , 2346478088,
                         4058592480, 3176343827, 2556541843, 945821243 ,
                         3539131724, 3551308796, 2910215076, 201505123])
    
//Constructors (and its helper funcs)
//===----------------------------------------------------------------------===//
    /*
     * Returns a BigInteger whose value is equal to that of the specified UInt32
     */
    public init(_ val : UInt32) {
        mag = [UInt32]()
        mag.append(val)
        signum = true
    }
    
    /*
     * Returns a BigInteger whose value is equal to that of the specified UInt
     * (64-bit)
     */
    public init(_ val : UInt) {
        mag = [UInt32]()
        mag.append(UInt32(truncatingIfNeeded: val))
        mag.append(UInt32(val >> 32))
        signum = true
    }
    
    /*
     * Returns a BigInteger whose value is equal to that of the specified UInt64
     */
    public init(_ val : UInt64) {
        self.init(UInt(val))
    }
    
    /*
     * Returns a BigInteger whose value is equal to that of the specified Int32
     */
    public init(_ val : Int32) {
        mag = [UInt32]()
        if val < 0 {
            signum = false
            mag.append(UInt32(-val))
        } else {
            mag.append(UInt32(val))
            signum = true
        }
    }
    
    /*
     * Returns a BigInteger whose value is equal to that of the specified Int
     * (64-bit)
     */
    public init(_ val : Int) {
        mag = [UInt32]()
        var val = val
        if val < 0 {
            val = -val
            signum = false
        } else {
            signum = true
        }
        mag.append(UInt32(truncatingIfNeeded: val))
        mag.append(UInt32(val >> 32))
    }
    
    /*
     * Returns a BigInteger whose value is equal to that of the specified Int64
     */
    public init(_ val : Int64) {
        self.init(Int(val))
    }
    
    /*
     * Translates the decimal String representation of a BigInteger into a
     * BigInteger. The String representation consists of an optional minus or
     * plus sign followed by a sequence of one or more decimal digits.
     *
     * After checking the sign of the number, we split it up into 9-digits
     * group, then convert these groups into base = 2**32.
     */
    public init(from str : String) {
        var cursor = 0
        if str.first == "-" {
            signum = false
            cursor += 1
        } else {
            signum = true
            if str.first == "+" {
                cursor += 1
            }
        }

        //TO-DO
        //check if str consist of digit characters
        /*
         * if
         */

        //Skip leading zeros
        while cursor < str.count &&
              str[str.index(str.startIndex, offsetBy: cursor)] == "0" {
            cursor += 1
        }

        //if all zero
        if cursor == str.count {
            mag = [0]
            signum = true
            return
        }
        let numDigits = str.count - cursor

        //Pre-allocate array of expected size. May be too large but can never be
        //too small. Typically exact.
        let numBits = ((UInt64(numDigits) * bitsPerDigit) >> 10) + 1
        let numWords = UInt32(truncatingIfNeeded: (numBits + 31) >> 5)
        mag = [UInt32](repeating: 0, count: Int(numWords))

        //if digits length is one
        if str.count == 1 {
            mag[0] = (UInt32(str)!)
            return
        }

        //Process first digit group
        var firstGroupCount = numDigits % DIGITS_PER_INT

        if firstGroupCount == 0 {
            firstGroupCount = DIGITS_PER_INT
        }
        let group = str[str.index(str.startIndex, offsetBy: cursor) ..<
                str.index(str.startIndex, offsetBy: cursor + firstGroupCount)]
        mag[0] = UInt32(group)!
        cursor += firstGroupCount

        //Process remaining digit group
        while cursor < str.count {
            var delta = cursor + DIGITS_PER_INT
            delta = min(delta, str.count) //avoid exceeding the range of str
            let deltaIndex = str.index(str.startIndex, offsetBy: delta)
            let cursorIndex = str.index(str.startIndex, offsetBy: cursor)
            let groupVal = UInt32(str[cursorIndex ..< deltaIndex])!

            BigInteger.destructiveMulAdd(&mag, intRadix, groupVal)

            cursor = delta
        }

        //remove leading zeros
        //caused by over-allocate, we do it unconditionally.
        mag = BigInteger.removeLeadingZeros(mag: mag)
    }

    // Multiply x array times word y in place, and add word z
    // Used by init(from:_ str) for radix conversion
    public static func
        destructiveMulAdd(_ x : inout [UInt32], _ y : UInt32, _ z : UInt32) {
        //Perform the multiplication word by word
        var product : UInt64 = 0
        var carry : UInt64 = 0
        for i in 0 ..< x.count {
            product = UInt64(x[i]) * UInt64(y) + carry
            x[i] = UInt32(truncatingIfNeeded: product) // x[i] = product%(1<<32)
            carry = product >> 32              // carry = product / (1 << 32)
        }

        //Perform the addition
        //do x[0] + z first, check wether it has a carry
        carry = UInt64(z)
        var sum : UInt64 = 0
        for i in 0 ..< x.count {
            sum = UInt64(x[i]) + carry
            x[i] = UInt32(truncatingIfNeeded: sum)
            carry = sum >> 32
        }
    }

    /*
     * Construct a BigInteger by given signum & mag
     */
    init(signum : Bool, mag : [UInt32]) {
        self.signum = signum
        self.mag = BigInteger.removeLeadingZeros(mag: mag)
    }

    /*
     * Returns the specified uint64 value.
     * We assume the self mag only have 2 elements.
     * mag|                0               |               1                |
     * bit|################################|################################|
     *
     * result = (mag[1] << 32) + mag[0]
     */
    public func uint64Value() -> UInt64 {
        if mag.count == 0 {
            return 0
        } else if mag.count == 1 {
            return UInt64(mag[0])
        }
        return (UInt64(mag[1]) << 32) + UInt64(mag[0])
    }

    /*
     * remove all leading zeros, if mag is all zero, mag will be equal to [0]
     */
    static func removeLeadingZeros(mag : [UInt32]) -> [UInt32] {
        var mag = mag
        if mag.last != nil {
            if mag.last != 0 { // the most-significant int of the magnitude
                return mag     // is zero, meaning no leading zeros.
            }
        }

        //go through the mag, remove the zero int until meet first non-zero
        //element
        var i = mag.count - 1
        while true {
            if mag[i] == 0 {
                mag.removeLast()
                i -= 1
                if i < 0 { // if all zero
                    mag = [0]
                    break
                }
            } else {
                break
            }
        }
        return mag
    }
//===----------------------------------------------------------------------===//
    
    /*
     * Remove all leading zeros for a string representation of BigInteger. And
     * in current version we are not going to check wheather the input is legel
     * or not.
     */
    static func removeLeadingZeros(_ n : String) -> String {
        //the input should be like: 0000012321312313121323...
        var n = n
        let isNegative = n.first! == "-" ? true : false
        
        // if is negative we skip the minus sign
        if isNegative {
            n.removeFirst()
        }
        
        var beforeFirstNonZero = n.startIndex
        for i in n {
            beforeFirstNonZero = n.index(after: beforeFirstNonZero)
            if i != "0" {
                beforeFirstNonZero = n.index(before: beforeFirstNonZero)
                break
            }
        }
        let ans = String(n[beforeFirstNonZero ..< n.endIndex])
        return isNegative ? "-" + ans : ans
    }

    /*
     * if a is a BigInteger, then a.negate() will get value = -a
     */
    public func negate() -> BigInteger {
        return BigInteger(signum: !self.signum, mag: self.mag)
    }
    
    /*
     * Returns a BigInteger whose value is the absolute value of this
     * BigInteger.
     */
    public func abs() -> BigInteger {
        return signum ? self : self.negate()
    }
}
