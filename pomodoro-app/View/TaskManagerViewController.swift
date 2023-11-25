import UIKit

struct Task {
    var title: String
    var description: String
    var dueDate: Date
    var isCompleted: Bool
}

class TaskCell: UITableViewCell {
    var completionButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        completionButton = UIButton(type: .system)
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.layer.cornerRadius = 15
        completionButton.layer.borderWidth = 1
        completionButton.layer.borderColor = UIColor.red.cgColor
        completionButton.addTarget(self, action: #selector(completionButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(completionButton)
        
        NSLayoutConstraint.activate([
            completionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            completionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            completionButton.widthAnchor.constraint(equalToConstant: 30),
            completionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func completionButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("TaskCellCompletionButtonTapped"), object: self)
    }
}

class TaskManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tasks: [Task] = []
        var tableView: UITableView!

        override func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = .white

            tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(TaskCell.self, forCellReuseIdentifier: "Cell")
            view.addSubview(tableView)

            let addButton = createButton(title: "Add Task", action: #selector(addTaskButtonTapped))
            let deleteButton = createButton(title: "Delete Task", action: #selector(deleteTaskButtonTapped))
            let editButton = createButton(title: "Edit Task", action: #selector(editTaskButtonTapped))

            view.addSubview(addButton)
            view.addSubview(deleteButton)
            view.addSubview(editButton)

            NSLayoutConstraint.activate([
                addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                deleteButton.topAnchor.constraint(equalTo: addButton.topAnchor),
                deleteButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 20),
                editButton.topAnchor.constraint(equalTo: addButton.topAnchor),
                editButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 20),
                tableView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            NotificationCenter.default.addObserver(self, selector: #selector(taskCellCompletionButtonTapped(_:)), name: Notification.Name("TaskCellCompletionButtonTapped"), object: nil)
        }

        // Action method for the add task button tap event
        @objc func addTaskButtonTapped() {
            // Present the AddTaskViewController to allow the user to set title, description, and due date
            let addTaskVC = AddTaskViewController { [weak self] title, description, dueDate in
                // Check if a task with the same title already exists
                if self?.tasks.first(where: { $0.title == title }) == nil {
                    // Create a new task with the provided values
                    let newTask = Task(title: title, description: description, dueDate: dueDate, isCompleted: false)

                    // Add the new task to the array
                    self?.tasks.append(newTask)

                    // Reload the table view to reflect the changes
                    self?.tableView.reloadData()

                } else {
                    // Show an alert if a task with the same title already exists
                    let alert = UIAlertController(title: "Duplicate Title", message: "A task with the same title already exists.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            present(addTaskVC, animated: true, completion: nil)
        }

    // Action method for the delete button tap event
    @objc func deleteTaskButtonTapped() {
        // Get the selected index path
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Remove the task from the array
            tasks.remove(at: selectedIndexPath.row)
            // Reload the table view to reflect the changes
            tableView.reloadData()
            
        } else {
            // Show an alert if no row is selected
            let alert = UIAlertController(title: "No Task Selected", message: "Please select a task to delete.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // Action method for the edit button tap event
    @objc func editTaskButtonTapped() {
        // Get the selected index path
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Present the EditTaskViewController to allow the user to edit title, description, and due date
            let editTaskVC = EditTaskViewController(task: tasks[selectedIndexPath.row]) { [weak self] title, description, dueDate in
                // Update the task with the edited values
                self?.tasks[selectedIndexPath.row] = Task(title: title, description: description, dueDate: dueDate, isCompleted: false)

                // Reload the table view to reflect the changes
                self?.tableView.reloadData()
            }
            present(editTaskVC, animated: true, completion: nil)
        } else {
            // Show an alert if no row is selected
            let alert = UIAlertController(title: "No Task Selected", message: "Please select a task to edit.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    private func createButton(title: String, action: Selector) -> UIButton {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.addTarget(self, action: action, for: .touchUpInside)
            return button
        }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCell

        let task = tasks[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: task.dueDate)

        cell.textLabel?.text = "\(task.title)\n\(task.description)\n \(formattedDate)"

        // Set the button's tag to the row index for tracking
        cell.completionButton.tag = indexPath.row

        // Update the button appearance based on the completion status
        updateCompletionButtonAppearance(cell.completionButton, isCompleted: task.isCompleted)

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    // Helper method to update the appearance of the completion button
    func updateCompletionButtonAppearance(_ button: UIButton, isCompleted: Bool) {
        if isCompleted {
            button.backgroundColor = UIColor.red
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitle("✓", for: .normal)
        } else {
            button.backgroundColor = UIColor.clear
            button.setTitleColor(UIColor.red, for: .normal)
            button.setTitle("", for: .normal)
        }
    }

    // Notification handler for the completion button tap event
    @objc func taskCellCompletionButtonTapped(_ notification: Notification) {
        guard let cell = notification.object as? TaskCell else { return }
        let index = cell.completionButton.tag
        tasks[index].isCompleted.toggle()

        // Update the button appearance with animation
        UIView.animate(withDuration: 0.3) {
            self.updateCompletionButtonAppearance(cell.completionButton, isCompleted: self.tasks[index].isCompleted)
        }
    }
}


// Create a separate view controller for editing tasks
class EditTaskViewController: UIViewController {
    
    var task: Task
    var completionHandler: ((String, String, Date) -> Void)?
    
    init(task: Task, completion: @escaping (String, String, Date) -> Void) {
        self.task = task
        self.completionHandler = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create UI elements for editing title, description, and due date
        let titleTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 30))
        titleTextField.placeholder = "Title"
        titleTextField.text = task.title
        titleTextField.backgroundColor = UIColor.white
        view.addSubview(titleTextField)
        
        // Text view for description
        let descriptionTextView = UITextView(frame: CGRect(x: 20, y: 150, width: 200, height: 100))
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.font = UIFont.systemFont(ofSize: 15)
        descriptionTextView.text = task.description
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 5.0
        view.addSubview(descriptionTextView)
        
        // Date picker for due date
        let dueDatePicker = UIDatePicker(frame: CGRect(x: 20, y: 260, width: 200, height: 30))
        dueDatePicker.datePickerMode = .dateAndTime
        dueDatePicker.date = task.dueDate
        view.addSubview(dueDatePicker)
        
        // Button to confirm and edit task
        let editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: 20, y: 310, width: 200, height: 40)
        editButton.backgroundColor = UIColor.red
        editButton.setTitle("Edit Task", for: .normal)
        editButton.setTitleColor(UIColor.white, for: .normal)
        editButton.addTarget(self, action: #selector(editTaskButtonTapped), for: .touchUpInside)
        view.addSubview(editButton)
    }
    
    // Action method for the button tap event
    @objc func editTaskButtonTapped() {
        // Retrieve values from UI elements
        guard let title = (view.subviews.first { $0 is UITextField && ($0 as! UITextField).placeholder == "Title" } as? UITextField)?.text,
            let description = (view.subviews.first { $0 is UITextView } as? UITextView)?.text
        else {
            return
        }
        
        let dueDate = (view.subviews.first { $0 is UIDatePicker } as? UIDatePicker)?.date ?? Date()
        
        // Call the completion handler to edit the task in the main view controller
        completionHandler?(title, description, dueDate)
        
        // Dismiss the EditTaskViewController
        dismiss(animated: true, completion: nil)
    }
}

// Create a separate view controller for adding tasks
class AddTaskViewController: UIViewController {
    
    var completionHandler: ((String, String, Date) -> Void)?
    
    init(completion: ((String, String, Date) -> Void)?) {
        self.completionHandler = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create UI elements for setting title, description, and due date
        
        //Text field for title
        let titleTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 30))
        titleTextField.placeholder = "Title"
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.backgroundColor = UIColor.white
        view.addSubview(titleTextField)
        
        //Text view for description (allows multiline input)
        let descriptionTextView = UITextView(frame: CGRect(x: 20, y: 150, width: 200, height: 100))
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.font = UIFont.systemFont(ofSize: 15)
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 5.0
        view.addSubview(descriptionTextView)
        
        // Date picker for due date
        let dueDatePicker = UIDatePicker(frame: CGRect(x: 20, y: 260, width: 200, height: 30))
        dueDatePicker.datePickerMode = .dateAndTime
        view.addSubview(dueDatePicker)
        
        // Button to confirm and add task
        let addButton = UIButton(type: .system)
        addButton.frame = CGRect(x: 20, y: 310, width: 200, height: 40)
        addButton.backgroundColor = UIColor.red
        addButton.setTitle("Add Task", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    // Action method for the button tap event
    @objc func addTaskButtonTapped() {
        // Retrieve values from UI elements
        guard let title = (view.subviews.first { $0 is UITextField && ($0 as! UITextField).placeholder == "Title" } as? UITextField)?.text,
            let description = (view.subviews.first { $0 is UITextView } as? UITextView)?.text
        else {
            return
        }
        
        let dueDate = (view.subviews.first { $0 is UIDatePicker } as? UIDatePicker)?.date ?? Date()
        
        // Call the completion handler to add the task to the main view controller
        completionHandler?(title, description, dueDate)
        
        // Dismiss the AddTaskViewController
        dismiss(animated: true, completion: nil)
    }
}


