
import RxSwift
import Quick
import Nimble

final class CakeEntryViewModelSpec: QuickSpec {
    
    private var cakeEntryViewModel = CakeEntryViewModel()
    var disposeBag = DisposeBag()
    let error = NSError(domain: "whoops", code: 999, userInfo: nil)
    let html = "some html"
    var htmlResponseClosure: (AnyObserver<Cake> -> Void)?
    var errorResponseClosure: (AnyObserver<Cake> -> Void)?
    private var stubCakeApi = StubCakeApi()
    
    override func spec() {
        
        beforeEach {
            self.htmlResponseClosure = { observer -> Void in
                observer.onNext(Cake(cakeIdentification:"", html: self.html))
            }
            
            self.errorResponseClosure = { observer -> Void in
                observer.onError(self.error)
            }
            
            self.stubCakeApi = StubCakeApi()
            self.cakeEntryViewModel.cakeAPI = self.stubCakeApi
        }
        
        describe("a cake identification entry") {
            
            context("when submitting a request for Cake is successful") {
                it("should handle displaying a cake") {
                    var cakeHtml = ""
                    self.stubCakeApi.responseClosure = self.htmlResponseClosure
                    
                    self.cakeEntryViewModel.grabCake().subscribe(onNext: { cake in
                        cakeHtml = cake.html
                    }).addDisposableTo(self.disposeBag)
                    
                    expect(cakeHtml).to(equal(self.html))
                }
                
                it("should handle any errors that get created") {
                    
                    var errorWasHandled = false
                    self.stubCakeApi.responseClosure = self.errorResponseClosure
                    
                    self.cakeEntryViewModel.grabCake().subscribe(onError: { error -> Void in
                        errorWasHandled = true
                    }).addDisposableTo(self.disposeBag)
                    
                    expect(errorWasHandled).to(beTrue())
                }
            }
        }
    }
    
    private class StubCakeApi: CakeDeliverable {
        var disposeBag = DisposeBag()
        var oldBakery = OldBakeryService()
        var responseClosure: (AnyObserver<Cake> -> Void)?
        
        func fetchCake(cakeIdentification: String) -> Observable<Cake> {
            return create { observer in
                if let responseClosure = self.responseClosure {
                    responseClosure(observer)
                }
                return NopDisposable.instance
            }
        }
    }
}