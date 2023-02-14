//
//  UploadViewController.swift
//  InstagramCloneFirebase
//
//  Created by Kadir Yılmaz on 8.01.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var upload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = UIImage(named: "selectImage")

    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        self.present(alert, animated: true)
    }
    
    @IBAction func upload(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            imageReference.putData(data, metadata: nil){(metadata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            // Database
                            
                            let firestoreDatabase = Firestore.firestore()
                            let firestoreReference: DocumentReference?
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy": Auth.auth().currentUser!.email!,  "postComment": self.commentTextField.text!, "date": FieldValue.serverTimestamp(), "likes": 0] as [String: Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                }else{
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentTextField.text = ""
                                    self.tabBarController?.selectedIndex = 0 // tabBar eleman index'i -> item1 item2 item3
                                }
                            })
                        }                    }
                }
            }
        }
    }
    
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
}
