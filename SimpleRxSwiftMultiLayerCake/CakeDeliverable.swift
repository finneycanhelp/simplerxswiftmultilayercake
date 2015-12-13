import UIKit
import RxSwift
import RxCocoa

protocol CakeDeliverable {
    
    var oldBakery: OldBakeryService { get set }
    var disposeBag: DisposeBag { get set }
}

// This exists because the first time a cake is obtained, it is obtained from the old bakery. 
// Subsequent requests for the same cake will come from the new bakery which is going to be implemented later.

extension CakeDeliverable {

    func fetchCake(cakeIdentification: String) -> Observable<Cake> {
        return create { observer in
            
            self.oldBakery.makeRequest(cakeIdentification)
                .subscribe(onNext: observer.onNext, onError: observer.onError)
                .addDisposableTo(self.disposeBag)
            return NopDisposable.instance
        }
    }
}