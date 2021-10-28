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
        //Process digit group
        /*
         * cursor represent start index of each digit group,
         * ∂ represent end index of each digit group ("past the end position").
         * c                ∂
         * |                |
         * 0                f 16                 etc.           count
         * 000000000000000000  00000000000000000    000000000000
         * ∂ maybe large than str count
         * check it first
         */
        var cursor = 0
        while cursor < str.count {
            var delta = cursor + DIGITS_PER_INT
            //check whether delta is greater or equal to count
            delta = min(delta, str.count)
            //just for avoiding 3rd line being too long
            let cursorIndex = str.index(str.startIndex, offsetBy: cursor)
            let deltaIndex = str.index(str.startIndex, offsetBy: delta)
            mag.append(UInt64(str[cursorIndex ..< deltaIndex])!)
            
            cursor = delta
        }
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
}
