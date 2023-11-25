import UIKit

class ContactUsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Create three labels
        let label1 = UILabel()
        label1.text = "210107032@gmail.com"
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = "210107091@gmail.com"
        label2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label2)
        
        let label3 = UILabel()
        label3.text = "200107135@gmail.com"
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label3)
        
        // Activate constraints
        NSLayoutConstraint.activate([
            // Constraints for Label 1
            label1.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Constraints for Label 2
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 20),
            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Constraints for Label 3
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20),
            label3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
}
