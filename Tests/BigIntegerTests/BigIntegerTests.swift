import XCTest
@testable import BigInteger
import PythonKit

final class BigIntegerTests: XCTestCase {
    let numA2048 = getRandomNum(withCount: 2048)
    let numB2048 = getRandomNum(withCount: 2048)
    let numA256 = getRandomNum(withCount: 256)
    let numA20480 = getRandomNum(withCount: 20480)
    
    func testPublicInitFromStr() {
        let a = BigInteger(from:
                "0000000000000000000000000000000000000612361193061935861237")
        XCTAssertEqual(a.mag, [1125502453, 842529961, 33])
        XCTAssertEqual(a.signum, true)

        let b = BigInteger(from: "-0006123611930619358612362")
        XCTAssertEqual(b.mag, [2665089930, 4130332316, 331])
        XCTAssertEqual(b.signum, false)

        let c = BigInteger(from: "0")
        XCTAssertEqual(c.mag, [0])
        XCTAssertEqual(c.signum, true)
    }

    func testAddMagT1() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        //c_mag = [3138768373, 3505532565, 28376639]
        let c = BigInteger(from: "523456612361193061935861237")
        //d_mag = [1946157056, 1340620830, 27105054]
        let d = BigInteger(from: "500000000000000000000000000")
        XCTAssertEqual(BigInteger.add(mag1: a.mag, mag2: b.mag),
                       [2931821546, 842529975, 33])
        XCTAssertEqual(BigInteger.add(mag1: c.mag, mag2: c.mag),
                       [1982569450, 2716097835, 56753279])
        XCTAssertEqual(BigInteger.add(mag1: d.mag, mag2: d.mag),
                       [3892314112, 2681241660, 54210108])

    }

    func testSubtractMagT1() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        let c = BigInteger(from: "523456612361193061935861237")
        let d = BigInteger(from: "500000000000000000000000000")
        XCTAssertEqual(BigInteger.subtract(mag1: a.mag, mag2: b.mag),
                       [3614150656, 842529946, 33])
        XCTAssertEqual(BigInteger.subtract(mag1: c.mag, mag2: d.mag),
                       [1192611317, 2164911735, 1271585])
        XCTAssertEqual(BigInteger.subtract(mag1: d.mag, mag2: d.mag), [0])

    }

    func testMulMagT1() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        let c = BigInteger(from: "523456612361193061935861237")
        let d = BigInteger(from: "500000000000000000000000000")

        XCTAssertEqual(BigInteger.multiply(mag1: a.mag, mag2: b.mag),
                       [2443410553, 2573930479, 3038812614, 478])
        XCTAssertEqual(BigInteger.multiply(mag1: c.mag, mag2: d.mag),
            [67108864, 2044281865, 1819053428, 197960665, 3325078967, 179081])
        XCTAssertEqual(BigInteger.multiply(mag1: c.mag, mag2: [0]), [0])
    }

    func testDivMagT1() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        let c = BigInteger(from: "523456612361193061935861237")
        let d = BigInteger(from: "500000000000000000000000000")

        //hack, should be fixed in division(mag1:_, mag2:_) v1.1b1
        let e = BigInteger(from: "612361193061935861237324234354353452352542352435435252435453")
        let f = BigInteger(from: "1000000000000000000")

        XCTAssertEqual(BigInteger.divide(mag1: e.mag, mag2: f.mag).0, [4274521118, 267499566, 3951190577, 2438715792, 1799, 0])
        XCTAssertEqual(BigInteger.divide(mag1: a.mag, mag2: b.mag).0, [1297086930, 2])
        XCTAssertEqual(BigInteger.divide(mag1: a.mag, mag2: b.mag).1, [2341514747, 6])
        XCTAssertEqual(BigInteger.divide(mag1: c.mag, mag2: d.mag).0, [1])
        XCTAssertEqual(BigInteger.divide(mag1: c.mag, mag2: d.mag).1, [1192611317, 2164911735, 1271585])
    }

    func testStringConvertible() {
        let a = BigInteger(from: "612361193061935861237")
        XCTAssertEqual(String(a), "612361193061935861237")
        let b = BigInteger(from: "-612361193061935861237324234354353452352542352435435252435453")
        XCTAssertEqual(String(b), "-612361193061935861237324234354353452352542352435435252435453")
        XCTAssertEqual(String(BigInteger(from: "0")), "0")
    }

    func testAddT1() {
        let a = BigInteger(from: "0000000000000000000000000000000000000612361193061935861237")
        let b = BigInteger(from: "-6123611930619358612362")
        let c = BigInteger(from: "-612361193061935861237")
        let d = BigInteger(from: "6123611930619358612362")

        XCTAssertEqual((a + a).mag, BigInteger(from: "1224722386123871722474").mag)
        XCTAssertEqual((a + a).signum, BigInteger(from: "1224722386123871722474").signum)

        XCTAssertEqual(String(a + b), "-5511250737557422751125")
        XCTAssertEqual(String(c + d), "5511250737557422751125")
    }

    func testSubtractT1() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "-6123611930619358612362")
        let c = BigInteger(from: "-612361193061935861237")
        let d = BigInteger(from: "6123611930619358612362")

        XCTAssertEqual(String(a - a), "0")
        XCTAssertEqual(String(a - b), "6735973123681294473599")

        XCTAssertEqual(String(c - c), "0")
        XCTAssertEqual(String(c - d), "-6735973123681294473599")
    }

    func testMultiplyT1() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "-6123611930619358612362")
        XCTAssertEqual(String(a * b), "-3749862307682374847564897134347193704811794")
        XCTAssertEqual(String(a * a), "374986230768237484756979602389168919170169")
        XCTAssertEqual(String(a * BigInteger(from: "0")), "0")
    }

    func testDivideT1() {
        let a = BigInteger(from: "-612361193061935861237")
        let b = BigInteger(from: "6123611930619358612362")
        XCTAssertEqual(String(a / a), "1")
        XCTAssertEqual(String(a / b), "0")
        XCTAssertEqual(String(b / a), "-9")
    }
    
    func testAddT2() {
        let a = BigInteger(from: numA2048)
        let b = BigInteger(from: numB2048)
        let minusB = BigInteger(from: "-" + numB2048)

        let x : PythonObject = numA2048.pythonObject
        let y : PythonObject = numB2048.pythonObject
        XCTAssertEqual(String(a + b), String(Python.int(x) + Python.int(y)))
        XCTAssertEqual(String(a + minusB), String(Python.int(x) - Python.int(y)))
    }
    
    func testSubtractT2() {
        let a = BigInteger(from: numA2048)
        let b = BigInteger(from: numB2048)
        let ma = BigInteger(from: "-" + numA2048)
        let mb = BigInteger(from: "-" + numB2048)
        var x : PythonObject = numA2048.pythonObject
        let y : PythonObject = numB2048.pythonObject
        
        XCTAssertEqual(String(a - b), String(Python.int(x) - Python.int(y)))
        x = ("-" + numA2048).pythonObject
        XCTAssertEqual(String(ma - mb), String(Python.int(x) + Python.int(y)))
    }
    
    func testMultiplyT2() {
        var a = BigInteger(from: numA2048)
        let b = BigInteger(from: numB2048)
        var x : PythonObject = numA2048.pythonObject
        let y : PythonObject = numB2048.pythonObject
        
        XCTAssertEqual(String(a * b), String(Python.int(x) * Python.int(y)))
        x = ("-" + numA2048).pythonObject
        a = BigInteger(from: "-" + numA2048)
        XCTAssertEqual(String(a * b), String(Python.int(x) * Python.int(y)))
    }
    
    func testDivideT2() {
        let a = BigInteger(from: numA2048)
        let b = BigInteger(from: numA256)
        let x : PythonObject = numA2048.pythonObject
        let y : PythonObject = numA256.pythonObject
        
        //Python's division for negative number is not the same here.
        XCTAssertEqual(String(a / b), String(Python.divmod(Python.int(x), Python.int(y)).tuple2.0))
    }
    
    func testModT2() {
        let a = BigInteger(from: numA2048)
        let b = BigInteger(from: numA256)
        let x : PythonObject = numA2048.pythonObject
        let y : PythonObject = numA256.pythonObject
        
        //Python's division for negative number is not the same here.
        XCTAssertEqual(String(a % b), String(Python.divmod(Python.int(x), Python.int(y)).tuple2.1))
    }
    
    func testAnd() {
        var a = BigInteger(from: numA2048)
        var b = BigInteger(from: numB2048)
        var x : PythonObject = numA2048.pythonObject
        var y : PythonObject = numB2048.pythonObject
        
        //positive AND positive
        XCTAssertEqual(String(a & b), String(Python.int(x) & Python.int(y)))
        x = ("-" + numA2048).pythonObject
        a = BigInteger(from: "-" + numA2048)
        //negative AND positive
        XCTAssertEqual(String(a & b), String(Python.int(x) & Python.int(y)))
        y = ("-" + numB2048).pythonObject
        b = BigInteger(from: "-" + numB2048)
        //negative AND negative
        XCTAssertEqual(String(a & b), String(Python.int(x) & Python.int(y)))
    }
    
    func testOr() {
        var a = BigInteger(from: numA2048)
        var b = BigInteger(from: numB2048)
        var x : PythonObject = numA2048.pythonObject
        var y : PythonObject = numB2048.pythonObject
        
        //positive OR positive
        XCTAssertEqual(String(a | b), String(Python.int(x) | Python.int(y)))
        x = ("-" + numA2048).pythonObject
        a = BigInteger(from: "-" + numA2048)
        //negative OR positive
        XCTAssertEqual(String(a | b), String(Python.int(x) | Python.int(y)))
        y = ("-" + numB2048).pythonObject
        b = BigInteger(from: "-" + numB2048)
        //negative OR negative
        XCTAssertEqual(String(a | b), String(Python.int(x) | Python.int(y)))
    }
    
    func testNot() {
        var a = BigInteger(from: numA2048)
        var x : PythonObject = numA2048.pythonObject
        
        //positive NOT
        XCTAssertEqual(String(~a), String(~Python.int(x)))
        x = ("-" + numA2048).pythonObject
        a = BigInteger(from: "-" + numA2048)
        //negative NOT
        XCTAssertEqual(String(~a), String(~Python.int(x)))
    }
    
    func testXor() {
        var a = BigInteger(from: numA2048)
        var b = BigInteger(from: numB2048)
        var x : PythonObject = numA2048.pythonObject
        var y : PythonObject = numB2048.pythonObject
        
        //positive XOR positive
        XCTAssertEqual(String(a ^ b), String(Python.int(x) ^ Python.int(y)))
        x = ("-" + numA2048).pythonObject
        a = BigInteger(from: "-" + numA2048)
        //negative XOR positive
        XCTAssertEqual(String(a ^ b), String(Python.int(x) ^ Python.int(y)))
        y = ("-" + numB2048).pythonObject
        b = BigInteger(from: "-" + numB2048)
        //negative XOR negative
        XCTAssertEqual(String(a ^ b), String(Python.int(x) ^ Python.int(y)))
    }
    
    func testLeftShift() {
        let a = BigInteger(from: numA20480)
        let b = BigInteger(from: "-" + numA20480)
        let x : PythonObject = numA20480.pythonObject
        let y :PythonObject = ("-" + numA20480).pythonObject
        //positive
        XCTAssertEqual(String(a << 19358),
                       String(Python.int(x) * Python.pow(2, 19358)))
        //negative
        XCTAssertEqual(String(b << 19358),
                       String(Python.int(y) * Python.pow(2, 19358)))
    }
    
    func testRightShift() {
        let a = BigInteger(from: numA20480)
        let b = BigInteger(from: "-" + numA20480)
        let x : PythonObject = numA20480.pythonObject
        let y :PythonObject = ("-" + numA20480).pythonObject
        //positive
        XCTAssertEqual(String(a >> 19358),
                       String(Python.divmod(Python.int(x),
                              Python.pow(2, 19358)).tuple2.0))
        XCTAssertEqual(String(a >> 1935800),
                       String(Python.divmod(Python.int(x),
                              Python.pow(2, 1935800)).tuple2.0))
        //negative
        XCTAssertEqual(String(b >> 2048),
                       String(Python.divmod(Python.int(y),
                              Python.pow(2, 2048)).tuple2.0))
        XCTAssertEqual(String(b >> 1935800),
                       String(Python.divmod(Python.int(y),
                              Python.pow(2, 1935800)).tuple2.0))
    }
    
    //Return a n size positive test number
    static func getRandomNum(withCount n : Int) -> String {
        var result = ""
        for _ in 0 ..< n {
            result += String(arc4random() % 10)
        }
        return result
    }
}

//Make PythonObject string convertible
extension String {
    public init(_ val : PythonObject) {
        self = val.description
    }
}
