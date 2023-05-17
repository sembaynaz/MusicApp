//
//  ViewController.swift
//  MusicApp
//
//  Created by Nazerke Sembay on 09.03.2023.
//

import UIKit
import AVFoundation

protocol MusicPlay{
    func setMusic(_ position: Int, _ currentTime: Double, _ isPlay: Bool)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var timeIncrease: UILabel!
    @IBOutlet weak var timeDecrease: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var player: AVPlayer!
    var music: [Music] = []
    var positionVC = 0
    var count = false
    var delegate: MusicPlay?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        artist.text = music[positionVC].artist
        name.text = music[positionVC].name
        image.image = UIImage(named: music[positionVC].image)
        slider.value = 0
        configure(music: music[positionVC].name)
        
    }
    

    func configure(music: String) {
        // set up player
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: music, ofType: "mp3")!))
        
        slider.maximumValue = Float(player.currentItem?.asset.duration.seconds ?? 0)
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main) { (time) in
            self.timeIncrease.text = self.timetoString(intTime: Int(time.seconds))
            self.slider.value = Float(time.seconds)
            self.timeDecrease.text = "-" + self.timetoString(intTime: Int(self.slider.maximumValue) - Int(time.seconds))

        }
        count = true
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        player.play()
    }
    
    @IBAction func sliderMusic(_ sender: Any) {
        player.seek(to: CMTime(seconds: Double(slider.value), preferredTimescale: 1000))
        self.timeDecrease.text = timetoString(intTime: Int(slider.value))
    }
    
    @IBAction func pausePlayMusic(_ sender: Any) {
        if count {
            count = false
            player?.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }else{
            count = true
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @IBAction func previousMusic(_ sender: Any) {
        player?.pause()
        count = false
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        if positionVC > 0{
            positionVC -= 1
            count = true
        }else{
            positionVC = music.count - 1
            count = true
        }
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        artist.text = music[positionVC].artist
        name.text = music[positionVC].name
        image.image = UIImage(named: music[positionVC].image)
        configure(music: music[positionVC].name)
    }
    
    @IBAction func nextMusic(_ sender: Any) {
        player?.pause()
        count = false
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        if positionVC < music.count - 1{
            positionVC += 1
            count = true
        }else{
            positionVC = 0
            count = true
        }
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        artist.text = music[positionVC].artist
        name.text = music[positionVC].name
        image.image = UIImage(named: music[positionVC].image)
        configure(music: music[positionVC].name)
    }
    
    func timetoString(intTime: Int) -> String{
        let seconds = intTime % 60
        let minutes = (intTime/60) % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
        if let player = player{
            delegate?.setMusic(positionVC, CMTimeGetSeconds(player.currentTime()), count)
        }
    }
    
}

