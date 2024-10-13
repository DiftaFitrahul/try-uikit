//
//  EditorViewController.swift
//  TodoListProgrammatic
//
//  Created by MacBook Difta on 13/10/24.
//

import UIKit

protocol EditorViewControllerDelegate: AnyObject {
    func onPopSuccesEditorTodo()
}


class EditorViewController: UIViewController {
    
    weak var delegate: EditorViewControllerDelegate?
    private var todo: Todo?
    
    private var labelTitleTextField: UILabel!
    private var labelDescriptionField: UILabel!
    private var titleField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Input title..."
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 6
        textfield.setLeftPaddingPoints(7)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.returnKeyType = .next
        return textfield
    }()
    
    private let titleErrorLabel: UILabel = {
            let label = UILabel()
            label.text = "Title cannot be empty"
            label.textColor = .red
            label.font = UIFont.systemFont(ofSize: 12)
            label.isHidden = true  // Initially hidden
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let descriptionErrorLabel: UILabel = {
            let label = UILabel()
            label.text = "Description cannot be empty"
            label.textColor = .red
            label.font = UIFont.systemFont(ofSize: 12)
            label.isHidden = true  // Initially hidden
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

    
    private var descriptionField: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.layer.borderColor = UIColor.lightGray.cgColor
        textview.layer.borderWidth = 1
        textview.layer.cornerRadius = 8
        textview.returnKeyType = .done
        return textview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTitleView()
        configureNavigationItem()
        configure()
    }
    
    func setTodo(todo: Todo){
        self.todo = todo
        titleField.text = todo.title
        descriptionField.text = todo.description
    }
    
    
    private func configureTitleView(){
        let titleLabel = UILabel()
            titleLabel.text = "Editor"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
            titleLabel.textAlignment = .center
            titleLabel.sizeToFit()
            
            // Set the titleLabel as the titleView
        navigationItem.titleView = titleLabel
    }
    private let editorType: EditorType
    
    init(editorType: EditorType) {
        self.editorType = editorType
        super.init(nibName: nil, bundle: nil) // Call to super.init for UIViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configure(){
        let padding: CGFloat = 20
        labelTitleTextField = generateLabel(text: "Title")
        labelDescriptionField = generateLabel(text: "Description")
        
        view.addSubview(labelTitleTextField)
        view.addSubview(titleField)
        view.addSubview(titleErrorLabel)
        
        view.addSubview(labelDescriptionField)
        view.addSubview(descriptionField)
        view.addSubview(descriptionErrorLabel)
        
        titleField.delegate = self
        descriptionField.delegate = self
        
        NSLayoutConstraint.activate([
            labelTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            titleField.topAnchor.constraint(equalTo: labelTitleTextField.bottomAnchor, constant: 10),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleField.heightAnchor.constraint(equalToConstant: 40),
            titleErrorLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 5),
            titleErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            
            labelDescriptionField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 35),
            labelDescriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionField.topAnchor.constraint(equalTo: labelDescriptionField.bottomAnchor, constant: 10),
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            descriptionField.heightAnchor.constraint(equalToConstant: 200),
            descriptionErrorLabel.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 5),
            descriptionErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
        ])
        
        
        
        
    }
    
    private func configureNavigationItem(){
        let rigthButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSaveTodo))
        navigationItem.rightBarButtonItem = rigthButton
    }
    
    
    
    
    
    private func generateLabel(text: String) -> UILabel{
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }
    
    @objc func onSaveTodo(){
        if(titleField.text!.isEmpty && descriptionField.text!.isEmpty){
            titleErrorLabel.isHidden = false
            descriptionErrorLabel.isHidden = false
        } else if titleField.text!.isEmpty{
            titleErrorLabel.isHidden = false
        } else if descriptionField.text!.isEmpty{
            descriptionErrorLabel.isHidden = false
        }else{
            networkSaveTodo()
        }
    }
    
    func networkSaveTodo(){
        if(editorType == .postTodo){
            NetworkManager.shared.postTodo(todo: PostTodo(title: titleField.text!, description: descriptionField.text)) { isSuccess in
                if isSuccess{
                    DispatchQueue.main.async {
                        self.delegate?.onPopSuccesEditorTodo()
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
            }
        }else{
            NetworkManager.shared.putTodo(todo: (self.todo?.copy(title: titleField.text, description: descriptionField.text))!) { isSuccess in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.delegate?.onPopSuccesEditorTodo()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension EditorViewController: UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(titleErrorLabel.isHidden == false){
            titleErrorLabel.isHidden = true
        }
        return true
    }
    
}

extension EditorViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if(descriptionErrorLabel.isHidden == false){
            descriptionErrorLabel.isHidden = true
        }
    }
}





/*
 Different textfield delegate when have more than 1
 
 1. USING TAG
 ============
 class ViewController: UIViewController, UITextFieldDelegate {

     let firstTextField: UITextField = {
         let tf = UITextField()
         tf.placeholder = "First Name"
         tf.borderStyle = .roundedRect
         tf.translatesAutoresizingMaskIntoConstraints = false
         return tf
     }()
     
     let secondTextField: UITextField = {
         let tf = UITextField()
         tf.placeholder = "Last Name"
         tf.borderStyle = .roundedRect
         tf.translatesAutoresizingMaskIntoConstraints = false
         return tf
     }()

     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .systemBackground

         // Add text fields to the view
         view.addSubview(firstTextField)
         view.addSubview(secondTextField)
         
         // Set the tags to differentiate them
         firstTextField.tag = 1
         secondTextField.tag = 2
         
         // Set the delegate
         firstTextField.delegate = self
         secondTextField.delegate = self

         // Set constraints (you can use your own layout)
         NSLayoutConstraint.activate([
             firstTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
             firstTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             firstTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
             firstTextField.heightAnchor.constraint(equalToConstant: 40),

             secondTextField.topAnchor.constraint(equalTo: firstTextField.bottomAnchor, constant: 20),
             secondTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             secondTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
             secondTextField.heightAnchor.constraint(equalToConstant: 40)
         ])
     }

     // UITextFieldDelegate method to detect changes
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField.tag == 1 {
             print("First text field's return key pressed.")
         } else if textField.tag == 2 {
             print("Second text field's return key pressed.")
         }
         return true
     }
 }

 
 
2. USING INSTANCE DIRECTLY
 class ViewController: UIViewController, UITextFieldDelegate {

     let firstTextField: UITextField = {
         let tf = UITextField()
         tf.placeholder = "First Name"
         tf.borderStyle = .roundedRect
         tf.translatesAutoresizingMaskIntoConstraints = false
         return tf
     }()
     
     let secondTextField: UITextField = {
         let tf = UITextField()
         tf.placeholder = "Last Name"
         tf.borderStyle = .roundedRect
         tf.translatesAutoresizingMaskIntoConstraints = false
         return tf
     }()

     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .systemBackground

         // Add text fields to the view
         view.addSubview(firstTextField)
         view.addSubview(secondTextField)

         // Set the delegate
         firstTextField.delegate = self
         secondTextField.delegate = self

         // Set constraints
         NSLayoutConstraint.activate([
             firstTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
             firstTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             firstTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
             firstTextField.heightAnchor.constraint(equalToConstant: 40),

             secondTextField.topAnchor.constraint(equalTo: firstTextField.bottomAnchor, constant: 20),
             secondTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             secondTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
             secondTextField.heightAnchor.constraint(equalToConstant: 40)
         ])
     }

     // UITextFieldDelegate method to detect changes
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField == firstTextField {
             print("First text field's return key pressed.")
         } else if textField == secondTextField {
             print("Second text field's return key pressed.")
         }
         return true
     }
 }

 */


//
//#Preview{
//    EditorViewController()
//}
