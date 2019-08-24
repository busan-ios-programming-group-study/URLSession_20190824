
import UIKit

class ViewController: UIViewController {
    
    // https://sncdust.blob.core.windows.net/sncblob/muinbal.json
    
    // 배열생성
    var jsonArr = [String]() //  json 전체를 담는 배열
    var jibunArr = [String]() // jibun만 담을 배열
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getDataFromServer()
        
    }
    
    func getDataFromServer() {
        // urlsession api
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let request = NSMutableURLRequest(url: URL(string: "https://sncdust.blob.core.windows.net/sncblob/muinbal.json")!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                print("data: \(data!)")
                print("response: \(response!)")
                print("error: \(error)")
            if error == nil {
                // JSON Parsing
                
                
                
            } else {
                print("error")
            }
            
        }
        task.resume()
        
    }
    


}

