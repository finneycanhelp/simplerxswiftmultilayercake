import Foundation
import RxSwift
import Alamofire
import SWXMLHash

class OldBakeryService {
    
    var networkRequestable:NetworkRequestable = NetworkRequestMaker()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    func makeRequest(cakeIdentification: String) -> Observable<Cake> {
        return create { observer in
            
            // someURLWhichGoesHere because it's just an example.
            self.networkRequestable.doPost("https://someURLWhichGoesHere", body: self.createRequestBody(cakeIdentification))
                .subscribeNext({ data in
                    self.handleResponse(data, observer: observer)
                }).addDisposableTo(self.disposeBag)
            
            return NopDisposable.instance
        }
    }
    
    private func createRequestBody(cakeIdentification: String) -> NSData? {
        
        let requestXml: String = "<cake-request><cake-id>\(cakeIdentification)</cake-id></cake-request>"
        return requestXml.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    private func handleResponse(data: NSData?, observer: AnyObserver<Cake>) {
        
        guard let data = data, xmlString = String(data: data, encoding: NSUTF8StringEncoding) else {
            observer.onError(unknownError())
            return
        }
        
        // some-error-elements is not something to do, of course
        let errorsElement = SWXMLHash.parse(xmlString)["cake-response"]["some-error-elements"]["errors"].element
        
        let bakeryErrorCode = errorsElement?.attributes["error-code"]
        
        if let text = errorsElement?.text {
            observer.onError(OldBakeryError(message: text, code: bakeryErrorCode))
        } else if let myElement = SWXMLHash.parse(xmlString)["cake-response"]["cake-info"]["cake-html"].element, let myText = myElement.text {
            observer.onNext(Cake(cakeIdentification: "", html:myText))
        } else {
            observer.onError(unknownError())
        }
    }
    
    private func unknownError() -> OldBakeryError {
        return OldBakeryError(message: "An unknown error has occurred. Please try again later.", code: nil)
    }
}
