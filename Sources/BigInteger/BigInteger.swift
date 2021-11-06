import Foundation
public struct BigInteger {
    //FALSE for negative, TRUE for zero & positive
    var signum : Bool

    var mag : [UInt32]

    /*
     *
     */
    let BASE : UInt32 = 1000000000

    /*
     * This value is the number of digits of the decimal
     * radix that can fit in a UInt32 without overflowing,
     */
    let DIGITS_PER_INT = 9

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
        mag = [UInt32]()

        //if digits length is one
        if str.count == 1 {
            mag.append(UInt32(str)!)
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
            mag.append(UInt32(str[deltaIndex ... cursorIndex])!) //[the 3rd line]

            cursor = delta
        }
        //remove leading zeros
        mag = removeLeadingZeros(mag: mag)
    }

    /*
     * Construct a BigInteger by given signum & mag
     */
    private init(signum : Bool, mag : [UInt32]) {
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
     * Add two BigInteger
     *     a   |   b   |        c
     *   sign1 | sign2 |      result
     *   ------|-------|-----------------
     *     +   |   +   |     c = a + b
     *     +   |   -   |     c = a - b
     *     -   |   +   |     c = b - a
     *     -   |   -   |     c = -(a + b)
     */
    /*private func add(rhs : BigInteger) -> BigInteger {
        if self.signum && rhs.signum { //c = a + b
            return BigInteger(signum: true, mag: add(mag1: self.mag, mag2: rhs.mag))
        } else if self.signum && (!rhs.signum) { //c = a - b
            return self.sub(rhs: rhs)
        } else if (!self.signum) && rhs.signum { // c = b - a
            return rhs.sub(rhs: self)
        } else {
            return BigInteger(signum: false, mag: add(mag1: self.mag, mag2: rhs.mag))
        }
    }*/

    /*
     * remove all leading zeros, if mag is all zero, mag will equal [0]
     */
    private func removeLeadingZeros(mag : [UInt32]) -> [UInt32] {
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
    /*private static func compareAbs(mag1 : [UInt64], mag2 : [UInt64]) -> Bool {
        let mag1 = BigInteger.removeLeadingZeros(mag: mag1)
        let mag2 = BigInteger.removeLeadingZeros(mag: mag2)

        //Longer is bigger
        if mag1.count != mag2.count {
            return mag1.count > mag2.count
        }

        //compare from 0 to count
        for i in 0 ..< mag1.count {
            if mag1[i] < mag2[i] {
                return false
            }
        }
        return true
    }*/

    /*
     * if a is a BigInteger, then a.negate() will gets
     *  value = -a
     */
    /*private mutating func negate() {
        self.signum = !self.signum
    }*/

    /*
     * Sub two BigInteger
     * compare first
     * always big - small
     *
     *     a   |   b   |        c
     *   sign1 | sign2 |      result
     *   ------|-------|-----------------
     *     +   |   +   |     c = |a| - |b|
     *     +   |   -   |     c = |a| + |b|
     *     -   |   +   |     c = (-|a|) - (+|b|) = -(|a| + |b|)
     *     -   |   -   |     c = -(|a| + |b|)
     */
    /*private func sub(rhs : BigInteger) -> BigInteger {
        var c : BigInteger
        if self.signum && rhs.signum {
            if BigInteger.compareAbs(mag1: self.mag, mag2: rhs.mag) { // a >= b
                c = BigInteger(signum: true, mag: sub(mag1: self.mag, mag2: rhs.mag))
            } else {
                c = BigInteger(signum: false, mag: sub(mag1: rhs.mag, mag2: self.mag))
            }
        } else if self.signum && !rhs.signum {
            c = BigInteger(signum: true, mag: add(mag1: self.mag, mag2: rhs.mag))
        } else if !self.signum && rhs.signum {
            c = BigInteger(from: "0")
        } else {
            c = BigInteger(from: "0")
        }
        return c
    }*/
}

// MARK: - Addition & Subtraction
extension BigInteger {
    /*
     * Adds the contents of the uint32 arrays x and y. This method allocates
     * a new int array to hold the answer and returns a reference to that
     * array.
     *
     * Knuth's Algorithm A
     * See Knuth, Donald,  _The Art of Computer Programming_, Vol. 2, (4.3)
     */
    public func add(mag1 : [UInt32], mag2 : [UInt32]) -> [UInt32] {
        var mag1 = mag1
        var mag2 = mag2
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
        let n = mag1.count
        var res = [UInt32]()

        //variable carry will keep track of carries at each step
        var carry : UInt32 = 0
        for j in 0 ..< n {
            res.append((mag1[j] + mag2[j] + carry) % BASE)
            carry = (mag1[j] + mag2[j] + carry) / BASE
        }

        //means mag1[n] + mag2[n] > BASE, extra space needed
        if carry != 0 {
            res.append(carry)
        }

        return res
    }

    /*
     * Subtracts the contents of the second uint32 arrays (little) from the
     * first (big).  The first int array (big) must represent a larger number
     * than the second.  This method allocates the space necessary to hold the
     * answer.
     *
     * Knuth's Algorithm S
     * See Knuth, Donald,  _The Art of Computer Programming_, Vol. 2, (4.3)
     */

    public func subtract(mag1 : [UInt32], mag2 : [UInt32]) -> [UInt32] {
        var mag2 = mag2
        //Add zeros if two mags don't have same length
        if mag1.count > mag2.count {
            for _ in mag2.count ..< mag1.count {
                mag2.append(0)
            }
        }

        let n = mag1.count
        var res = [UInt32]()

        var borrow : UInt32 = 0
        for j in 0 ..< n {
            res.append((mag1[j] - mag2[j] + borrow) % BASE)
            borrow = (mag1[j] - mag2[j] + borrow) / BASE
        }

        res = removeLeadingZeros(mag: res) // when a - a = 0, shrink mag to [0]
        return res
    }
}

// MARK: - Operators
extension BigInteger {
    /*
     * A wrapper of add
     */
    /*static func + (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return lhs.add(rhs: rhs)
    }*/

    /*
     * A wrapper of sub
     */
    // static func - (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
    //     return lhs.sub(mag:)
    // }
}
