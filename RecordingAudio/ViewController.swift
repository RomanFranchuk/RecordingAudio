





import UIKit

class ViewController: UIViewController {
    
    
    //MARK:
    //MARK: VIEW
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.buildVoiceCirlce()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Timer to update the status of our recording
    var nonObservablePropertiesUpdateTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    
    
    //MARK:
    //MARK: Recored Button
    
    @IBOutlet weak var recoredView: UIView!
    
  
    
    @IBOutlet weak var micBtn: UIButton!
 
  
    @IBOutlet weak var durationLabel: UILabel!
   
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBAction func StartRecording(_ sender: UIButton) {
        
        
        if   AudioRecorderManager.shared.recorded(fileName: "TestFile") {
            
            nonObservablePropertiesUpdateTimer.resume()
            
        }
        
        
        
        let formmater =  DateComponentsFormatter()
        
        formmater.zeroFormattingBehavior =  .pad
        formmater.includesApproximationPhrase = false
        formmater.includesTimeRemainingPhrase = false
        formmater.allowedUnits = [.minute,.second]
        formmater.calendar = Calendar.current
        
        
        nonObservablePropertiesUpdateTimer.setEventHandler { [weak self] in
            //Audio recording circle animations here
            
            guard let peak = AudioRecorderManager.shared.recorder else{
                
                return
            }
            
                    (self?.durationLabel.text = formmater.string(for: AudioRecorderManager.shared.recorder!.currentTime))!
                
                
                let percent = (Double(AudioRecorderManager.shared.recorderPeak0) + 160) / 160
                let final = CGFloat(percent) + 0.3
                
        
        
                UIView.animate(withDuration: 0.15, animations: {
                    self?.WaveAnimationView.transform = CGAffineTransform(scaleX: final, y: final)
            
                })
                
                
            }
            
    
    
        
        
        nonObservablePropertiesUpdateTimer.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.milliseconds(100))
        
        
        
        
        UIView.animate(withDuration: 0.15, animations: {
            self.WaveAnimationView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        
        DispatchQueue.main.async {
            self.statusLabel.text = "Release to stop recording"
            self.statusLabel.textColor = UIColor.orange
        }

        
    }
    
    
   
    
    
    
    @IBAction func stopRecording(_ sender: Any) {
        
        AudioRecorderManager.shared.finishRecording()
        
        
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.WaveAnimationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
        nonObservablePropertiesUpdateTimer.suspend()
        
        DispatchQueue.main.async {
            self.statusLabel.text = "Press & hold to start"
            self.statusLabel.textColor = UIColor.green
        }

    }
    
    
    
   
    
    
    @IBAction func playFile(_ sender: UIButton) {
        
        
        //In order to check the file if it's recording we can check for the file if it is exists after the record
        
        //Let's get the user's doc path
        
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        print("File Location:",url.path)
        
        
        if FileManager.default.fileExists(atPath: url.path){
            print("File found and ready to play")
        }else{
            print("no FIle")
        }

    }
    
    
   
    
    
    //MARK:
    //MARK: Build Wave Cricle
    var WaveAnimationView:UIView!
    func buildVoiceCirlce(){
        
        let size = CGSize(width: 200, height: 200)
        
        let newPoint = CGPoint(x:self.recoredView.frame.size.width / 2 - 100 , y: self.recoredView.frame.size.height / 2 - 100)
        WaveAnimationView = UIView(frame: CGRect(origin:newPoint , size: size))
        WaveAnimationView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        WaveAnimationView.layer.cornerRadius = 100
        WaveAnimationView.backgroundColor = UIColor.clear
        WaveAnimationView.layer.borderColor = UIColor.green.cgColor
        WaveAnimationView.layer.borderWidth = 1.0
        self.recoredView.addSubview(WaveAnimationView)
        
        self.WaveAnimationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        
    }
    
    
    
    
    
}
