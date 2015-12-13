import Foundation
import RxSwift

class CakeApi : CakeDeliverable /* other protocols will go here */ {

    var networkRequestable: NetworkRequestable = NetworkRequestMaker()
    var oldBakeryService: OldBakeryService = OldBakeryService()
    var disposeBag = DisposeBag()
    
    static let sharedAPI = CakeApi()
    
}

