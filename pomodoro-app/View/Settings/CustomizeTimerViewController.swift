import UIKit

class СustomizeTimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var itemsArray1: [Int] = [25, 30, 35, 40, 45]
    var itemsArray2: [Int] = [5, 10, 15, 20, 25]

    var selectedWorkTime: Int = 1500 {
        didSet {
            UserDefaults.standard.set(selectedWorkTime, forKey: "SelectedWorkTime")
        }
    }

    var selectedRestTime: Int = 300 {
        didSet {
            UserDefaults.standard.set(selectedRestTime, forKey: "SelectedRestTime")
        }
    }

    let label1: UILabel = {
        let label = UILabel()
        label.text = "Auto Start Break"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let switch1: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    let label2: UILabel = {
        let label = UILabel()
        label.text = "Work Time"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dropdown1: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    let label3: UILabel = {
        let label = UILabel()
        label.text = "Rest Time"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dropdown2: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    let openPickerButton1: UIButton = {
        let button = UIButton()
        button.setTitle("V", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let openPickerButton2: UIButton = {
        let button = UIButton()
        button.setTitle("V", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let selectedValueLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let selectedValueLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var isDropdown1Visible: Bool = false {
        didSet {
            dropdown1.isHidden = !isDropdown1Visible
        }
    }

    var isDropdown2Visible: Bool = false {
        didSet {
            dropdown2.isHidden = !isDropdown2Visible
        }
    }
    var isAutoBreakSwitchOn: Bool = false {
        didSet {
            UserDefaults.standard.set(isAutoBreakSwitchOn, forKey: "IsAutoBreakSwitchOn")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(label1)
        view.addSubview(switch1)
        view.addSubview(label2)
        view.addSubview(dropdown1)
        view.addSubview(label3)
        view.addSubview(dropdown2)
        view.addSubview(openPickerButton1)
        view.addSubview(openPickerButton2)
        view.addSubview(selectedValueLabel1)
        view.addSubview(selectedValueLabel2)

        dropdown1.delegate = self
        dropdown1.dataSource = self
        dropdown2.delegate = self
        dropdown2.dataSource = self

        openPickerButton1.addTarget(self, action: #selector(openPicker1), for: .touchUpInside)
        openPickerButton2.addTarget(self, action: #selector(openPicker2), for: .touchUpInside)

        // Retrieve saved values from UserDefaults or use default values
        selectedWorkTime = UserDefaults.standard.integer(forKey: "SelectedWorkTime")
        selectedRestTime = UserDefaults.standard.integer(forKey: "SelectedRestTime")

        selectedValueLabel1.text = "Selected Work Time: \(selectedWorkTime) min"
        selectedValueLabel2.text = "Selected Rest Time: \(selectedRestTime) min"

        setupConstraints()

        // Add this check to avoid automatic opening of pickers
        if !isDropdown1Visible && !isDropdown2Visible {
            hideOppositePicker()
        }
        isAutoBreakSwitchOn = UserDefaults.standard.bool(forKey: "IsAutoBreakSwitchOn")
        switch1.isOn = isAutoBreakSwitchOn

        switch1.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            switch1.centerYAnchor.constraint(equalTo: label1.centerYAnchor),
            switch1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 20),
            label2.leadingAnchor.constraint(equalTo: label1.leadingAnchor),
            
            openPickerButton1.centerYAnchor.constraint(equalTo: label2.centerYAnchor),
            openPickerButton1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // Отступ от label2
            
            dropdown1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dropdown1.trailingAnchor.constraint(equalTo: switch1.trailingAnchor),
            
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20),
            label3.leadingAnchor.constraint(equalTo: label2.leadingAnchor),
            
            openPickerButton2.centerYAnchor.constraint(equalTo: label3.centerYAnchor),
            openPickerButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // Отступ от label3
            
            dropdown2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dropdown2.trailingAnchor.constraint(equalTo: dropdown1.trailingAnchor),
            
            selectedValueLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectedValueLabel1.topAnchor.constraint(equalTo: openPickerButton2.bottomAnchor, constant: 20),
            
            selectedValueLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectedValueLabel2.topAnchor.constraint(equalTo: selectedValueLabel1.bottomAnchor, constant: 20)
        ])
    }

    @objc func openPicker1() {
        if isDropdown1Visible {
            isDropdown1Visible = false
        } else {
            hideOppositePicker()
            isDropdown1Visible = true
        }
    }

    @objc func openPicker2() {
        if isDropdown2Visible {
            isDropdown2Visible = false
        } else {
            hideOppositePicker()
            isDropdown2Visible = true
        }
    }

    func hideOppositePicker() {
        isDropdown1Visible = false
        isDropdown2Visible = false
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dropdown1 {
            return itemsArray1.count
        } else if pickerView == dropdown2 {
            return itemsArray2.count
        }
        return 0
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dropdown1 {
            return String(itemsArray1[row]) + " min"
        } else if pickerView == dropdown2 {
            return String(itemsArray2[row]) + " min"
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dropdown1 {
            selectedWorkTime = itemsArray1[row]
            selectedValueLabel1.text = "Selected Work Time: \(selectedWorkTime) min"
            TimerViewController.workTime = selectedWorkTime * 60
        } else if pickerView == dropdown2 {
            selectedRestTime = itemsArray2[row]
            selectedValueLabel2.text = "Selected Rest Time: \(selectedRestTime) min"
            TimerViewController.workTime = selectedRestTime * 60
        }
        isDropdown1Visible = false
        isDropdown2Visible = false
    }

    static var isAutoBreak = false
    
    @objc func switchValueChanged() {
        СustomizeTimerViewController.isAutoBreak = !СustomizeTimerViewController.isAutoBreak
        isAutoBreakSwitchOn = switch1.isOn
        UserDefaults.standard.set(isAutoBreakSwitchOn, forKey: "IsAutoBreakSwitchOn")
        UserDefaults.standard.synchronize()
    }
}
