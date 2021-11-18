/*
 * Return the String representation of this BigInteger in decimal
 */

extension BigInteger {
    func toString() -> String {
        var res = [String]()

        //Translate number to String, a digit group at a time
        var tmp = self
        //maybe init(val : UInt64) is better
        let uint64Radix = BigInteger(from: String(longRadix)) //10 ** 18

        while tmp.mag != [0] { //tmp != zero
            var (q, r) = divide(mag1: tmp.mag, mag2: uint64Radix.mag)
            (q, r) = (removeLeadingZeros(mag: q), removeLeadingZeros(mag: r))

            tmp.mag = q

            res.append(String(BigInteger(signum: true, mag: r).uint64Value()))
        }

        if !signum {
            res.append("-")
        }

        var result = ""
        for i in res.reversed() {
            result += i
        }
        return result
    }
}

extension String {
    public init(_ val : BigInteger) {
        self = val.toString()
    }
}

extension BigInteger : CustomStringConvertible {
    public var description : String {
        return self.toString()
    }
}