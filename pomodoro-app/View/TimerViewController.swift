//
//  TimerViewController.swift
//  pomodoro-app
//
//  Created by Adilkhan Barakov on 18.11.2023.
//

import UIKit

class TimerViewController: UIViewController {
    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 72)
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "play"), for: .normal)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "restart"), for: .normal)
        button.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "skip"), for: .normal)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    var countdownSeconds: Int = 1500
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(countdownLabel)
        view.addSubview(countdownLabel)
        view.addSubview(startButton)
        view.addSubview(restartButton)
        view.addSubview(skipButton)
        
        // Настраиваем constraints для UILabel
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            startButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 45),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            skipButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 45),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100)
        ])
        countdownLabel.text = String(format: "%02d:%02d", countdownSeconds / 60, countdownSeconds % 60)
        // Загружаем предыдущее состояние таймера из UserDefaults
        if let savedSeconds = userDefaults.value(forKey: "countdownSeconds") as? Int {
            countdownSeconds = savedSeconds
        }
        
        updateUI()
        
        // Регистрируем фоновую задачу
        registerBackgroundTask()
        
        // Настройка таймера
    }
    var timer: Timer?
    private var workTime = 1500
    private var restTime = 300
    private var isRestTime = false
    private var isStarted = false
    
    func updateUI() {
        let minutes = countdownSeconds / 60
        let seconds = countdownSeconds % 60
        countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)
        // Сохраняем текущее состояние таймера в UserDefaults
        userDefaults.setValue(countdownSeconds, forKey: "countdownSeconds")
    }
    func switchTime() {
        if(isRestTime) {
            countdownSeconds = workTime
        } else {
            countdownSeconds = restTime
        }
        updateUI()
    }
    func switchStartToStop() {
        if(isStarted == false) {
            startButton.setImage(UIImage(named: "stop"), for: .normal)
        } else {
            startButton.setImage(UIImage(named: "play"), for: .normal)
        }
        isStarted = !isStarted
        updateUI()
    }
    func registerBackgroundTask() {
        UIApplication.shared.beginBackgroundTask { [weak self] in
            // Выполняется при истечении времени на выполнение фоновой задачи
            self?.endBackgroundTask()
        }
        
        
        DispatchQueue.global().async {
            // Здесь выполняется код таймера в фоновом режиме
            while true {
                self.updateUI()
                Thread.sleep(forTimeInterval: 1)
            }
        }
    }
    
    
    func endBackgroundTask() {
        timer?.invalidate()
        // Завершение фоновой задачи
        UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier(rawValue: 0))
    }
    @objc func startButtonTapped() {
        if isStarted == false {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                    self?.countdownSeconds -= 1
                    self?.updateUI()
                }
            } else {
                timer?.invalidate()
            }
            switchStartToStop()
    }
    @objc func restartButtonTapped() {
        countdownSeconds = workTime
        updateUI()
    }
    @objc func skipButtonTapped() {
        switchTime()
    }
}
