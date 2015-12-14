
import Foundation
import RxSwift
import SWXMLHash

class NetworkRequestSpy: NetworkRequestable {
    var url: String?
    var body: NSData?
    var responseClosure: ((AnyObserver<NSData?>) -> Void)?
    
    func doPost(url: String, body: NSData?) -> Observable<NSData?> {
        self.url = url
        self.body = body
        
        return create { observer in
            if let responseClosure = self.responseClosure {
                responseClosure(observer)
            }
            return NopDisposable.instance
        }
    }
}

class OldBakeryServiceSpy: OldBakeryService {
    
    var responseClosure: (() -> Observable<Cake>)?
    
    override func makeRequest(cakeIdentification: String) -> Observable<Cake> {
        
        guard let myClosure = responseClosure else {
            return just(Cake(cakeIdentification: "", html: ""))
        }
        
        return myClosure()
    }
}

func xml(requestData: NSData?) -> XMLIndexer {
    let xmlString = String(data: requestData!, encoding: NSUTF8StringEncoding)!
    return SWXMLHash.parse(xmlString)
}

func oldBakeryServiceCakeResponse(html: String) -> String {
    return "<?xml version=\"1.0\" encoding=\"UTF-8\"?><cake-response><cake-info><cake-html><![CDATA[\(html)]]></cake-html></cake-info></cake-response>"
}

func oldBakeryServiceCakeErrorResponse(code: String, message: String) -> String {
    return "<?xml version=\"1.0\" encoding=\"UTF-8\"?><cake-response><some-error-elements><errors code=\"\(code)\">\(message)</errors></some-error-elements></cake-response>"
}
