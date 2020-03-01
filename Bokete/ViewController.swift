//
//  ViewController.swift
//  Bokete
//
//  Created by 中條航紀 on 2020/03/01.
//  Copyright © 2020 中條航紀. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var odaiImageView: UIImageView!
    
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var count = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.layer.cornerRadius = 20.0
        
        PHPhotoLibrary.requestAuthorization{ (status) in
            switch(status){
                case .authorized: break
                case .denied: break
                case .notDetermined: break
                case .restricted: break
            }
            
        }
        
        getImages(keyword: "funny")
    }
    
    func getImages(keyword:String){
        let url = "https://pixabay.com/api/?key=15440931-eb88dccc743d08cf1f43bd6aa&q=\(keyword)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as Any)
                var imageString = json["hits"][self.count]["webformatURL"].string
                print(self.count)
                if imageString == nil{
                    imageString = json["hits"][0]["webformatURL"].string
                    
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }else{
                    print(self.count)
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func nextOdai(_ sender: Any) {
        count = count + 1
        print(count)
        if searchTextField.text == ""{
            getImages(keyword: "funny")
        }else{
            getImages(keyword: searchTextField.text!)
        }
        
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        self.count = 0
        if searchTextField.text == ""{
            getImages(keyword: "funny")
        }else{
            getImages(keyword: searchTextField.text!)
        }
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shareVC = segue.destination as? ShareViewController
        shareVC?.commentString = commentTextView.text
        shareVC?.resultImage = odaiImageView.image!
        
    }

}

