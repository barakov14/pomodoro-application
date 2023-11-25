import UIKit

class SwitchTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()

    private let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    weak var settingsViewController: SettingsViewController?

    @objc func switchValueChanged() {
        settingsViewController?.updateBackgroundColor(switchControl.isOn)

        // Отправляем уведомление о смене темы
        NotificationCenter.default.post(name: Notification.Name("ThemeChanged"), object: switchControl.isOn)
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(switchControl)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    func setSettingsViewController(_ viewController: SettingsViewController) {
        self.settingsViewController = viewController
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}
