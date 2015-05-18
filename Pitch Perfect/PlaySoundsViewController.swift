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
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    var receivedAudio: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAtSlowRate() {
        playAudioWithRate(0.1)
    }
    
    @IBAction func playFastPaceAudio() {
        playAudioWithRate(5)
    }

    @IBAction func playChipmunkAudio() {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio() {
        playAudioWithPitch(-1000)
    }

    func playAudioWithRate(rate: Float) {
        if (audioEngine.running ) {
            audioEngine.stop()
            audioEngine.reset()
        }
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        var changeRateEffect = AVAudioUnitTimePitch()
        changeRateEffect.rate = rate;
        audioEngine.attachNode(changeRateEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeRateEffect, format: nil)
        audioEngine.connect(changeRateEffect, to: audioEngine.outputNode, format: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func playAudioWithPitch(pitch: Float) {
        if (audioEngine.running ) {
            audioEngine.stop()
            audioEngine.reset()
        }
        audioPlayerNode = AVAudioPlayerNode()
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
        audioEngine.stop()
        audioEngine.reset()
        audioPlayerNode.stop()
    }
    
}
