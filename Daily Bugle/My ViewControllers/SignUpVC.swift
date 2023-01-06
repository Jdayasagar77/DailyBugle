//
//  SignUpVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 03/12/22.
//

import UIKit

class SignUpVC: UIViewController {
    let databaseInstance = DBManager.sharedInstance
    let dataArray = [["ProfilePic", "Name", "Email Id", "Mobile Number", "Password", "Confirm Password"], ["Address", "State", "Pincode", "Submit"]]
    let myIndexPath = [[0,1,2,3,4,5],[6,7,8,9]]
    var myImage: UIImage?
    var user : UserModel = UserModel()
   
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
  
    @IBOutlet weak var signUpTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        signUpTableView.register(UINib(nibName: "ProfilePicCell", bundle: nil), forCellReuseIdentifier: "ProfilePicCell") 
        signUpTableView.register(UINib(nibName: "SubmitButtonCell", bundle: nil), forCellReuseIdentifier: "SubmitButtonCell")
        signUpTableView.register(UINib(nibName: "InputCell", bundle: nil), forCellReuseIdentifier: "InputCell")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillShowNotification, object: nil);
        signUpTableView.dataSource = self
        signUpTableView.estimatedRowHeight = 300
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow() {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide() {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    /// Image Picker open
    func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
 
}



extension SignUpVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePicCell") as? ProfilePicCell
            cell?.handler = {
                self.selectImage()
            }
            cell?.updateUI(image: myImage)
            return cell ?? UITableViewCell()
        }
        
       else if indexPath.section == 1, indexPath.row == dataArray[indexPath.section].count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitButtonCell") as? SubmitButtonCell
            cell?.actionHandler = {
                if ((self.user.name?.isEmpty)
                    == nil) {
                    self.showMessage(title: "Please Enter a Valid Name")
                    debugPrint("User Submitted and Didn't Entered Name")
                }
                else if ((self.user.email?.isEmpty)
                         == nil){
                    self.showMessage(title: "Please Enter a Valid Mail")
                    debugPrint("User Submitted and Didn't Entered Email")
                }
                else if ((self.user.mobile?.isEmpty)
                         == nil){
                    self.showMessage(title: "Please Enter a Valid Phone Number")
                    debugPrint("User Submitted and Didn't Entered Phone Number")
                }
                else if ((self.user.state?.isEmpty)
                         == nil){
                    self.showMessage(title: "Please Enter a Valid State")
                    debugPrint("User Submitted and Didn't Entered State")
                }
//                else if ((self.user.pincode?.isEmpty)
//                         == nil){
//                    self.showMessage(title: "Please Enter a Valid Pincode")
//                    debugPrint("User Submitted and Didn't Entered Pincode")
//                }
                else if ((self.user.address?.isEmpty)
                         == nil){
                    self.showMessage(title: "Please Enter a Valid Address")
                    debugPrint("User Submitted and Didn't Entered Address")
                }
                else if self.user.password?.utf8CString.count ?? 0 <= 5 {
                    self.showMessage(title: "Password Must be more than 5 characters")
                    debugPrint("User Submitted and Entered Less Number of Characters in Password")
                }
                else if self.user.confirmPassword != self.user.password {
                    self.showMessage(title: "Passwords Do Not Match")
                    debugPrint("User Submitted and Entered Wrong Password")
                }
                else {
                    self.dismiss(animated: true)
                    if let _ = DBManager.sharedInstance.getUserDetail(email: self.user.email ?? ""){
                        self.showMessage(title: "Email Id Exist")
                        return
                    }
                    else{
                        
                        self.databaseInstance.insert(user: self.user)
                        debugPrint("Inserted \(self.user.email as Any) in Database")
                    }
                }
            }
            cell?.SubmitButtonCell.setTitle("Submit", for: .normal)
         return cell ?? UITableViewCell()
            
        }
       
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as? InputCell
            cell?.inputText.placeholder =  dataArray[indexPath.section][indexPath.row]
            cell?.inputText.tag = myIndexPath[indexPath.section][indexPath.row]
            cell?.inputText.delegate = self
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          return UITableView.automaticDimension

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
}
extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
          if let theImage = info[UIImagePickerController.InfoKey.editedImage]
                as? UIImage {
              myImage = theImage
              user.image = theImage
          }
        self.signUpTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker:
                                        UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



extension SignUpVC: UITextFieldDelegate {
 
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
               case TextFieldData.nameTextField.rawValue:
            self.user.name = textField.text
          
               case TextFieldData.emailTextField.rawValue:
            if textField.text?.isValidEmail() == true {
                self.user.email = textField.text
            } else {
                showMessage(title: "Enter a Valid Mail")
                debugPrint("User Entered Invalid Mail")
            }
               case TextFieldData.phoneTextField.rawValue:
            self.user.mobile = textField.text
                   
               case TextFieldData.passwordTextField.rawValue:
            textField.isSecureTextEntry = true
            if textField.text?.utf8CString.count ?? 0 >= 5 {
                self.user.password = textField.text
            } else{
                showMessage(title: "Password Must be more than 5 characters")
                debugPrint("User Entered Less Number of Characters in Password")
            }
               case TextFieldData.repeatPasswordTextField.rawValue:
            textField.isSecureTextEntry = true
            if textField.text == user.password {
                self.user.confirmPassword = textField.text
            }
            else {
                showMessage(title: "Passwords Do Not Match")
                debugPrint("User Entered Wrong Password")
            }
                        
        case TextFieldData.address.rawValue:
     self.user.address = textField.text
            
        case TextFieldData.state.rawValue:
     self.user.state = textField.text
            
            
        case TextFieldData.pincode.rawValue:
     self.user.pincode = textField.text
            
               default:
                   break
               }
        
        
//        let tag = textField.tag
//
//        if tag == 1 {
//            self.user.name = textField.text
//        } else if tag == 2 {
//            self.user.email = textField.text
//        } else if tag == 3 {
//            self.user.mobile = textField.text
//        } else if tag == 4 {
//            self.user.password = textField.text
//        } else if tag == 5 {
//            self.user.confirmPassword = textField.text
//        } else if tag == 1000 {
//            self.user.address = textField.text
//        } else if tag == 1001 {
//            self.user.state = textField.text
//        } else if tag == 1002 {
//            self.user.pincode = textField.text
//        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true

    }
}


enum TextFieldData: Int {
    
    case nameTextField = 1
    case emailTextField = 2
    case phoneTextField = 3
    case passwordTextField = 4
    case repeatPasswordTextField = 5
    case address = 6
    case state = 7
    case pincode = 8
}
