import UIKit
import UserNotifications
import BackgroundTasks

class TimerViewController: UIViewController {
    let shapeLayer = CAShapeLayer()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
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
        view.addSubview(imageView)
        
    
        if(isRestTime) {
            imageView.image = UIImage(named: "sleep")
        } else {
            imageView.image = UIImage(named: "work")
        }
        
        // Настраиваем constraints для UILabel
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: startButton.topAnchor, constant: -400),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
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
        
        userDefaults.setValue(animationState, forKey: "savedAnimationState")
    }
    
    func switchTime() {
        if(isRestTime) {
            countdownSeconds = workTime
            imageView.image = UIImage(named: "work")
        } else {
            countdownSeconds = restTime
            imageView.image = UIImage(named: "sleep")
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
                self?.endBackgroundTask()
            }
            let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask { [weak self] in
                    self?.endBackgroundTask()
                }

                DispatchQueue.global().async {
                    while true {
                        // Update the interface or perform other actions as time decreases.
                        Thread.sleep(forTimeInterval: 1)

                        // Save the animation state in UserDefaults periodically
                        self.userDefaults.setValue(self.shapeLayer.presentation()?.strokeEnd, forKey: "savedAnimationProgress")
                    }
                }

                // Save the background task identifier for later use
                userDefaults.setValue(backgroundTaskIdentifier.rawValue, forKey: "backgroundTaskIdentifier")
    }
    
    func endBackgroundTask() {
        timer?.invalidate()
        UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier(rawValue: 0))
        userDefaults.setValue(shapeLayer.presentation()?.strokeEnd, forKey: "savedAnimationProgress")
        userDefaults.setValue(countdownSeconds, forKey: "countdownSeconds")
        if let backgroundTaskIdentifier = userDefaults.value(forKey: "backgroundTaskIdentifier") as? UIBackgroundTaskIdentifier {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        }
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
          // Reset animation state
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
        animationState = 0.0
        shapeLayer.removeAnimation(forKey: "urBasic")
    }
    
    @objc func skipButtonTapped() {
        animationState = 0// Reset animation state
        switchTime() // Remove any existing animations
        timer?.invalidate()
        if(isStarted) {
            switchStartToStop()
        }
        shapeLayer.removeAnimation(forKey: "urBasic")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save the animation state when navigating away
        userDefaults.setValue(shapeLayer.presentation()?.strokeEnd, forKey: "savedAnimationProgress")
        
        // Save the countdown seconds as well
        userDefaults.setValue(countdownSeconds, forKey: "countdownSeconds")
    }
    

        // Вместо applicationWillTerminate используйте этот метод
        

        // Используйте этот метод для проверки сохраненного состояния таймера при возврате в приложение
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            // Проверяем, было ли сохранено состояние таймера при предыдущем выходе из приложения
            if let savedCountdownSeconds = userDefaults.value(forKey: "savedCountdownSeconds") as? Int {
                countdownSeconds = savedCountdownSeconds
                updateUI()
                artificialPause()
                
                // Сохраняем текущий state анимации и время таймера в UserDefaults при выходе из контроллера
                userDefaults.setValue(animationState, forKey: "savedAnimationState")
                userDefaults.setValue(countdownSeconds, forKey: "savedCountdownSeconds")
            }
            

            // Проверяем, было ли сохранено состояние анимации
            if let savedAnimationState = userDefaults.value(forKey: "savedAnimationProgress") as? CGFloat {
                // Update the animation state
                shapeLayer.strokeEnd = savedAnimationState
            }
        }
    func restoreTimerState() {
            // Восстановление состояния таймера
            countdownSeconds = userDefaults.integer(forKey: "countdownSeconds")
            animationState = CGFloat(userDefaults.float(forKey: "savedAnimationState"))
            updateUI()
            
            if isStarted {
                animationStart()
            }
        }
    func artificialPause() {
            let semaphore = DispatchSemaphore(value: 0)
            
            // Introduce a delay, e.g., 2 seconds (adjust as needed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                semaphore.signal()
            }
            
            // Wait for the signal to proceed after the delay
            semaphore.wait()
        }
}
