import UIKit

class MusicPlayerViewController: UIViewController {
    
    // Создайте свои IBOutlet и другие необходимые свойства
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var musicPlayerImageView: UIImageView!
    
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка вашего плеера и другие инициализации
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        // Переключение состояния воспроизведения
        isPlaying.toggle()
        
        // Анимация изменения изображения и состояния кнопки
        UIView.transition(with: musicPlayerImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            // Обновление изображения в зависимости от состояния воспроизведения
            self.musicPlayerImageView.image = self.isPlaying ? UIImage(named: "pause_image") : UIImage(named: "play_image")
        }, completion: nil)
        
        // Дополнительные действия при воспроизведении или паузе (например, управление аудио)
        if isPlaying {
            playAudio()
        } else {
            pauseAudio()
        }
    }
    
    func playAudio() {
        // Логика для начала воспроизведения аудио
        // Например, используйте AVAudioPlayer
    }
    
    func pauseAudio() {
        // Логика для приостановки воспроизведения аудио
        // Например, используйте AVAudioPlayer
    }
}
