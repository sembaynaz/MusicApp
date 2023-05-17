//
//  MainViewController.swift
//  MusicApp
//
//  Created by Nazerke Sembay on 04.04.2023.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MusicPlay {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var miniPlayer: UIView!
    @IBOutlet weak var songNameMiniPlayer: UILabel!
    @IBOutlet weak var playButtonMiniPlayer: UIButton!
    @IBOutlet weak var imageMiniPlayer: UIImageView!
    
    var player: AVPlayer!
    var position = 0
    var isPlaying = false
    var musicArray: [Music] = [Music(name: "Numb", artist: "Linkin Park", image: "linkin"),
                      Music(name: "Summertime Sadness", artist: "Lana Del Rey", image: "lana"),
                      Music(name: "The Resistance", artist: "Skillet", image: "skillet"),
                      Music(name: "Gold", artist: "Tolan", image: "tolan"),
                      Music(name: "Superman", artist: "Eminem", image: "eminem"),
                      Music(name: "Something In The Way", artist: "Nirvana", image: "nirvana")]

    override func viewDidLoad() {
        super.viewDidLoad()
        miniPlayer.isHidden = true
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.musicNameLabel?.text = musicArray[indexPath.row].name
        cell.artistNameLabel?.text = musicArray[indexPath.row].artist
        cell.musicImage?.image = UIImage(named: musicArray[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isPlaying = false
        player?.pause()
        position = indexPath.row
        performSegue(withIdentifier: "detailVC", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination
          as? ViewController else {return}
        
        if segue.identifier == "detailVC" {
            detailVC.music = musicArray
            detailVC.positionVC = position
            detailVC.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    func timetoString(intTime: Int) -> String{
        let seconds = intTime % 60
        let minutes = (intTime/60) % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    func setMusic(_ position: Int, _ currentTime: Double, _ isPlay: Bool) {
        miniPlayer.isHidden = false
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: musicArray[position].name, ofType: "mp3")!))
        
        if isPlay {
            player.play()
            isPlaying = true
            playButtonMiniPlayer.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            isPlaying = false
            player.pause()
            playButtonMiniPlayer.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
 
        if currentTime > 0 {
            let time = CMTime(seconds: currentTime, preferredTimescale: 1000)
            player.seek(to: time)
        }
        
        songNameMiniPlayer.text = musicArray[position].name
        imageMiniPlayer.image = UIImage(named: musicArray[position].image)
    }
    
    @IBAction func playButton(_ sender: Any) {
        if isPlaying {
            isPlaying = false
            player?.pause()
            playButtonMiniPlayer.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            isPlaying = true
            player?.play()
            playButtonMiniPlayer.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @IBAction func nextSong(_ sender: Any) {
        player?.pause()
        isPlaying = false
        playButtonMiniPlayer.setImage(UIImage(systemName: "play.fill"), for: .normal)
        if position < musicArray.count - 1{
            position += 1
        }else{
            position = 0
        }
        playButtonMiniPlayer.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        songNameMiniPlayer.text = musicArray[position].name
        imageMiniPlayer.image = UIImage(named: musicArray[position].image)
        configureSongs(music: musicArray[position].name)
    }
    
    @IBAction func previousSong(_ sender: Any) {
        player?.pause()
        isPlaying = false
        playButtonMiniPlayer.setImage(UIImage(systemName: "play.fill"), for: .normal)
        if position > 0{
            position -= 1
        }else{
            position = musicArray.count - 1
        }
        playButtonMiniPlayer.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        songNameMiniPlayer.text = musicArray[position].name
        imageMiniPlayer.image = UIImage(named: musicArray[position].image)
        configureSongs(music: musicArray[position].name)
    }
    
    
    func configureSongs(music: String){
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: music, ofType: "mp3")!))
        isPlaying = true
        player.play()
    }
    
    /*
     let time = CMTime(seconds: currentTime, preferredTimescale: 1000)
     player.seek(to: time)
     */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
