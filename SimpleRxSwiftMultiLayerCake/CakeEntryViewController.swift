
import UIKit
import RxSwift
import RxCocoa

class CakeEntryViewController: UIViewController {

    @IBOutlet weak var cakeIdentificationField: UITextField!
    @IBOutlet weak var getSomeCakeButton: UIButton!
    
    let cakeEntryViewModel = CakeEntryViewModel()
    var cakeHtml = ""

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {

        super.viewDidLoad()

        getSomeCakeButton.rx_tap.subscribe(onNext: {

            self.cakeEntryViewModel.grabCake()
                .subscribe(onNext: self.displayCake, onError: self.displayError)
                .addDisposableTo(self.disposeBag)
            
            }, onError:(displayError))
            .addDisposableTo(disposeBag)
    }

    func displayCake(cake: Cake) {
        self.cakeHtml = cake.html
        
        print("do something with this cake.")
    }
    
    func displayError(error: ErrorType) {
        if let error = error as? CakeError {
            let alertController = UIAlertController(title: "Error", message: error.message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
