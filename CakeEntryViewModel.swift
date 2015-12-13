
import Foundation
import RxSwift

struct CakeEntryViewModel {
    
    let cakeIdentification = Variable("")
    let disposeBag = DisposeBag()
    var cakeApi: CakeDeliverable = CakeApi.sharedAPI
    
    func grabCake() -> Observable<Cake> {
        
        return create { observer in
            self.cakeApi.fetchCake(self.cakeIdentification.value)
                .subscribe(onNext: observer.onNext, onError: observer.onError)
            .addDisposableTo(self.disposeBag)
            return NopDisposable.instance
        }
    }
}