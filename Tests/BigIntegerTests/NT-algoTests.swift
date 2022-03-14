import XCTest
import BigInteger
import PythonKit

final class NT_algoTests : XCTestCase {
    static let numA2048 = BigIntegerTests.getRandomNum(withCount: 2048)
    static let _numA2048 = "-" + numA2048
    static let numB2048 = BigIntegerTests.getRandomNum(withCount: 2048)
    static let _numB2048 = "-" + numB2048
    static let numA16 = BigIntegerTests.getRandomNum(withCount: 16)
    static let _numA16 = "-" + numA16
    static let numB16 = BigIntegerTests.getRandomNum(withCount: 16)
    static let _numB16 = "-" + numB16
    static let numA20480 = BigIntegerTests.getRandomNum(withCount: 20480)

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

     func testGCD() {
         let py_math = Python.import("math")
         XCTAssertEqual(String(BigInteger.gcd(BigInteger.ZERO, BigInteger.ZERO)),
                        String(0))
         BigInteger.gcd(BigInteger(12312312312), BigInteger(231321231))
         //XCTAssertEqual(String(BigInteger.gcd(bigIntA2048, bigIntB2048)),
                        //String(py_math.gcd(pyBigIntA2048, pyBigIntB2048)))
         //print(BigInteger(231321231) % BigInteger(52287069))
     }
    
    func testPrime() {
        var rng = SystemRandomNumberGenerator()
        print(BigInteger.nextProbablePrime(withMaximumWidth: 2048, &rng))
        //print(BigInteger.largePrime(withMaximumWidth: 2048, 4, &rng))
    }
}
