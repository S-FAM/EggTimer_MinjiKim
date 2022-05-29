//
//  SoundViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//

import AVFoundation
import UIKit

final class SoundViewController: UIViewController {
    static let identifier = "SoundViewController"
    
    var player: AVAudioPlayer!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableView
extension SoundViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SoundCell.identifier) as? SoundCell else { return UITableViewCell() }
        
        cell.update(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = Sound(rawValue: indexPath.row)!
        SoundManager.setSound(sound: sound)
        
        tableView.reloadData()
        
        let soundName = String(indexPath.row+1)
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
