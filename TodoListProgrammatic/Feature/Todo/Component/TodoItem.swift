//
//  TodoItem.swift
//  TodoListProgrammatic
//
//  Created by MacBook Difta on 13/10/24.
//

import UIKit

protocol TodoItemDelegate: AnyObject{
    func deleteTodo(_ todo: Todo)
    func tapTodo(_ todo: Todo)
}


class TodoItem: UIView {
    
    weak var delegate: TodoItemDelegate?
    var todo: Todo!
    
    private var titleTodo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private var descriptionTodo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private var deleteIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(todo: Todo){
        self.todo = todo
        titleTodo.text = todo.title
        descriptionTodo.text = todo.description
    }
    
    private func configure(){
        addSubview(titleTodo)
        addSubview(descriptionTodo)
        addSubview(deleteIcon)
        
        deleteIcon.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapTodoItem))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            titleTodo.topAnchor.constraint(equalTo: topAnchor),
            titleTodo.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleTodo.trailingAnchor.constraint(equalTo: deleteIcon.leadingAnchor),
            titleTodo.heightAnchor.constraint(equalToConstant: 30),
            
            
            descriptionTodo.topAnchor.constraint(equalTo: titleTodo.bottomAnchor),
            descriptionTodo.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionTodo.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            deleteIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            deleteIcon.widthAnchor.constraint(equalToConstant: 70)
            
        ])
    }
    
    @objc func  onDelete(){
        delegate?.deleteTodo(todo)
    }
    @objc func onTapTodoItem(){
        delegate?.tapTodo(todo)
    }
    
}
