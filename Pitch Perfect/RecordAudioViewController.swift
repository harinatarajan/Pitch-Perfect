//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Sudha Subramanian on 5/11/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordInProgress: UILabel!

    override func viewWillAppear(animated: Bool) {
        //Hide the Stop button and enable the Record button
        stopButton.hidden = true
        recordButton.enabled = true
    }

    //When the user presses the mike
    @IBAction func recordAudio() {
        //Change the text to inform the user that recording is in progress
        recordInProgress.text = "Recording"
        
        //Now display the Stop button and disable the Record button
        stopButton.hidden = false
        recordButton.enabled = false

        //For storing the recorded audio, get the documents directory path, 
        //set the file name to current time and date, set the file type as .wav,
        //and convert the path (String type) to URL format
        let dirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //Request the device audio session and specify our intention to record and play
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Now we are ready to record. Instantiate the AVAudioRecorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        //This file will be the AVAudioRecorderDelegate 
        audioRecorder.delegate = self
        //audioRecorder.meteringEnabled = true
        //audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //When recording has been finished or stopped and the file is stored
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            //if success, pass the url of the recorded audio file location to the
            //PlaySounds screen
            var model = RecordedAudio(url: recorder.url, t: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: model)
        } else {
            //if failed, restore this screen to start new recording
            stopButton.hidden = true
            recordButton.enabled = true
            recordInProgress.text = "Tap to record"
        }
    }
    
    //Go to the PlaySounds screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            //set the Model to the PlaySoundsViewController to the recorded file
            playSoundsVC.receivedAudio = data
        }
    }
    
    //When the user presses the stop button
    @IBAction func stopRecording() {
        //Stop the AVAudioRecorder and deactivate this app from the AVAUdioSession
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
        //Restore this screen to start new recording
        stopButton.hidden = true
        recordButton.enabled = true
        recordInProgress.text = "Tap to record"
    }
    
}

