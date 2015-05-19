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
    let slowRate: Float = 0.3
    let fastRate: Float = 2.2
    let chipmunkPitch: Float = 1000
    let darthvaderPitch: Float = -900

    override func viewDidLoad() {
        super.viewDidLoad()
        //Prepare the audio play by instantiating the AVAudioEngine and 
        //setting the AVAudioFile to the Model received from the 
        //RecordAudioViewController
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    @IBAction func playBack(sender: UIButton) {
        //Figure out which button was pressed
        let playEffect = sender.currentTitle!
        println("Selected effect is \(playEffect)")
        playAudio(playEffect)
    }
    
    func rateStretch(v: Float) -> AVAudioUnitTimePitch {
        //return a AVAudioUnitTimePitch instance with the desired rate
        var changeRateEffect = AVAudioUnitTimePitch()
        changeRateEffect.rate = v;
        return changeRateEffect
    }

    func pitchShift(v: Float) -> AVAudioUnitTimePitch {
        //return a AVAudioUnitTimePitch instance with the desired pitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = v;
        return changePitchEffect
    }

    func playAudio(type: String) {
        //Stop the AVAudioEngine if it is already running
        if (audioEngine.running ) {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        //Setup the AVAudioPlayerNode to fetch the audio from the file at the given URL
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        //get the AVAudioUnitTimePitch instance with the desired rate or pitch
        let audioEffect: AVAudioUnitTimePitch!
        switch type {
            case "snail"     : audioEffect = rateStretch(slowRate)
            case "rabbit"    : audioEffect = rateStretch(fastRate)
            case "chipmonk"  : audioEffect = pitchShift(chipmunkPitch)
            case "darthvader": audioEffect = pitchShift(darthvaderPitch)
            default: return
        }
        audioEngine.attachNode(audioEffect)
        
        //Now connect the audio path
        audioEngine.connect(audioPlayerNode, to: audioEffect, format: nil)
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format: nil)
        
        //Start the engine
        audioEngine.startAndReturnError(nil)
        //Start the playback
        audioPlayerNode.play()

    }
    
    @IBAction func stopAudio() {
        //Stop the audio engine and player node
        audioEngine.stop()
        audioEngine.reset()
        audioPlayerNode.stop()
    }
    
}
