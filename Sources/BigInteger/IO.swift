/*
 * Return the String representation of this BigInteger in decimal
 */

extension BigInteger {
    func toString() -> String {
        var res = [String]()

        //Special zero case
        if self.mag == [0] {
            return "0"
        }

        //Translate number to String, a digit group at a time
        var tmp = self
        //maybe init(val : UInt64) is better
        let uint64Radix = BigInteger(from: String(longRadix)) //10 ** 18

        while tmp.mag != [0] { //tmp != zero
            var (q, r) = BigInteger.divide(mag1: tmp.mag, mag2: uint64Radix.mag)
            (q, r) = (BigInteger.removeLeadingZeros(mag: q),
                      BigInteger.removeLeadingZeros(mag: r))
//            let q = BigInteger.divide(mag1: tmp.mag, mag2: uint64Radix.mag)
//            let r = BigInteger.subtract(mag1: tmp.mag,
//                            mag2: BigInteger.multiply(mag1: q,
//                                                      mag2: uint64Radix.mag))

            tmp.mag = q

            res.append(String(BigInteger(signum: true, mag: r).uint64Value()))
        }

        var result = ""
        for i in res.reversed() {
            var i = i
            //Pad with internal zeros if necessary.
            if i.count < 18 {
                for _ in i.count ..< 18 {
                    i = "0" + i //A fast way may needed here.
                }
            }
            result += i
        }
        
        return BigInteger.removeLeadingZeros(!signum ? "-" + result : result)
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
