

import UIKit

class SecondScreen: UIViewController {
    
    var (hours,minutes,seconds) = (0,0,30)
    var timer = Timer()
    
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var playOutlet: UIButton!
    @IBOutlet weak var pauseOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func slider(_ sender: UISlider) {
        seconds = Int(sender.value)
        //labelTime.text = String(seconds)s
        let secondsString2 = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        labelTime.text = "00:00:\(secondsString2)"
        
    }
    
    @IBAction func buttonStart(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SecondScreen.updateTimer), userInfo: nil, repeats: true)
        
        playOutlet.isEnabled = false
        pauseOutlet.isEnabled = true
        stopOutlet.isEnabled = true
    }
    
    @IBAction func buttonPause(_ sender: Any) {
        timer.invalidate()
        playOutlet.isEnabled = true
        pauseOutlet.isEnabled = false
        stopOutlet.isEnabled = true
    }
    @IBAction func buttonStop(_ sender: Any) {
        timer.invalidate()
        (hours,minutes,seconds) = (0,0,30)
        slider.setValue(30, animated: true)
        labelTime.text = "00:00:30"
        
        playOutlet.isEnabled = true
        pauseOutlet.isEnabled = true
        stopOutlet.isEnabled = false
    }
    @objc func updateTimer(){
        
        seconds -= 1
       // labelTime.text = String(seconds)
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        labelTime.text = "\(hoursString):\(minutesString):\(secondsString)"
        
        slider.value = Float(seconds)
        
        if seconds == 0 {
            timer.invalidate()
        }
        
    }
}
