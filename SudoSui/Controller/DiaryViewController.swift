//
//  DiaryViewController.swift
//  SudoSui
//
//  Created by lingxinchen on 4/19/22.
//

import UIKit
import FSCalendar
import Firebase

class DiaryViewController: UIViewController {
    @IBOutlet weak var pastEmojiLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var pastView: UIView!
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var pastHighlightLabel: UILabel!
    @IBOutlet weak var pastEmojiIV: UIImageView!
    @IBOutlet weak var highlightTV: UITextView!
    @IBOutlet var emojiButtons: [UIButton]!
    let db = Firestore.firestore()
    var today: String = ""
    var emojiArrays: [UIButton] = []
    var editedEmoji: Bool = false
    var editedHighlight: Bool = false
    var user: String = ""
    var loadedEmoji: Bool = false
    var loadedHighlight: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        highlightTV.delegate = self
        let temp = Date()
        today = getDate(date: temp)
        collectEmojiButtons()
        if let userTemp = Auth.auth().currentUser?.email {
            user = userTemp.replacingOccurrences(of: ".", with: "@")
            loadDairy(givenDate: today, givenUser: user)
        }
    }
    
    //MARK: related to UI view
    @IBAction func rateHappiness(_ sender: UIButton) {
        var emoji: String
        switch sender.tag {
        case 0:
            emoji = "sad"
        case 1:
            emoji = "meh"
        case 2:
            emoji = "happy"
        default:
            emoji = ""
        }
        hideEmojiButtons(visible: sender.tag)
        if emoji != "" {
            db.collection(user).document(today).setData(["emoji": emoji], merge: true)
            self.editedEmoji = true
            if self.editedHighlight {
                self.todayView.isHidden = true
                self.pastView.isHidden = false
                self.pastHighlightLabel.text = self.highlightTV.text
                self.highlightTV.text = "Type here"
            }
        }
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        if let highlight = highlightTV.text {
            db.collection(user).document(today).setData(["highlight": highlight], merge: true)
            self.editedHighlight = true
            if self.editedEmoji {
                self.loadDairy(givenDate: self.today, givenUser: self.user)
            } else {
                self.highlightTV.isEditable = false
            }
        }
    }
    
    //MARK: help functions
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        return dateFormatter.string(from: date).replacingOccurrences(of: ".", with: "")
    }
    
    func collectEmojiButtons() {
        for b in emojiButtons {
            emojiArrays.append(b)
        }
    }
    
    func hideEmojiButtons(visible: Int) {
        for i in 0..<emojiArrays.count {
            if i != visible {
                emojiArrays[i].isHidden = true
            }
        }
    }
    
    func loadDairy(givenDate: String, givenUser: String?) {
        if let givenUser = givenUser {
            db.collection(givenUser).document(givenDate)
                .addSnapshotListener { documentSnapshot, error in
                  guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                  }
                  guard let data = document.data() else {
                    self.pastEmojiIV.isHidden = true
                    self.pastEmojiLabel.isHidden = false
                    self.pastHighlightLabel.text = "not written"
                    return
                  }
                    if let emoji = data["emoji"], let highlight = data["highlight"]{
                        self.pastEmojiIV.image = UIImage(named: emoji as! String)
                        self.pastEmojiLabel.isHidden = true
                        self.pastEmojiIV.isHidden = false
                        self.pastView.isHidden = false
                        self.todayView.isHidden = true
                        self.pastHighlightLabel.text = highlight as? String
                        if givenDate == self.today {
                            self.loadedEmoji = true
                            self.loadedHighlight = true
                        }
                    } else {
                        self.pastEmojiIV.isHidden = true
                        self.pastEmojiLabel.isHidden = false
                        self.pastEmojiLabel.text = "not written"
                        self.pastHighlightLabel.text = "not written"
                    }
                }
        }
    }
   
}

//MARK: Calendar delegate
extension DiaryViewController: FSCalendarDelegate, FSCalendarDataSource{
    //Set Minimum Date
    func minimumDate(for calendar: FSCalendar) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.date(from: "1900-01-01") ?? Date()
    }
     
    //Set maximum Date
    func maximumDate(for calendar: FSCalendar) -> Date {
          return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if today == getDate(date: date) && !loadedEmoji && !loadedHighlight{
            todayView.isHidden = false
            pastView.isHidden = true
        } else {
            todayView.isHidden = true
            pastView.isHidden = false
            let selectDate = getDate(date: date)
            loadDairy(givenDate: selectDate, givenUser: user)
        }
    }
}

//MARK: Textview
extension DiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        highlightTV.text = ""
    }
}
