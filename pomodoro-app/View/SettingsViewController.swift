import UIKit

class SettingsViewController: UITableViewController {
    let cellIdentifiers = ["Cell1", "Cell2", "Cell3", "Cell4"]
    let cellData = ["Customize Timer", "App Theme", "Customize Sounds", "Contact Us"]
    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 45)
        label.text = "Settings"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        for identifier in cellIdentifiers {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        }
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        headerView.addSubview(settingsLabel)

        NSLayoutConstraint.activate([
            settingsLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            settingsLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        tableView.tableHeaderView = headerView
        tableView.isScrollEnabled = false
        tableView.frame = view.bounds
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0 // Задайте высоту отступа между ячейками
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[indexPath.row], for: indexPath)

        cell.textLabel?.text = cellData[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        cell.layoutMargins = UIEdgeInsets.zero

        let backgroundView = UIView()
        backgroundView.clipsToBounds = true
        cell.backgroundView = backgroundView
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            let viewController1 = CustomizeTimerViewController()
            navigationController?.pushViewController(viewController1, animated: true)
        case 1:
            let viewController2 = AppThemeViewController()
            navigationController?.pushViewController(viewController2, animated: true)
        case 2:
            let viewController3 = CustomizeSoundsViewController()
            navigationController?.pushViewController(viewController3, animated: true)
        case 3:
            let viewController4 = ContactUsViewController()
            navigationController?.pushViewController(viewController4, animated: true)
        default:
            break
        }
    }
}
