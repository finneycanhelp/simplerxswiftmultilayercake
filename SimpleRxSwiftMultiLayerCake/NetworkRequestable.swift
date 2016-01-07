
import Foundation
import RxSwift
import Alamofire

protocol NetworkRequestable {
    func doPost(url: String, body: NSData?) -> Observable<NSData?>
}

struct NetworkRequestMaker: NetworkRequestable {
    func doPost(url: String, body: NSData?) -> Observable<NSData?> {
        return Observable.create { observer in
            let request = NSURLRequest(URL: NSURL(string: url)!).mutableCopy() as! NSMutableURLRequest
            request.HTTPBody = body
            request.HTTPMethod = "POST"
            self.makeRequest(request, observer: observer)
            return NopDisposable.instance
        }
    }
    
    private func makeRequest(request: URLRequestConvertible, observer:AnyObserver<NSData?>) {
        Alamofire.request(request).response { (request, response, data, error) in
            if let statusCode = response?.statusCode,
                data = data
                where statusCode >= 200 && statusCode <= 299 {
                    observer.onNext(data)
            } else {
                // FIXME: change to a more useful error
                observer.onError(NSError(domain: "Something", code: 999, userInfo: nil))
                print("We know. Nothing is handling this error case yet")
            }
        }
    }
}