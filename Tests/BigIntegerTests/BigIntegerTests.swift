import XCTest
@testable import BigInteger
import PythonKit

final class BigIntegerTests: XCTestCase {
    static let numA2048 = getRandomNum(withCount: 2048)
    static let _numA2048 = "-" + numA2048
    static let numB2048 = getRandomNum(withCount: 2048)
    static let _numB2048 = "-" + numB2048
    static let numA16 = getRandomNum(withCount: 16)
    static let _numA16 = "-" + numA16
    static let numB16 = getRandomNum(withCount: 16)
    static let _numB16 = "-" + numB16
    static let numA20480 = getRandomNum(withCount: 20480)
    
    //2048 digits long big integer A
    let bigIntA2048 = BigInteger(from: numA2048)
    let pyBigIntA2048 = Python.int(numA2048.pythonObject)
    let _bigIntA2048 = BigInteger(from: _numA2048)
    let _pyBigIntA2048 = Python.int(_numA2048.pythonObject)
    
    //2048 digits long big integer B
    let bigIntB2048 = BigInteger(from: numB2048)
    let pyBigIntB2048 = Python.int(numB2048.pythonObject)
    let _bigIntB2048 = BigInteger(from: _numB2048)
    let _pyBigIntB2048 = Python.int(_numB2048.pythonObject)
    
    //16 digits long big integer A
    let bigIntA16 = BigInteger(from: numA16)
    let intA16 = Int(numA16)!
    let _bigIntA16 = BigInteger(from: _numA16)
    let _intA16 = -1 * Int(numA16)!
    
    //16 digits long big integer B
    let bigIntB16 = BigInteger(from: numB16)
    let intB16 = Int(numB16)!
    let _bigIntB16 = BigInteger(from: _numB16)
    let _intB16 = -1 * Int(numB16)!
    
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

    func testStringConvertible() {
        let a = BigInteger(from: "612361193061935861237")
        XCTAssertEqual(String(a), "612361193061935861237")
        let b = BigInteger(from: "-612361193061935861237324234354353452352542352435435252435453")
        XCTAssertEqual(String(b), "-612361193061935861237324234354353452352542352435435252435453")
        XCTAssertEqual(String(BigInteger(from: "0")), "0")
    }
    
    func testAdd() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO + bigIntB2048),
                       String(0 + pyBigIntB2048))
        //special case, b == 0
        XCTAssertEqual(String(bigIntA2048 + BigInteger.ZERO),
                       String(pyBigIntA2048 + 0))
        //special case, a == 0 && b == 0
        XCTAssertEqual(String(BigInteger(from: "0") + BigInteger.ZERO),
                       String(0 + 0))
        
        //small case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA16 + bigIntB16),
                       String(intA16 + intB16))
        //small case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA16 + _bigIntB16),
                       String(intA16 + _intB16))
        //small case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA16 + bigIntB16),
                       String(_intA16 + intB16))
        //small case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA16 + _bigIntB16),
                       String(_intA16 + _intB16))
        
        //big case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA2048 + bigIntB2048),
                       String(pyBigIntA2048 + pyBigIntB2048))
        //big case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA2048 + _bigIntB2048),
                       String(pyBigIntA2048 + _pyBigIntB2048))
        //big case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA2048 + bigIntB2048),
                       String(_pyBigIntA2048 + pyBigIntB2048))
        //big case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA2048 + _bigIntB2048),
                       String(_pyBigIntA2048 + _pyBigIntB2048))
    }
    
    func testSubtract() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO - bigIntB2048),
                       String(0 - pyBigIntB2048))
        //special case, b == 0
        XCTAssertEqual(String(bigIntA2048 - BigInteger.ZERO),
                       String(pyBigIntA2048 - 0))
        //special case, a == 0 && b == 0
        XCTAssertEqual(String(BigInteger(from: "0") - BigInteger.ZERO),
                       String(0 + 0))
        
        //small case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA16 - bigIntB16),
                       String(intA16 - intB16))
        //small case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA16 - _bigIntB16),
                       String(intA16 - _intB16))
        //small case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA16 - bigIntB16),
                       String(_intA16 - intB16))
        //small case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA16 - _bigIntB16),
                       String(_intA16 - _intB16))
        
        //big case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA2048 - bigIntB2048),
                       String(pyBigIntA2048 - pyBigIntB2048))
        //big case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA2048 - _bigIntB2048),
                       String(pyBigIntA2048 - _pyBigIntB2048))
        //big case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA2048 - bigIntB2048),
                       String(_pyBigIntA2048 - pyBigIntB2048))
        //big case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA2048 - _bigIntB2048),
                       String(_pyBigIntA2048 - _pyBigIntB2048))
    }
    /*
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
    }*/
    
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
