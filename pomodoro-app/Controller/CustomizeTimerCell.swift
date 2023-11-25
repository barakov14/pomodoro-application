class CustomizeTimerCell: UITableViewCell {

    let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let rightTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    private func setupLayout() {
        addSubview(leftLabel)
        addSubview(rightTextField)

        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            rightTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightTextField.widthAnchor.constraint(equalToConstant: 150) // Adjust the width as needed
        ])
    }
}
