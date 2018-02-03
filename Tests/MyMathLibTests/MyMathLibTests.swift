/***********************************************************
 Pour lancer les tests j'ai pas touvé mieux que :
 menu "Product/Perform Action/Test x Items"
***********************************************************/

import XCTest
@testable import MyMathLib

class MyMathLibTests: XCTestCase
{
   let nombres1 = [3.0,5.0,7.0,15.0]
   let nombres2 = [8.0,6.0,5.0,2.0]

   func testVecteur()
   {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct
      // results.
      var monVect1 = Vecteur(nombres1)
      let monVect2 = Vecteur(nombres2)
      let monVect3 = (3*monVect2).transpose()

        XCTAssertEqual("\(monVect3)", "[24.0,18.0,15.0,6.0]")
   }
   func testEgaliteVecteurs()
   {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct
      // results.
      var monVect1 = Vecteur(nombres1)
      let monVect2 = Vecteur(nombres2)

      
      XCTAssertEqual(monVect1==monVect1, true)
   }
   func testInegaliteVecteurs()
   {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct
      // results.
      var monVect1 = Vecteur(nombres1)
      let monVect2 = Vecteur(nombres2)
      
      
      XCTAssertEqual(monVect1==monVect2, false)
   }


   static var allTests =
   [
        ("testVecteur", testVecteur),
        ("testEgaliteVecteurs", testEgaliteVecteurs),
        ("testInegaliteVecteurs", testInegaliteVecteurs),
   ]
}
