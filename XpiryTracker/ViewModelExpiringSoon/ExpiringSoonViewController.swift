
import UIKit

private var products : [AllProductsViewModel.pModel] = []

private var viewModel = ExpiringSoonViewModel()

class ExpiringSoonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var btnTod: UIButton!
    
    @IBOutlet weak var btnTom: UIButton!
    
    @IBOutlet weak var btn2Day: UIButton!
    
    @IBOutlet weak var btnOth: UIButton!
    
    private var str : String =  "Expiring today : "
    
    @IBAction func onToday(_ sender: Any) {
        btnTod.backgroundColor = UIColor.darkGray
        btnTom.backgroundColor = UIColor.lightGray
        btn2Day.backgroundColor = UIColor.lightGray
        btnOth.backgroundColor = UIColor.lightGray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = Date()
        let s = dateFormatter.string(from: today)
        let t = dateFormatter.date(from: s)
        
        products = viewModel.searchDate(onDate: t! as NSDate)
        str = "Expiring today : "
        self.tableView.reloadData()
    }
    
    @IBAction func onTomorrow(_ sender: Any) {
        btnTod.backgroundColor = UIColor.lightGray
        btnTom.backgroundColor = UIColor.darkGray
        btn2Day.backgroundColor = UIColor.lightGray
        btnOth.backgroundColor = UIColor.lightGray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = Date()
        let dt = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let s = dateFormatter.string(from: dt)
        let t = dateFormatter.date(from: s)
        
        products = viewModel.searchDate(onDate: t! as NSDate)
        str = "Expiring tomorrow : "
        self.tableView.reloadData()
    }
    
    @IBAction func on2Days(_ sender: Any) {
        btnTod.backgroundColor = UIColor.lightGray
        btnTom.backgroundColor = UIColor.lightGray
        btn2Day.backgroundColor = UIColor.darkGray
        btnOth.backgroundColor = UIColor.lightGray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = Date()
        let dt = Calendar.current.date(byAdding: .day, value: 2, to: today)!
        let s = dateFormatter.string(from: dt)
        let t = dateFormatter.date(from: s)
        
        products = viewModel.searchDate(onDate: t! as NSDate)
        str = "Expiring after 2 days : "
        self.tableView.reloadData()
    }
    
    @IBAction func onOthers(_ sender: Any) {
        btnTod.backgroundColor = UIColor.lightGray
        btnTom.backgroundColor = UIColor.lightGray
        btn2Day.backgroundColor = UIColor.lightGray
        btnOth.backgroundColor = UIColor.darkGray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = Date()
        let dt = Calendar.current.date(byAdding: .day, value: 2, to: today)!
        let s = dateFormatter.string(from: dt)
        let t = dateFormatter.date(from: s)
        
        products = viewModel.searchDateAfter(onDate: t! as NSDate)
        str = "Expiring next: "
        self.tableView.reloadData()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        btnTod.backgroundColor = UIColor.darkGray
        btnTom.backgroundColor = UIColor.lightGray
        btn2Day.backgroundColor = UIColor.lightGray
        btnOth.backgroundColor = UIColor.lightGray
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = Date()
        let s = dateFormatter.string(from: today)
        let t = dateFormatter.date(from: s)
        
        products = viewModel.searchDate(onDate: t! as NSDate)
        
        self.tableView.reloadData()
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductItem", for: indexPath)
        
        let img = cell.viewWithTag(10) as! UIImageView
        img.image = products[indexPath.row].pImage
        
        let title = cell.viewWithTag(20) as! UILabel
        title.text = products[indexPath.row].pName
        
        let exp = cell.viewWithTag(30) as! UILabel
        var entries = products[indexPath.row].entry
        exp.text = str + String(entries[0].quantity)
        //exp.text = String(entries.count)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completionHandler) in
            let productToRemove = products[indexPath.row]
            
            viewModel.deleteProduct(name: productToRemove.pName)
            
            products.remove(at:indexPath.row)
            
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detail2Segue", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detail2Segue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedRowIndex = self.tableView.indexPathForSelectedRow else {return}
        
        let destination = segue.destination as? DetailViewController
        
        let selectedProduct = viewModel.searchSubstr(searchText: products[selectedRowIndex.row].pName)[0]
        
        destination?.selectedRow = selectedProduct
    }
    
}

