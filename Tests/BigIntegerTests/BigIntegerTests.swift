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
    let pyBigIntA16 = Python.int(numA16.pythonObject)
    let _bigIntA16 = BigInteger(from: _numA16)
    let _intA16 = Int(_numA16)!
    let _pyBigIntA16 = Python.int(_numA16.pythonObject)
    
    //16 digits long big integer B
    let bigIntB16 = BigInteger(from: numB16)
    let intB16 = Int(numB16)!
    let pyBigIntB16 = Python.int(numB16.pythonObject)
    let _bigIntB16 = BigInteger(from: _numB16)
    let _intB16 = Int(_numB16)!
    let _pyBigIntB16 = Python.int(_numB16.pythonObject)
    
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
        
        //mix case, a > 0 && b > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 + bigIntB16),
                       String(pyBigIntA2048 + pyBigIntB16))
        //mix case, a > 0 && b < 0, a << b
        XCTAssertEqual(String(bigIntA16 + _bigIntB2048),
                       String(pyBigIntA16 + _pyBigIntB2048))
        //mix case, a < 0 && b > 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 + bigIntB16),
                       String(_pyBigIntA2048 + pyBigIntB16))
        //mix case, a < 0 && b < 0, a << b
        XCTAssertEqual(String(_bigIntA16 + _bigIntB2048),
                       String(_pyBigIntA16 + _pyBigIntB2048))
        
        //+=
        var a = bigIntA2048
        a += bigIntB2048
        XCTAssertEqual(String(a), String(pyBigIntA2048 + pyBigIntB2048))
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
                       String(0 - 0))
        
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
        
        //mix case, a > 0 && b > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 - bigIntB16),
                       String(pyBigIntA2048 - pyBigIntB16))
        //mix case, a > 0 && b < 0, a << b
        XCTAssertEqual(String(bigIntA16 - _bigIntB2048),
                       String(pyBigIntA16 - _pyBigIntB2048))
        //mix case, a < 0 && b > 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 - bigIntB16),
                       String(_pyBigIntA2048 - pyBigIntB16))
        //mix case, a < 0 && b < 0, a << b
        XCTAssertEqual(String(_bigIntA16 - _bigIntB2048),
                       String(_pyBigIntA16 - _pyBigIntB2048))
        
        //-=
        var a = bigIntA2048
        a -= bigIntB2048
        XCTAssertEqual(String(a), String(pyBigIntA2048 - pyBigIntB2048))
    }
    
    func testMultiply() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO * bigIntB2048),
                       String(0 * pyBigIntB2048))
        //special case, b == 0
        XCTAssertEqual(String(bigIntA2048 * BigInteger.ZERO),
                       String(pyBigIntA2048 * 0))
        //special case, a == 0 && b == 0
        XCTAssertEqual(String(BigInteger(from: "0") * BigInteger.ZERO),
                       String(0 * 0))
        
        //small case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA16 * bigIntB16),
                       String(pyBigIntA16 * pyBigIntB16))
        //small case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA16 * _bigIntB16),
                       String(pyBigIntA16 * _pyBigIntB16))
        //small case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA16 * bigIntB16),
                       String(_pyBigIntA16 * pyBigIntB16))
        //small case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA16 * _bigIntB16),
                       String(_pyBigIntA16 * _pyBigIntB16))
        
        //big case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA2048 * bigIntB2048),
                       String(pyBigIntA2048 * pyBigIntB2048))
        //big case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA2048 * _bigIntB2048),
                       String(pyBigIntA2048 * _pyBigIntB2048))
        //big case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA2048 * bigIntB2048),
                       String(_pyBigIntA2048 * pyBigIntB2048))
        //big case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA2048 * _bigIntB2048),
                       String(_pyBigIntA2048 * _pyBigIntB2048))
        
        //mix case, a > 0 && b > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 * bigIntB16),
                       String(pyBigIntA2048 * pyBigIntB16))
        //mix case, a > 0 && b < 0, a << b
        XCTAssertEqual(String(bigIntA16 * _bigIntB2048),
                       String(pyBigIntA16 * _pyBigIntB2048))
        //mix case, a < 0 && b > 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 * bigIntB16),
                       String(_pyBigIntA2048 * pyBigIntB16))
        //mix case, a < 0 && b < 0, a << b
        XCTAssertEqual(String(_bigIntA16 * _bigIntB2048),
                       String(_pyBigIntA16 * _pyBigIntB2048))
        
        //*=
        var a = bigIntA2048
        a *= bigIntB2048
        XCTAssertEqual(String(a), String(pyBigIntA2048 * pyBigIntB2048))
    }
    
    func testDivide() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO / bigIntB2048),
                       String(Python.divmod(0, pyBigIntB2048).tuple2.0))
        //special case, b == 0, report error
//        XCTAssertEqual(String(bigIntA2048 / BigInteger.ZERO),
//                       String(pyBigIntA2048 / 0))
        //special case, a == 0 && b == 0, report error
//        XCTAssertEqual(String(BigInteger(from: "0") / BigInteger.ZERO),
//                       String(0 / 0))
        //special case, b == 2 ** n
        XCTAssertEqual(String(bigIntA2048 / (BigInteger(from: "1") << 3648)),
                       String(Python.divmod(pyBigIntA2048,
                                            Python.pow(2, 3648)).tuple2.0))
        
        //small case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA16 / bigIntB16),
                       String(intA16 / intB16))
        //small case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA16 / _bigIntB16),
                       String(intA16 / _intB16))
        //small case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA16 / bigIntB16),
                       String(_intA16 / intB16))
        //small case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA16 / _bigIntB16),
                       String(_intA16 / _intB16))

        //big case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA2048 / bigIntB2048),
                       String(Python.divmod(pyBigIntA2048, pyBigIntB2048)
                                .tuple2.0))
        //big case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA2048 / _bigIntB2048 * _bigIntB2048 +
                             bigIntA2048 % _bigIntB2048),
                       String(bigIntA2048))
        //big case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA2048 / bigIntB2048 * bigIntB2048 +
                             _bigIntA2048 % bigIntB2048),
                       String(_bigIntA2048))
        //big case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA2048 / _bigIntB2048),
                       String(Python.divmod(_pyBigIntA2048, _pyBigIntB2048)
                                .tuple2.0))

        //mix case, a > 0 && b > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 / bigIntB16),
                       String(Python.divmod(pyBigIntA2048, pyBigIntB16)
                                .tuple2.0))
        //mix case, a > 0 && b < 0, a << b
        XCTAssertEqual(String(bigIntA16 / _bigIntB2048 * _bigIntB2048 +
                             bigIntA16 % _bigIntB2048),
                       String(bigIntA16))
        //mix case, a < 0 && b > 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 / bigIntB16 * bigIntB16 +
                             _bigIntA2048 % bigIntB16),
                       String(_bigIntA2048))
        //mix case, a < 0 && b < 0, a << b
        XCTAssertEqual(String(_bigIntA16 / _bigIntB2048),
                       String(Python.divmod(_pyBigIntA16, _pyBigIntB2048)
                                .tuple2.0))
        
        //Python's division for negative number is not the same here.
        
        // /=
        var a = bigIntA2048
        a /= bigIntB2048
        XCTAssertEqual(String(a),
                       String(Python.divmod(pyBigIntA2048, pyBigIntB2048)
                                            .tuple2.0))
    }
    
    func testMod() {
        //the remainder always have the same sign of quo.
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO % bigIntB2048),
                       String(Python.divmod(0, pyBigIntB2048).tuple2.1))
        //special case, b == 0, report error
//        XCTAssertEqual(String(bigIntA2048 / BigInteger.ZERO),
//                       String(pyBigIntA2048 / 0))
        //special case, a == 0 && b == 0, report error
//        XCTAssertEqual(String(BigInteger(from: "0") / BigInteger.ZERO),
//                       String(0 / 0))
        //small case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA16 % bigIntB16),
                       String(intA16 % intB16))
        //small case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA16 % _bigIntB16),
                       String(intA16 % _intB16))
        //small case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA16 % bigIntB16),
                       String(_intA16 % intB16))
        //small case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA16 % _bigIntB16),
                       String(_intA16 % _intB16))

        //big case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA2048 % bigIntB2048),
                       String(Python.divmod(pyBigIntA2048, pyBigIntB2048)
                                .tuple2.1))
        //big case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA2048 / _bigIntB2048 * _bigIntB2048 +
                             bigIntA2048 % _bigIntB2048),
                       String(bigIntA2048))
        //big case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA2048 / bigIntB2048 * bigIntB2048 +
                             _bigIntA2048 % bigIntB2048),
                       String(_bigIntA2048))
        //big case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA2048 % _bigIntB2048),
                       String(Python.divmod(_pyBigIntA2048, _pyBigIntB2048)
                                .tuple2.1))

        //mix case, a > 0 && b > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 % bigIntB16),
                       String(Python.divmod(pyBigIntA2048, pyBigIntB16)
                                .tuple2.1))
        //mix case, a > 0 && b < 0, a << b
        XCTAssertEqual(String(bigIntA16 / _bigIntB2048 * _bigIntB2048 +
                             bigIntA16 % _bigIntB2048),
                       String(bigIntA16))
        //mix case, a < 0 && b > 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 / bigIntB16 * bigIntB16 +
                             _bigIntA2048 % bigIntB16),
                       String(_bigIntA2048))
        //mix case, a < 0 && b < 0, a << b
        XCTAssertEqual(String(_bigIntA16 % _bigIntB2048),
                       String(Python.divmod(_pyBigIntA16, _pyBigIntB2048)
                                .tuple2.1))
        
        //%=
        var a = bigIntA2048
        a %= bigIntB2048
        XCTAssertEqual(String(a),
                       String(Python.divmod(pyBigIntA2048, pyBigIntB2048)
                                            .tuple2.1))
        
        //Python's division for negative number is not the same here.
    }
    
    func testAnd() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO & bigIntB2048),
                       String(0 & pyBigIntB2048))
        //special case, b == 0,
        XCTAssertEqual(String(bigIntA2048 & BigInteger.ZERO),
                       String(pyBigIntA2048 & 0))
        //special case, a == 0 && b == 0
        XCTAssertEqual(String(BigInteger(from: "0") & BigInteger.ZERO),
                       String(0 & 0))
        
        //small case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA16 & bigIntB16),
                       String(intA16 & intB16))
        //small case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA16 & _bigIntB16),
                       String(intA16 & _intB16))
        //small case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA16 & bigIntB16),
                       String(_intA16 & intB16))
        //small case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA16 & _bigIntB16),
                       String(_intA16 & _intB16))
        
        //big case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA2048 & bigIntB2048),
                       String(pyBigIntA2048 & pyBigIntB2048))
        //big case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA2048 & _bigIntB2048),
                       String(pyBigIntA2048 & _pyBigIntB2048))
        //big case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA2048 & bigIntB2048),
                       String(_pyBigIntA2048 & pyBigIntB2048))
        //big case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA2048 & _bigIntB2048),
                       String(_pyBigIntA2048 & _pyBigIntB2048))
        
        //mix case, a > 0 && b > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 & bigIntB16),
                       String(pyBigIntA2048 & pyBigIntB16))
        //mix case, a > 0 && b < 0, a << b
        XCTAssertEqual(String(bigIntA16 & _bigIntB2048),
                       String(pyBigIntA16 & _pyBigIntB2048))
        //mix case, a < 0 && b > 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 & bigIntB16),
                       String(_pyBigIntA2048 & pyBigIntB16))
        //mix case, a < 0 && b < 0, a << b
        XCTAssertEqual(String(_bigIntA16 & _bigIntB2048),
                       String(_pyBigIntA16 & _pyBigIntB2048))
        
        //&=
        var a = bigIntA2048
        a &= bigIntB2048
        XCTAssertEqual(String(a),String(pyBigIntA2048 & pyBigIntB2048))
                                 
    }
    
    func testOr() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO | bigIntB2048),
                       String(0 | pyBigIntB2048))
        //special case, b == 0,
        XCTAssertEqual(String(bigIntA2048 | BigInteger.ZERO),
                       String(pyBigIntA2048 | 0))
        //special case, a == 0 && b == 0
        XCTAssertEqual(String(BigInteger(from: "0") | BigInteger.ZERO),
                       String(0 | 0))
        
        //small case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA16 | bigIntB16),
                       String(intA16 | intB16))
        //small case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA16 | _bigIntB16),
                       String(intA16 | _intB16))
        //small case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA16 | bigIntB16),
                       String(_intA16 | intB16))
        //small case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA16 | _bigIntB16),
                       String(_intA16 | _intB16))
        
        //big case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA2048 | bigIntB2048),
                       String(pyBigIntA2048 | pyBigIntB2048))
        //big case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA2048 | _bigIntB2048),
                       String(pyBigIntA2048 | _pyBigIntB2048))
        //big case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA2048 | bigIntB2048),
                       String(_pyBigIntA2048 | pyBigIntB2048))
        //big case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA2048 | _bigIntB2048),
                       String(_pyBigIntA2048 | _pyBigIntB2048))
        
        //mix case, a > 0 && b > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 | bigIntB16),
                       String(pyBigIntA2048 | pyBigIntB16))
        //mix case, a > 0 && b < 0, a << b
        XCTAssertEqual(String(bigIntA16 | _bigIntB2048),
                       String(pyBigIntA16 | _pyBigIntB2048))
        //mix case, a < 0 && b > 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 | bigIntB16),
                       String(_pyBigIntA2048 | pyBigIntB16))
        //mix case, a < 0 && b < 0, a << b
        XCTAssertEqual(String(_bigIntA16 | _bigIntB2048),
                       String(_pyBigIntA16 | _pyBigIntB2048))
        
        //|=
        var a = bigIntA2048
        a |= bigIntB2048
        XCTAssertEqual(String(a),String(pyBigIntA2048 | pyBigIntB2048))
    }
    
    func testNot() {
        //special case, a == 0
        XCTAssertEqual(String(~BigInteger.ZERO),
                       String(~0))
        
        //small case, a > 0
        XCTAssertEqual(String(~bigIntA16),
                       String(~intA16))
        //small case, a < 0
        XCTAssertEqual(String(~_bigIntA16),
                       String(~_intA16))
        
        //big case, a > 0
        XCTAssertEqual(String(~bigIntA2048),
                       String(~pyBigIntA2048))
        //big case, a < 0
        XCTAssertEqual(String(~_bigIntA2048),
                       String(~_pyBigIntA2048))
    }
    
    func testXor() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO ^ bigIntB2048),
                       String(0 ^ pyBigIntB2048))
        //special case, b == 0,
        XCTAssertEqual(String(bigIntA2048 ^ BigInteger.ZERO),
                       String(pyBigIntA2048 ^ 0))
        //special case, a == 0 && b == 0
        XCTAssertEqual(String(BigInteger(from: "0") ^ BigInteger.ZERO),
                       String(0 ^ 0))
        
        //small case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA16 ^ bigIntB16),
                       String(intA16 ^ intB16))
        //small case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA16 ^ _bigIntB16),
                       String(intA16 ^ _intB16))
        //small case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA16 ^ bigIntB16),
                       String(_intA16 ^ intB16))
        //small case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA16 ^ _bigIntB16),
                       String(_intA16 ^ _intB16))
        
        //big case, a > 0 && b > 0
        XCTAssertEqual(String(bigIntA2048 ^ bigIntB2048),
                       String(pyBigIntA2048 ^ pyBigIntB2048))
        //big case, a > 0 && b < 0
        XCTAssertEqual(String(bigIntA2048 ^ _bigIntB2048),
                       String(pyBigIntA2048 ^ _pyBigIntB2048))
        //big case, a < 0 && b > 0
        XCTAssertEqual(String(_bigIntA2048 ^ bigIntB2048),
                       String(_pyBigIntA2048 ^ pyBigIntB2048))
        //big case, a < 0 && b < 0
        XCTAssertEqual(String(_bigIntA2048 ^ _bigIntB2048),
                       String(_pyBigIntA2048 ^ _pyBigIntB2048))
        
        //mix case, a > 0 && b > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 ^ bigIntB16),
                       String(pyBigIntA2048 ^ pyBigIntB16))
        //mix case, a > 0 && b < 0, a << b
        XCTAssertEqual(String(bigIntA16 ^ _bigIntB2048),
                       String(pyBigIntA16 ^ _pyBigIntB2048))
        //mix case, a < 0 && b > 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 ^ bigIntB16),
                       String(_pyBigIntA2048 ^ pyBigIntB16))
        //mix case, a < 0 && b < 0, a << b
        XCTAssertEqual(String(_bigIntA16 ^ _bigIntB2048),
                       String(_pyBigIntA16 ^ _pyBigIntB2048))
        
        //^=
        var a = bigIntA2048
        a ^= bigIntB2048
        XCTAssertEqual(String(a),String(pyBigIntA2048 ^ pyBigIntB2048))
    }
    
    func testLeftShift() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO << 19358),
                       String(0))
        //special case, b == 0,
        XCTAssertEqual(String(bigIntA2048 << 0),
                       String(pyBigIntA2048 * Python.pow(2, 0)))
        //special case, a == 0 && b == 0
        XCTAssertEqual(String(BigInteger(from: "0") << 0),
                       String(0 << 0))
        
        //small case, a > 0
        XCTAssertEqual(String(bigIntA16 << 12361),
                       String(pyBigIntA16 * Python.pow(2, 12361)))
        //small case, a < 0
        XCTAssertEqual(String(_bigIntA16 << 19348),
                       String(_pyBigIntA16 * Python.pow(2, 19348)))
        
        //big case, a > 0
        XCTAssertEqual(String(bigIntA2048 << 12333),
                       String(pyBigIntA2048 * Python.pow(2, 12333)))
        //big case, a < 0
        XCTAssertEqual(String(_bigIntA2048 << 19333),
                       String(_pyBigIntA2048 * Python.pow(2, 19333)))
        
        //mix case, a > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 << 61),
                       String(pyBigIntA2048 * Python.pow(2, 61)))
        //mix case, a > 0, a << b
        XCTAssertEqual(String(BigInteger(from: "6") << 19306),
                       String(6 * Python.pow(2, 19306)))
        //mix case, a < 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 << 61),
                       String(_pyBigIntA2048 * Python.pow(2, 61)))
        //mix case, a < 0, a << b
        XCTAssertEqual(String(BigInteger(from: "-6") << 19306),
                       String(-6 * Python.pow(2, 19306)))
        
        //<<=
        var a = bigIntA2048
        a <<= 19306
        XCTAssertEqual(String(a),String(pyBigIntA2048 * Python.pow(2, 19306)))
    }
    
    func testRightShift() {
        //special case, a == 0
        XCTAssertEqual(String(BigInteger.ZERO >> 19358),
                       String(0))
        //special case, b == 0,
        XCTAssertEqual(String(bigIntA2048 >> 0),
                       String(Python.divmod(pyBigIntA2048,
                                            Python.pow(2, 0)).tuple2.0))
        //special case, a == 0 && b == 0
        XCTAssertEqual(String(BigInteger(from: "0") >> 0),
                       String(0 >> 0))
        
        //small case, a > 0
        XCTAssertEqual(String(bigIntA16 >> 61),
                       String(intA16 >> 61))
        //small case, a < 0
        XCTAssertEqual(String(_bigIntA16 >> 48),
                       String(_intA16 >> 48))
        
        //big case, a > 0
        XCTAssertEqual(String(bigIntA2048 >> 12333),
                       String(Python.divmod(pyBigIntA2048,
                                            Python.pow(2, 12333)).tuple2.0))
        //big case, a < 0
        XCTAssertEqual(String(_bigIntA2048 >> 19333),
                       String(Python.divmod(_pyBigIntA2048,
                                            Python.pow(2, 19333)).tuple2.0))
        
        //mix case, a > 0, a >> b  (>> stand for much larger)
        XCTAssertEqual(String(bigIntA2048 >> 61),
                       String(Python.divmod(pyBigIntA2048,
                                            Python.pow(2, 61)).tuple2.0))
        //mix case, a > 0, a << b
        XCTAssertEqual(String(BigInteger(from: "6") >> 19306),
                       String(Python.divmod(6, Python.pow(2, 19306)).tuple2.0))
        //mix case, a < 0, a >> b
        XCTAssertEqual(String(_bigIntA2048 >> 61),
                       String(Python.divmod(_pyBigIntA2048,
                                            Python.pow(2, 61)).tuple2.0))
        //mix case, a < 0, a << b
        XCTAssertEqual(String(BigInteger(from: "-6") >> 19306),
                       String(Python.divmod(-6, Python.pow(2, 19306)).tuple2.0))
        
        //<<=
        var a = bigIntA2048
        a >>= 58
        XCTAssertEqual(String(a),
                       String(Python.divmod(pyBigIntA2048,
                                            Python.pow(2, 58)).tuple2.0))
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
