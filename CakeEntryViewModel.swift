
import Foundation
import RxSwift

struct CakeEntryViewModel {
    
    let cakeIdentification = Variable("")
    let disposeBag = DisposeBag()
    var cakeAPI: CakeDeliverable = CakeApi.sharedAPI
    
    func grabCake() -> Observable<Cake> {
        
        return Observable.create { observer in
            self.cakeAPI.fetchCake(self.cakeIdentification.value)
                .subscribe(onNext: observer.onNext, onError: observer.onError)
            .addDisposableTo(self.disposeBag)
            return NopDisposable.instance
        }
    }
}