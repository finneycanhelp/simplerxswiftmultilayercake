
import Foundation

protocol CakeError: ErrorType {
    var message: String { get set }
}

struct OldBakeryError: CakeError {
    var message: String
    var code: String?
}
