import UIKit

///TEST CLOSURE : Pour gerer le slideLenght  et le translation.y qui retourne vrai ou faux
func testClosure(parametreDuClosure: (Int, Int) -> Bool) {
    if parametreDuClosure(5, 4) {
        print("Condition validée.")
    }
}

testClosure(parametreDuClosure: { (nb1: Int, nb2: Int) -> Bool in
    return nb1 > nb2
})
