import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let titleLabel = UILabel()
    let label = UILabel()
    let switchControl = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Настройка внешнего вида title label
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Настройка внешнего вида label
        label.text = "Swith to Dark Mode"
        label.translatesAutoresizingMaskIntoConstraints = false

        // Настройка внешнего вида UISwitch
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        switchControl.isOn = UserDefaults.standard.bool(forKey: "switchState")

        // Настройка внешнего вида UITableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Добавление subviews
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(label)
        view.addSubview(switchControl)
        
        StyleManager.applyStyle(to: self)

        // Описание constraints
        NSLayoutConstraint.activate([
            // Constraints для titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Constraints для UITableView
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            // Constraints для UILabel
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            // Constraints для UISwitch
            switchControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            switchControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let dataCell = ["Customize Timer", "Contact Us"]
        cell.textLabel?.text = dataCell[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Обработка выбора ячейки
        switch indexPath.row {
        case 0:
            // Переход на первый view controller
            let viewController1 = СustomizeTimerViewController()
            navigationController?.pushViewController(viewController1, animated: true)
        case 1:
            // Переход на третий view controller
            let viewController3 = ContactUsViewController()
            navigationController?.pushViewController(viewController3, animated: true)
        default:
            break
        }
    }
    static var backgroundColor: UIColor = .white
    static var textColor: UIColor = .black
    // MARK: - UISwitch Action
    @objc func switchValueChanged() {
        UserDefaults.standard.set(switchControl.isOn, forKey: "switchState")

            if switchControl.isOn {
                StyleManager.backgroundColor = UIColor.black
                StyleManager.textColor = UIColor.white
            } else {
                StyleManager.backgroundColor = UIColor.white
                StyleManager.textColor = UIColor.black
            }

            StyleManager.applyStyle(to: self)
    }
}
