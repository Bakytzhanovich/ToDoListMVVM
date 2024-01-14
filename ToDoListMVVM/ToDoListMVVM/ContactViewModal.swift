//
//  ContactViewModal.swift
//  ToDoListMVVM
//
//  Created by Нурсат Шохатбек on 14.01.2024.
//

import Foundation
import UIKit

struct State {
    enum EditingStyle{
        case addContact(String)
        case deleteContact(IndexPath)
        case toggleContact(IndexPath)
        case loadContact([Contacts])
        case none
    }
    
    var todolistarray: [Contacts]
    var editingStyle: EditingStyle{
        didSet {
            switch editingStyle {
            case let .addContact(newContactName):
                var newContact = Contacts()
                newContact.name = newContactName
                todolistarray.append(newContact)
                break
            case let.deleteContact(indexPath):
                todolistarray.remove(at: indexPath.row)
                break
            case let.toggleContact(indexPath):
                todolistarray[indexPath.row].isComplete.toggle()
                break
            case let.loadContact( array):
                todolistarray = array
                break
            case .none:
                break
            }
        }
    }
    init(array: [Contacts]){
        todolistarray = array
        editingStyle = .none
    }
    
    func text(at indexPath: IndexPath) -> String {
        return todolistarray[indexPath.row].name
    }
    
    func isCompleted(at indexPath: IndexPath) -> Bool {
        return todolistarray[indexPath.row].isComplete
    }
}

class ContactViewModal {
    var state = State(array: []){
        didSet {
            callback(state)
        }
    }
    let callback: (State) -> ()
    
    init (callback: @escaping (State) -> ()){
        self.callback = callback
    }
    
    func addNewContact(name: String){
        state.editingStyle = .addContact(name)
        saveContacts()
    }
    func deleteTask(at indexPath: IndexPath){
        state.editingStyle = .deleteContact(indexPath)
        saveContacts()
    }
    
    func toggleContact(at indexPath: IndexPath){
        state.editingStyle = .toggleContact(indexPath)
        saveContacts()
    }
    
    func accessoryType(at indexPath: IndexPath) -> UITableViewCell.AccessoryType{
        if state.isCompleted(at: indexPath){
            return .checkmark
        }
        return . none
    }
    
    func saveContacts(){
        let defaults = UserDefaults.standard
        
        
        do {
           
            let encodedata = try JSONEncoder().encode(state.todolistarray)
                
                defaults.set(encodedata, forKey: "contactItemArray")
            }catch {
            print("unable to encode \(error)")
        }

    }
    func loadContact() {
        let defaults = UserDefaults.standard
        
        do {
            if let data = defaults.data(forKey: "contactItemArray"){
                let array = try JSONDecoder().decode([Contacts].self, from: data)
                
                state.editingStyle = .loadContact(array)
            }
            
            
        } catch {
            print("unable to encode \(error)")
        }

    }
}
