//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sudha Subramanian on 5/11/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioEngine: AVAudioEngine!
    var audioPlayer: AVAudioPlayer!
    var audioFile: AVAudioFile!
    var receivedAudio: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio(r: Float) {
        audioPlayer.stop()
        audioPlayer.rate = r
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playAtSlowRate() {
        playAudio(0.5)
    }
    
    @IBAction func playFastPaceAudio() {
        playAudio(1.5)
    }

    @IBAction func playChipmunkAudio() {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio() {
        playAudioWithPitch(-1000)
    }
    
    func playAudioWithPitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch;        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudio() {
        audioPlayer.stop()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
