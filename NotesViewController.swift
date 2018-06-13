//
//  NotesViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 11/10/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Foundation

class NotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var notesHeader: UILabel!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    
    //
    // Reference to databaes
    //
    
    var ref:DatabaseReference!
    var uid:String = ""

    var editIndex = 0
    var currentlyEditing = false
    
    //
    // Table view outlet
    //
    @IBOutlet weak var tableView: UITableView!
    
    //
    // list of notes
    //
    
    var notelist = [newNote]()
    
    var noteTF: UITextField?

    //
    // Table view functions
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notelist.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let noteNum = indexPath.row + 1
        createSimpleAlert(title: "Note #" + noteNum.description, message: notelist[indexPath.row].getNote())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notecell", for: indexPath) as! NotesTableViewCell
        
        let isIndexValid = self.notelist.indices.contains(indexPath.row)
        
        if (isIndexValid) {
            cell.dateLabel.text = notelist[indexPath.row].getDate()
            let tempNote = notelist[indexPath.row].getNote()
            if tempNote.count < 70 {
                 cell.noteLabel.text = String(tempNote).capitalizeFirstLetter()
                
            } else {
                 cell.noteLabel.text = String(tempNote.prefix(75)).capitalizeFirstLetter() + "..."
            }
            return cell
        } else {
            
            cell.dateLabel.text = "nil"
            cell.noteLabel.text = "nil"
            
            return cell
        }

    }
    
    //
    // Deleting notes removes entry from database and updates noteslist
    //
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.currentlyEditing = true
            self.editIndex = editActionsForRowAt.row

            //
            // Create alert to edit that note
            //
            
            let alert = UIAlertController(title: "Edit Note #" + (editActionsForRowAt.row+1).description, message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: self.noteTFSetup)
            
            let ok = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                guard var note = self.noteTF?.text! else {
                    self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                    return
                }
                
                //
                // Checks for arbitrary amount of spaces
                //
                
                let tempNote = note.trimmingCharacters(in: .whitespaces)
                
                if tempNote != "" {
                    let tempID = self.notelist[editActionsForRowAt.row].getID()
                    let tempDate = self.notelist[editActionsForRowAt.row].getDate()
                    
                    note = note.capitalizeFirstLetter()
                    
                    let noteInfo = [
                        "date":     tempDate,
                        "note":     note,
                        "id":       tempID
                        ] as [String : Any]
                    
                    self.ref.child("notes").child(tempID).setValue(noteInfo)
                    
                    self.getNotes()
                    
                } else {
                    self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                }
                
                self.createSimpleAlert(title: "Success!", message: "Note has been successfully updated.")
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            
            //
            // Delete note and refresh with confirmation alert
            //
            
            let alert = UIAlertController(title: "Confirm Deletion", message: "Really delete Note #" + (editActionsForRowAt.row+1).description + "?", preferredStyle: .alert)
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 30)
            
            alert.setValue(vc, forKey: "contentViewController")
            
            let ok = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction) -> Void in
                
                let id = self.notelist[editActionsForRowAt.row].getID()
                
                self.ref.child("notes").child(id).removeValue()
                
                self.getNotes()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        edit.backgroundColor = .orange
        delete.backgroundColor = .red
        
        return [edit,delete]
        
    }

    
    //
    // Alert functions and textfield setup functions
    //
    
    func noteTFSetup(textfield: UITextField!) {
        noteTF = textfield
        noteTF?.autocorrectionType = .yes
        
        if currentlyEditing {
            noteTF?.text! = notelist[editIndex].getNote()
        } else {
            noteTF?.placeholder = "Note"
        }
        
    }
    
    func createSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlertAddNote(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: noteTFSetup)
        
        let ok = UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in print("OK")
            
            guard var note = self.noteTF?.text! else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
                return
            }
            
            //
            // Checks for arbitrary amount of spaces
            //
            
            let tempNote = note.trimmingCharacters(in: .whitespaces)
            
            let date = Date()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "MM-dd-yyyy"
            
            let resultDate = formatter.string(from: date)
            
            if tempNote != "" {
                
                let idRef = self.ref.child("notes").childByAutoId()
                let id = idRef.key
                
                note = note.capitalizeFirstLetter()
                
                let noteInfo = [
                    "note":         note,
                    "date":         resultDate,
                    "id":           id
                    ] as [String : Any]
                
                self.ref.child("notes").child(id).setValue(noteInfo)
                
                self.getNotes()
                
            } else {
                self.createSimpleAlert(title: "Check input", message: "At least one field was input incorrectly, check again")
            }
  
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //
    // Gets note data from database and stores in noteslist, refreshes tableview
    //
    
    func getNotes() {
        
        self.notelist.removeAll()
        
        ref.child("notes").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let note = newNote()
                
                
                
                note.setNote(NOTE: dictionary["note"] as! String)
                note.setDate(DATE: dictionary["date"] as! String)
                note.setID(ID: dictionary["id"] as! String)
                
                
                var beenAdded = false
                
                for n in self.notelist {
                    if n.getID() == note.getID() {
                        beenAdded = true
                    }
                }
                
                if (!beenAdded) {
                    self.notelist.append(note)
                }
                
                //
                // Refresh Tableview
                //
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
        
        //
        // Refresh Tableview
        //
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    } //end getNotes

    func initView() {
        newNoteButton.layer.cornerRadius = 10
        newNoteButton.layer.masksToBounds = true
        newNoteButton.layer.borderColor = UIColor.black.cgColor
        newNoteButton.layer.borderWidth = 0.5
        newNoteButton.layer.shadowColor = UIColor.black.cgColor
        newNoteButton.layer.shadowOffset = CGSize.zero
        newNoteButton.layer.shadowRadius = 5.0
        newNoteButton.layer.shadowOpacity = 0.5
        newNoteButton.clipsToBounds = false
        
        mainMenuButton.layer.cornerRadius = 10
        mainMenuButton.layer.masksToBounds = true
        mainMenuButton.layer.borderColor = UIColor.black.cgColor
        mainMenuButton.layer.borderWidth = 0.5
        mainMenuButton.layer.shadowColor = UIColor.black.cgColor
        mainMenuButton.layer.shadowOffset = CGSize.zero
        mainMenuButton.layer.shadowRadius = 5.0
        mainMenuButton.layer.shadowOpacity = 0.5
        mainMenuButton.clipsToBounds = false
        
        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -2.0,
            ]
        
        notesHeader.attributedText = NSAttributedString(string: "Notes", attributes: strokeTextAttributes)
        
    }
    
    @IBAction func addNewNote(_ sender: Any) {
        currentlyEditing = false
        createAlertAddNote(title: "Enter Info", message: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // Init database reference
        //
        
        ref = Database.database().reference().child("users").child(uid)

        self.tableView.rowHeight = 75
        
        initView()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizeFirstLetter()
    }
}
