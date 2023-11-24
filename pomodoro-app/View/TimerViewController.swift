import UIKit
import UserNotifications
import BackgroundTasks

class TimerViewController: UIViewController {
    let shapeLayer = CAShapeLayer()
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
        view.addSubview(startButton)
        view.addSubview(restartButton)
        view.addSubview(skipButton)
        
        // Настраиваем constraints для UILabel
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            startButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 35),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 60),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            skipButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 60),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
        ])
        countdownLabel.text = String(format: "%02d:%02d", countdownSeconds / 60, countdownSeconds % 60)
        
        // Загружаем предыдущее состояние таймера из UserDefaults
        if let savedSeconds = userDefaults.value(forKey: "countdownSeconds") as? Int {
            countdownSeconds = savedSeconds
        }
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: view.center.y - 140), radius: 160, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 2, clockwise: true)
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        view.layer.addSublayer(trackLayer)
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 15
        
        shapeLayer.path = circularPath.cgPath
        view.layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        
        updateUI()
        // Регистрируем фоновую задачу
        registerBackgroundTask()
    }
    
    var timer: Timer?
    private var workTime = 20
    private var restTime = 10
    private var isRestTime = false
    private var isStarted = false
    var progress: Float = 0.0
    var animationState: CGFloat = 0.0
    
    func updateUI() {
        let minutes = countdownSeconds / 60
        let seconds = countdownSeconds % 60
        countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)
        // Сохраняем текущее состояние таймера в UserDefaults
        userDefaults.setValue(countdownSeconds, forKey: "countdownSeconds")
    }
    
    func animationStart() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = animationState
        basicAnimation.toValue = 1.0
        
        if isRestTime {
            basicAnimation.duration = Double(restTime) * (1.0 - animationState)
        } else {
            basicAnimation.duration = Double(workTime) * (1.0 - animationState)
        }
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.speed = 0.79
        shapeLayer.add(basicAnimation, forKey: "urBasic")
        
        // Сохраняем текущий прогресс анимации в UserDefaults
        userDefaults.setValue(shapeLayer.presentation()?.strokeEnd, forKey: "savedAnimationProgress")
    }
    
    func animationStop() {
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
        animationState = shapeLayer.presentation()?.strokeEnd ?? 0.0
        
        // Сохраняем текущий state анимации в UserDefaults при остановке таймера
        userDefaults.setValue(animationState, forKey: "savedAnimationState")
    }
    
    func switchTime() {
        if(isRestTime) {
            countdownSeconds = workTime
        } else {
            countdownSeconds = restTime
        }
        updateUI()
        isRestTime = !isRestTime
    }
    
    func switchStartToStop() {
        if(isStarted == false) {
            startButton.setImage(UIImage(named: "stop"), for: .normal)
        } else {
            startButton.setImage(UIImage(named: "play"), for: .normal)
            let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
            shapeLayer.speed = 0.0
            shapeLayer.timeOffset = pausedTime
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
                guard let self = self else { return }
                self.countdownSeconds -= 1
                self.updateUI()
                
                // Check if the timer has reached 0
                if self.countdownSeconds == 0 {
                    self.timer?.invalidate()
                    self.switchTime()
                    self.switchStartToStop()
                    self.animationStop()
                    self.animationState = 0.0
                    self.shapeLayer.removeAnimation(forKey: "urBasic")
                }
            }
            animationStart()
        } else {
            timer?.invalidate()
            animationStop()
        }
        switchStartToStop()
    }
    
    @objc func restartButtonTapped() {
        animationState = 0.0  // Reset animation state
        if(isRestTime) {
            countdownSeconds = restTime
        } else {
            countdownSeconds = workTime
        }
        updateUI()
        timer?.invalidate()
        if(isStarted) {
            switchStartToStop()
        }
        shapeLayer.removeAnimation(forKey: "urBasic")
    }
    
    @objc func skipButtonTapped() {
        animationState = 0.0  // Reset animation state
        switchTime() // Remove any existing animations
        timer?.invalidate()
        if(isStarted) {
            switchStartToStop()
        }
        shapeLayer.removeAnimation(forKey: "urBasic")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Сохраняем текущий state анимации в UserDefaults при выходе из контроллера
        userDefaults.setValue(animationState, forKey: "savedAnimationState")
        
        // Убеждаемся, что задача фоновой работы завершается при закрытии контроллера
        endBackgroundTask()
    }
    

        // Вместо applicationWillTerminate используйте этот метод
        

        // Используйте этот метод для проверки сохраненного состояния таймера при возврате в приложение
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            // Проверяем, было ли сохранено состояние таймера при предыдущем выходе из приложения
            if let savedCountdownSeconds = userDefaults.value(forKey: "savedCountdownSeconds") as? Int {
                countdownSeconds = savedCountdownSeconds
                updateUI()
                
                // Сохраняем текущий state анимации и время таймера в UserDefaults при выходе из контроллера
                userDefaults.setValue(animationState, forKey: "savedAnimationState")
                userDefaults.setValue(countdownSeconds, forKey: "savedCountdownSeconds")
            }

            // Проверяем, было ли сохранено состояние анимации
            if let savedAnimationState = userDefaults.value(forKey: "savedAnimationState") as? CGFloat {
                animationState = savedAnimationState
                shapeLayer.timeOffset = savedAnimationState
                shapeLayer.speed = 0.0
            }
        }
    
}
