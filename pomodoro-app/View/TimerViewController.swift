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
    var isStarted = false
    private let startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "play"), for: .normal)
        button.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Добавление countdownLabel в иерархию представлений
        view.addSubview(countdownLabel)
        view.addSubview(startStopButton)
        view.addSubview(restartButton)
        view.addSubview(skipButton)
        
        
        // Установка ограничений
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            startStopButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 20),
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 45),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            skipButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 45),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100)
        ])
        countdownLabel.text = String(format: "%02d:%02d", countdownSeconds / 60, countdownSeconds % 60)
    }
    
    var timer: Timer?
    var workTime = 1500
    lazy  var countdownSeconds = workTime
    var restTime = 300
    var isRestTime = false
    // Установите начальное значение в секундах
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if countdownSeconds > 0 {
            countdownSeconds -= 1
            updateUI()
        } else {
            if(isRestTime == false) {
                countdownSeconds = restTime
            } else {
                countdownSeconds = workTime
            }
            isRestTime = !isRestTime
            updateUI()
            timer?.invalidate() // Остановка таймера
            updateImg()
        }
    }
    
    func updateUI() {
        let minutes = countdownSeconds / 60
        let seconds = countdownSeconds % 60
        countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    func updateImg() {
        if(isStarted == false) {
            startStopButton.setImage(UIImage(named: "stop"), for: .normal)
        } else {
            startStopButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @objc func startStopButtonTapped() {
        // Возможно, добавить логику для кнопки "Старт"
        if(isStarted == false) {
            startTimer()
            updateImg()
        } else {
            timer?.invalidate()
            updateImg()
        }
        isStarted = !isStarted
    }
    @objc func restartButtonTapped() {
        if(isRestTime == false) {
            countdownSeconds = workTime
        } else {
            countdownSeconds = restTime
            isStarted = false
        }
        if(isStarted == true) {
            updateImg()
            isStarted = !isStarted
        }
        timer?.invalidate()
        updateUI()
    }
    @objc func skipButtonTapped() {
        if(isRestTime == true) {
            countdownSeconds = workTime
        } else {
            countdownSeconds = restTime
        }
        if(isStarted == true) {
            updateImg()
            isStarted = !isStarted
        }
        updateUI()
        isRestTime = !isRestTime
        timer?.invalidate()
    }
}

