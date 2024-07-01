//
//  PicsumPhotosDescriptionViewController.swift
//  PicsumPhotos
//
//  Created by Umesh on 01/07/24.
//

import UIKit

class PicsumPhotosDescriptionViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var mainDescriptionView: UIView!
    @IBOutlet weak var picsumImageView: UIImageView!
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    
    var details: [UserInfo] = []
    var id:String = ""
    
    init(){
        super.init(nibName: "PicsumPhotosDescriptionViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
        self.view.backgroundColor = .clear
        self.mainView.backgroundColor = .black.withAlphaComponent(0.6)
        self.mainView.alpha = 0
        self.mainDescriptionView.alpha = 0
        self.mainDescriptionView.layer.cornerRadius = 10
    }

    func showView(sender: UIViewController){
        sender.present(self, animated: true)
        for i in 0..<details.count {
            if id == details[i].id {
                self.mainView.alpha = 1
                self.mainDescriptionView.alpha = 1
                authorName.text = details[i].author
                descriptionLabel.text = details[i].url
                CommonClass.downloadImage(from: details[i].download_url!) { image in
                     DispatchQueue.main.async {
                         self.picsumImageView.image = image
                     }
                 }
            }
        }
    }
    
    func hideView(){
        self.mainView.alpha = 0
        self.mainDescriptionView.alpha = 0
        self.dismiss(animated: false)
        self.removeFromParent()
    }
    
    @IBAction func onOkButtonClicked(_ sender: Any) {
        hideView()
    }
    

}
