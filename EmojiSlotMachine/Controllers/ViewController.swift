//
//  ViewController.swift
//  EmojiSlotMachine
//
//  Created by Marcy Vernon on 5/29/20.
//  Copyright © 2020 Marcy Vernon. All rights reserved.
//


import UIKit

class ViewController: UIViewController {

    var winFlag: Bool = false
    
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var buttonSpin : UIButton!

    var bounds    = CGRect.zero
    var dataArray = [[Int](), [Int](), [Int]()]
    var winSound  = SoundManager()
    var rattle    = SoundManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate   = self
        pickerView.dataSource = self
        loadData()
        setupUIAndSound()
        spinSlots()
    }
    
    
    func loadData() {
        for i in 0...2 {
            for _ in 0...100 {
                dataArray[i].append(Int.random(in: 0...K.imageArray.count - 1))
            }
        }
    }
    
    func setupUIAndSound() {
        // SOUND
        winSound.setupPlayer(soundName: K.sound, soundType: SoundType.m4a)
        rattle.setupPlayer(soundName: K.rattle, soundType: .m4a)
        winSound.volume(1.0)
        rattle.volume(0.1)
        buttonSpin.alpha = 0
        
        // UI
        bounds = buttonSpin.bounds
        setTrim()
        labelResult.layer.cornerRadius  = 10
        labelResult.layer.masksToBounds = true
        pickerView.layer.cornerRadius   = 10
        buttonSpin.layer.cornerRadius   = 40
    }
    
    func setTrim () {
        labelResult.layer.borderColor = UIColor.label.cgColor
        pickerView.layer.borderColor  = UIColor.label.cgColor
        buttonSpin.layer.borderColor  = UIColor.label.cgColor
        
        labelResult.layer.borderWidth = 2
        pickerView.layer.borderWidth  = 2
        buttonSpin.layer.borderWidth  = 2
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
        setTrim()
    }
    
    
    func spinSlots() {
        for i in 0...2 {
            pickerView.selectRow(Int.random(in: 3...97), inComponent: i, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration : 0.5,
                       delay        : 0.3,
                       options      : .curveEaseOut,
                       animations   : { self.buttonSpin.alpha = 1 },
                       completion   : nil)
    }

    
    @IBAction func spin(_ sender: AnyObject) {
        winSound.pause()
        rattle.play()
        spinSlots()
        checkWinOrLose()
        animateButton()
    }
    
    
    func checkWinOrLose() {
        let emoji0 = pickerView.selectedRow(inComponent: 0)
        let emoji1 = pickerView.selectedRow(inComponent: 1)
        let emoji2 = pickerView.selectedRow(inComponent: 2)

        if (dataArray[0][emoji0] == dataArray[1][emoji1]
         && dataArray[1][emoji1] == dataArray[2][emoji2]) {
            labelResult.text = K.win
            winSound.play()
        } else {
            labelResult.text = K.lose
        }
    }

    
    func animateButton(){
        // animate button
        let shrinkSize = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width - 15, height: bounds.size.height)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5,
                       options: .curveLinear,
                       animations: { self.buttonSpin.bounds = shrinkSize },
                       completion: nil )
    }
} // end of View Controller


// MARK:UIPickerViewDataSource
extension ViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
}

// MARK:UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80.0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 120.0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        switch component {
            case 0 : pickerLabel.text = K.imageArray[(Int)(dataArray[0][row])]
            case 1 : pickerLabel.text = K.imageArray[(Int)(dataArray[1][row])]
            case 2 : pickerLabel.text = K.imageArray[(Int)(dataArray[2][row])]
            default : print("done")
        }
        
        pickerLabel.font          = UIFont(name : K.emojiFont, size : 75)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
}
