
import UIKit

private var products : [AllProductsViewModel.pModel] = []

private var viewModel = AllProductsViewModel()

class AllProductsViewController: UIViewController, UISearchBarDelegate , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createkb()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        products = viewModel.getDetails()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.text = ""
        products = viewModel.getDetails()
        self.tableView.reloadData()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == ""){
            products = viewModel.getDetails()
            tableView.reloadData()
        }
        
        else{
            products = viewModel.searchSubstr(searchText : searchText)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductItem", for: indexPath)
        
        let img = cell.viewWithTag(10) as! UIImageView
        img.image = products[indexPath.row].pImage
        
        let title = cell.viewWithTag(20) as! UILabel
        title.text = products[indexPath.row].pName
        
        let exp = cell.viewWithTag(30) as! UILabel
        var entries = products[indexPath.row].entry
        var q = 0
        for e in entries{
            q = q+Int(e.quantity)
        }
        exp.text = "Total Quantity: " + String(q)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completionHandler) in
            let productToRemove = products[indexPath.row]
            
            viewModel.deleteProduct(name: productToRemove.pName)
            
            products = viewModel.getDetails()
            
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail1Segue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "detail1Segue", sender: self)
    }
    */
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detail1Segue", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detail1Segue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedRowIndex = self.tableView.indexPathForSelectedRow else {return}
        
        let destination = segue.destination as? DetailViewController
        
        let selectedProduct = viewModel.searchSubstr(searchText: products[selectedRowIndex.row].pName)[0]
        
        destination?.selectedRow = selectedProduct
    }

    func createkb(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([done], animated: true)
        
        searchBar.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        searchBar.endEditing(true)
    }
}
