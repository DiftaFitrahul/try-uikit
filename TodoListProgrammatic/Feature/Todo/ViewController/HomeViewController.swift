//
//  HomeViewController.swift
//  TodoListProgrammatic
//
//  Created by MacBook Difta on 13/10/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var listTodo: [Todo] = []
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    
    private var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUINavigationItem()
        getTodo()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Home"
        
        
    }
    private func configureUINavigationItem(){
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(onPlusTap))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func onPlusTap(){
        let editorView = EditorViewController(editorType: EditorType.postTodo)
        editorView.delegate = self
        navigationController?.pushViewController(editorView, animated: true)
    }
 
    
    
    
    
    private func getTodo() {
        NetworkManager.shared.getTodo { [weak self] result in
            switch result {
            case .success(let todos):
                DispatchQueue.main.async {
                    self?.configureTodo(todos: todos)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func successDeleteTodo(id: String){
        listTodo.removeAll { todo in
          return  todo.id == id
        }
        updateView()
    }
    
    
    private func configureTodo(todos: [Todo]) {
        listTodo = todos
        updateView()
        
    }

    private func updateView() {
        for subview in vStack.arrangedSubviews {
            vStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        view.addSubview(vStack)
        vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        view.addSubview(scrollView)
        scrollView.addSubview(vStack)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        
        for todo in listTodo{
            createTodoItem(todo: todo)
        }
        scrollView.contentSize.height = (70 * CGFloat(listTodo.count)) + view.safeAreaInsets.bottom + 100
    }

    
    
    
    
    private func createTodoItem(todo: Todo){
        let todoItem = TodoItem()
        todoItem.translatesAutoresizingMaskIntoConstraints = false
        todoItem.set(todo: todo)
        todoItem.delegate = self
        vStack.addArrangedSubview(todoItem)
        NSLayoutConstraint.activate([
            todoItem.widthAnchor.constraint(equalTo: view.widthAnchor),
            todoItem.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        
    }
    


}

extension HomeViewController: EditorViewControllerDelegate{
    func onPopSuccesEditorTodo() {
        getTodo()
    }
    
    
}

extension HomeViewController: TodoItemDelegate{
    func tapTodo(_ todo: Todo) {
        let editorView = EditorViewController(editorType: .updateTodo)
        editorView.delegate = self
        editorView.setTodo(todo: todo)
        navigationController?.pushViewController(editorView, animated: true)

    }
    
    func deleteTodo(_ todo: Todo) {
        NetworkManager.shared.deleteTodo(id: todo.id) { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    self.successDeleteTodo(id: todo.id)
                }
            }
        }
    }
    
    
}

