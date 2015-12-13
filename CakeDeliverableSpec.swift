
import Foundation
import RxSwift
import Quick
import Nimble

class CakeDeliverableSpec: QuickSpec {
    
    override func spec() {
        describe("cake delivery") {
            var cakeDeliverable = ConcreteCakeDeliverable()
            
            let cakeIdentification = "somecakeid"
            let oldBakeryServiceSpy = OldBakeryServiceSpy()
            cakeDeliverable.oldBakeryService = oldBakeryServiceSpy
            let disposeBag = DisposeBag()
            
            context("when fetching a cake with a valid id") {
                
                oldBakeryServiceSpy.responseClosure = { observer in
                    observer.onNext(Cake(cakeIdentification:"", html:"Some HTML"))
                }
                
                var cakeString: String = ""
                
                let cakeDeliveryObserver = AnyObserver<Cake>(eventHandler: { event in
                    if let cake = event.element {
                        cakeString = cake.html
                    }
                })
                
                cakeDeliverable.fetchCake(cakeIdentification).subscribe(cakeDeliveryObserver).addDisposableTo(disposeBag)
                
                it("should return the cake") {
                    expect(cakeString).to(equal("Some HTML"))
                }
            }
            
            context("when fetching a cake in an error situation") {
                
                oldBakeryServiceSpy.responseClosure = { observer in
                    observer.onError(OldBakeryError(message:"something", code: "999"))
                }
                
                var eventCaptured: Event<Cake>?
                let cakeDeliveryObserver = AnyObserver<Cake>(eventHandler: { event in
                    eventCaptured = event
                })
                
                cakeDeliverable.fetchCake(cakeIdentification).subscribe(cakeDeliveryObserver).addDisposableTo(disposeBag)
                
                it("should return an error") {
                    expect((eventCaptured?.error as? OldBakeryError)?.message).to(equal("something"))
                }
            }
        }
    }
    
    struct ConcreteCakeDeliverable: CakeDeliverable {
        var disposeBag = DisposeBag()
        var oldBakeryService: OldBakeryService = OldBakeryServiceSpy()
        
    }
}