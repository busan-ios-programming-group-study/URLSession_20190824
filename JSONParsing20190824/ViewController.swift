
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    // https://sncdust.blob.core.windows.net/sncblob/muinbal.json
    
    // 배열생성
    var jsonArr = [MyData]() //  json 전체를 담는 배열
    var jibunArr = [String]() // jibun만 담을 배열
    var filteredArr = [String]()
    @IBOutlet weak var myTableView: UITableView!
    var searchCon : UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        getDataFromServer()
        
    }
    
    //NSPredicate(format: <#T##String#>, <#T##args: CVarArg...##CVarArg#>)
    //NSPredicate : 페치 (fetch) 또는 인 메모리 필터링 (in-memory filtering)을 위해 검색을 제한하는 데 사용되는 논리적 조건의 정의.
    //"SELF CONTAINS[c] %@" -> 'SELF':배열의 각 요소 /'CONTAINS':포함하다 /'[c]':대소문자 구분없이 /'%@':string을저장
    //-> 'searchCon.searchBar.text!'를 "SELF CONTAINS[c] %@" 인 포맷으로 필터링하겠다는 의미 //https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/////pSyntax.html#//apple_ref/doc/uid/TP40001795 참고
    
    func updateSearchResults(for searchController: UISearchController) {
        let predicate = NSPredicate(format: "SELF CONTAINS %@", searchCon.searchBar.text!)
        
        let arr = (jibunArr as NSArray).filtered(using: predicate)
        
        
        self.filteredArr = arr as? [String] ?? []
        
        self.myTableView.reloadData()
        
    }
    

    
    
    func getDataFromServer() {
        self.searchCon = UISearchController(searchResultsController: nil)
        self.searchCon.searchResultsUpdater = self
        self.searchCon.searchBar.sizeToFit()
        self.myTableView.tableHeaderView = searchCon.searchBar
        
        
        
        // urlsession api
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let request = NSMutableURLRequest(url: URL(string: "https://sncdust.blob.core.windows.net/sncblob/muinbal.json")!)
        request.httpMethod = "GET"
        
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                print("data: \(data!)")
                print("response: \(response!)")
                //print("error: \(error)")
            if error == nil {
                // JSON Parsing
                self.jsonArr = try! JSONDecoder().decode([MyData].self, from: data!)
                
                for i in 0...self.jsonArr.count-1 {
                    self.jibunArr.append(self.jsonArr[i].addrJibun)
                }
                
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
                
            } else {
                print("error")
            }
            print(self.jibunArr)
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCon.isActive ? filteredArr.count : jibunArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchCon.isActive ? filteredArr[indexPath.row] : jibunArr[indexPath.row]
        return cell
    }
    
    
    


}

