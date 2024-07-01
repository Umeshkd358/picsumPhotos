//
//  PicsumPhotosMainViewController.swift
//  PicsumPhotos
//
//  Created by Umesh  on 30/06/24.
//

import UIKit

class PicsumPhotosMainViewController: UIViewController {

    @IBOutlet weak var picsumMainLoadingView: UIActivityIndicatorView!
    @IBOutlet weak var picsumPhotosStackView: UIStackView!
    @IBOutlet weak var picsumPhotosTableView: UITableView!
    @IBOutlet weak var picsumPhotosLoading: UIActivityIndicatorView!
    
    var userData: [UserInfo] = []
    var selectedUserData : [UserInfo] = []
    var isCheckboxSelected: Bool = false
    
    var currentPage = 1
    let pageSize = 10
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picsumPhotosTableView.dataSource = self
        picsumPhotosTableView.delegate = self
        self.title = "Picsum Photos"
        let nib = UINib(nibName: "PicsumPhotosTableViewCell", bundle: nil)
        picsumPhotosTableView.register(nib, forCellReuseIdentifier: "picsumPhotoscell")
        picsumMainLoadingView.isHidden = false
        picsumMainLoadingView.startAnimating()
        fetchData()
    }

    
    func fetchData() {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(currentPage)&limit=\(pageSize)") else {
                print("Invalid URL")
                return
            }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Handle errors if any
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let userData = try JSONDecoder().decode([UserInfo].self, from: data)
                    self.userData.append(contentsOf: userData)
                    DispatchQueue.main.async {
                        self.picsumMainLoadingView.stopAnimating()
                        self.picsumMainLoadingView.hidesWhenStopped = true
                        print("Received JSON data: \(String(describing: self.userData))")
                        self.picsumPhotosTableView.reloadData()
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        task.resume()
    }
    
    
    func preparePicsumDescriptionView(_indexString: String){
        let descriptionViewController = PicsumPhotosDescriptionViewController()
        descriptionViewController.details = userData
        descriptionViewController.id = _indexString
        descriptionViewController.showView(sender: self)
    }
    
    func prepareAlertView() {
        let alert = UIAlertController(title: "Alert", message: "Please select the checkbox", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true)
           
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkUncheckButtonClicked(_sender:UIButton) {
        _sender.isSelected = !_sender.isSelected
       
        // For checking the checkbox is selected or not
        if _sender.isSelected{
            isCheckboxSelected = true
        }else{
            isCheckboxSelected = false
        }
        
        let selectedData = userData[_sender.tag]
        var isExist = false
        for i in 0..<selectedUserData.count {
            let selectedId = selectedUserData[i]
            if selectedId.id == selectedData.id{
                isExist = true
                selectedUserData.remove(at: i)
                return
            }
        }
        if !isExist {
            selectedUserData.append(selectedData)
        }
    }
    
    func isCheckBoxChecked(_indexString: String) -> Bool {
        let selectedBox = selectedUserData.first{$0.id == _indexString}
        if selectedBox != nil {
            return true
        }else {
            return false
        }
    }
        
    func loadMoreData(){
        guard !isLoading else { return }
        isLoading = true
        self.picsumPhotosLoading.startAnimating()
       
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentPage += 1
            self.fetchData()
            self.picsumPhotosLoading.stopAnimating()
            self.picsumPhotosLoading.hidesWhenStopped = true
            self.isLoading = false
        }
    }

}

// Extension for TableView de
extension PicsumPhotosMainViewController: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    // setting json data into table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = picsumPhotosTableView.dequeueReusableCell(withIdentifier: "picsumPhotoscell") as! PicsumPhotosTableViewCell
        let userDetails = userData[indexPath.row]
        cell.name.text = userDetails.author
        cell.descriptions.text = userDetails.url
        cell.checkUncheckBox.tag = indexPath.row
        cell.checkUncheckBox.addTarget(self, action: #selector(checkUncheckButtonClicked(_sender: )) , for: .touchUpInside)
        
        cell.checkUncheckBox.isSelected = isCheckBoxChecked(_indexString: userDetails.id!)

        CommonClass.downloadImage(from: userDetails.download_url!) { image in
             DispatchQueue.main.async {
                 cell.picsumImage.image = image
                 cell.picsumImage.layer.cornerRadius = 4
             }
         }
         return cell
    }
    
    // Table view action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetails = userData[indexPath.row]
         isCheckboxSelected = isCheckBoxChecked(_indexString: userDetails.id!)
        if isCheckboxSelected{
            preparePicsumDescriptionView(_indexString: userDetails.id!)
        }else{
            prepareAlertView()
        }
        picsumPhotosTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //after scroll calling api to fetch more data
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (picsumPhotosTableView.contentSize.height-100-scrollView.frame.size.height) {
            loadMoreData()
        }
    }
}
