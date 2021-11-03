import Foundation
public struct BigInteger {
    //FALSE for negative, TRUE for zero & positive
    var signum : Bool

    var mag : [UInt64]

    let BASE : UInt64 = 10000000000000000

    /*
     * This value is the number of digits of the decimal
     * radix that can fit in a UInt64 without "going negative",
     *
     * (Maybe 18 is better, for test here choose 16.)
     */
    let DIGITS_PER_INT = 16

    /*
     * Construct a BigInteger from String
     */
    public init(from str : String) {
        var str = str
        if str.first == "-" {
            signum = false
            str.removeFirst()
        } else {
            signum = true
            if str.first == "+" {
                str.removeFirst()
            }
        }

        //TO-DO
        //check if str consist of digit characters
        /*
         * if
         */
        mag = [UInt64]()

        //if digits length is one
        if str.count == 1 {
            mag.append(UInt64(str)!)
            return
        }

        //Process digit group
        /*
         * ∂ represent one smaller than the start index of each digit group,
         * cursor represent end index of each digit group.
         *                                       ∂                c.r (count - 1)
         *                                       |                |
         * Index: 0123456789abcd|efghijkl        c.r - 16          count  (number in hex)
         * num:   00000000000000|00000000000000000|0000000000000000
         * ∂ maybe smaller than zero
         * check it first
         *
         * for example:
         * Index: 01234|56789abcdefghijk
         * num:   61236|1193061935861236
         *
         * delta|cursor
         * -----|------
         *   4  |  20
         *  -1  |   4
         */
        var cursor = str.count - 1
        while cursor > 0 {
            var delta = cursor - DIGITS_PER_INT
            //check whether delta is samller than zero
            delta = max(delta, -1) //delta is the position where before the start index

            //just for avoiding the 3rd line being too long
            let deltaIndex = str.index(str.startIndex, offsetBy: delta + 1)
            let cursorIndex = str.index(str.startIndex, offsetBy: cursor)
            mag.append(UInt64(str[deltaIndex ... cursorIndex])!) //[the 3rd line]

            cursor = delta
        }
        //remove leading zeros
        mag = BigInteger.removeLeadingZeros(mag: mag)
    }

    /*
     * Construct a BigInteger by given signum & mag
     */
    private init(signum : Bool, mag : [UInt64]) {
        self.signum = signum
        self.mag = mag
    }

    /*
     * BigInteger to String
     */
    public func toString() -> String {
        var res = ""
        if !signum {
            res += "-"
        }
        for i in mag.reversed() {
            res += String(i)
        }
        return res
    }

    /*
     * Add two mag
     */
    private func add(mag : [UInt64]) -> [UInt64] {
        var mag1 = self.mag
        var mag2 = mag
        //Add zeros if two mags don't have same length
        if mag1.count < mag2.count {
            for _ in mag1.count ..< mag2.count {
                mag1.append(0)
            }
        } else {
            for _ in mag2.count ..< mag1.count {
                mag2.append(0)
            }
        }

        var res = [UInt64]()

        var carry : UInt64 = 0
        for i in 0 ..< mag1.count {
            res.append(mag1[i] + mag2[i] + carry)
            if res[i] >= BASE {
                res[i] -= BASE
                carry = 1
            } else {
                carry = 0
            }
        }
        //Last carry
        if carry == 1 {
            res.append(1)
        }
        return res
    }

    /*
     * Sub two mag
     * always big - small in abs.
     * won't check here
     *
     *   1236112361123612|19358
     * - 1935819358193582|1236
     * ------------------------
     * ==
     *   1236112361123612 + BASE|19358 - 1
     * - 1935819358193582       |1236
     * -----------------------------------
     *   9300293002930030       |18121
     */
    public func sub(mag : [UInt64]) -> [UInt64] {
        var mag1 = self.mag
        var mag2 = mag

        //Add zeros if two mags don't have same length
        if mag1.count < mag2.count {
            for _ in mag1.count ..< mag2.count {
                mag1.append(0)
            }
        } else {
            for _ in mag2.count ..< mag1.count {
                mag2.append(0)
            }
        }

        var res = [UInt64]()
        for i in 0 ..< mag1.count {
            if mag1[i] < mag2[i] { //no enough to sub, borrow
                mag1[i] += BASE
                mag1[i + 1] -= 1
            }
            res.append(mag1[i] - mag2[i])
        }

        return res
    }

    /*
     * Add two BigInteger
     *     a   |   b   |        c
     *   sign1 | sign2 |      result
     *   ------|-------|-----------------
     *     +   |   +   |     c = a + b
     *     +   |   -   |     c = a - b
     *     -   |   +   |     c = b - a
     *     -   |   -   |     c = -(a + b)
     */
    private func add(rhs : BigInteger) -> BigInteger {
        if self.signum && rhs.signum { //c = a + b
            return BigInteger(signum: true, mag: add(mag: rhs.mag))
        } else if self.signum && (!rhs.signum) { //c = a - b
            //go to sub
            return BigInteger(from: "0")
        } else if (!self.signum) && rhs.signum { // c = b - a
            //go to sub
            return BigInteger(from: "0")
        } else {
            return BigInteger(signum: false, mag: add(mag: rhs.mag))
        }
    }

    /*
     * remove all leading zeros, if mag is all zero, mag will equal [0]
     */
    private static func removeLeadingZeros(mag : [UInt64]) -> [UInt64] {
        var mag = mag
        if mag.last != nil {
            if mag.last != 0 { // the most-significant int of the magnitude
                return mag     // is zero, meaning no leading zeros.
            }
        }

        //go through the mag, remove the zero int until meet first non-zero element
        var i = mag.count - 1
        while true {
            if mag[i] == 0 {
                mag.removeLast()
                i -= 1
                if i <= 0 { // if all zero
                    mag = [0]
                    break
                }
            } else {
                break
            }
        }
        return mag
    }

    /*
     * (check leading zeros first)
     * 1) Longer is bigger
     * 2) if both have the same length, then compare from index 0.
     *
     * return true if mag1 ≥ mag2
     */
    private static func compare(mag1 : [UInt64], mag2 : [UInt64]) -> Bool {
        if mag1.count != mag2.count {
            return false
        }
        return true
    }

    /*
     * Sub two BigInteger
     * compare first
     * always big - small
     *
     *     a   |   b   |        c
     *   sign1 | sign2 |      result
     *   ------|-------|-----------------
     *     +   |   +   |     c = a + b
     *     +   |   -   |     c = a - b
     *     -   |   +   |     c = b - a
     *     -   |   -   |     c = -(a + b)
     */
    // private func sub(rhs : BigInteger) -> BigInteger {

    // }
}

// MARK: - Operators
extension BigInteger {
    /*
     * A wrapper of add
     */
    static func + (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return lhs.add(rhs: rhs)
    }

    /*
     * A wrapper of sub
     */
    // static func - (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
    //     return lhs.sub(mag:)
    // }
}
