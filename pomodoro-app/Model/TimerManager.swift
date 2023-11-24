import UIKit

class TimerManager {
    static let shared = TimerManager()

    private var timer: Timer?
    private let userDefaults = UserDefaults.standard

    var countdownSeconds: Int {
        didSet {
            // Сохраняем текущее состояние таймера в UserDefaults
            userDefaults.setValue(countdownSeconds, forKey: "countdownSeconds")
        }
    }

    private init() {
        countdownSeconds = userDefaults.value(forKey: "countdownSeconds") as? Int ?? 1500
    }

    func startTimer(withUpdateHandler updateHandler: @escaping (Int) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.countdownSeconds -= 1
            updateHandler(self.countdownSeconds)

            // Check if the timer has reached 0
            if self.countdownSeconds == 0 {
                self.stopTimer()
                // Additional actions on timer completion
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func saveTimerState() {
        userDefaults.setValue(countdownSeconds, forKey: "countdownSeconds")
    }

    func restoreTimerState() {
        countdownSeconds = userDefaults.value(forKey: "countdownSeconds") as? Int ?? 1500
    }
}
