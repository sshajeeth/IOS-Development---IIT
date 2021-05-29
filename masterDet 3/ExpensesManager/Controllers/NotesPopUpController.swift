import Foundation
import UIKit

class NotesPopoverController: UIViewController {
    
    @IBOutlet var notes_label: UILabel!
    
    var notes: String? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        if let notes = notes {
            if let notesTextView = notes_label {
                notesTextView.text = notes
            }
        }
    }
}
