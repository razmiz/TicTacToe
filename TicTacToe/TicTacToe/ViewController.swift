//
//  ViewController.swift
//  TicTacToe
//
//  Created by Raz on 29/03/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var winnerLabel: UILabel!
    var computerMode: Bool = false
    var currentShape = "O"
    @IBOutlet weak var computerModeSwitch: UISwitch!
    var isGameEnded: Bool = false
    var freeButtons: [Int] = [0,1,2,3,4,5,6,7,8]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    func configureButtons(){
        var tagNumber = 0
        for button in buttonsCollection{
            button.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/225, alpha: 1).cgColor
            button.layer.borderWidth = 1.2
            button.layer.cornerRadius = 5
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 70)
            button.tag = tagNumber
            tagNumber += 1
            button.isEnabled = true
            button.setTitle("", for: .normal)
            if  winnerLabel != nil { winnerLabel.text = "Winner: " }
            ColorButtonTitle(button: button, color: UIColor.white)
            resetFreeButtons()
        }
        isGameEnded = false
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        currentShape = currentShape == "X" ? "O" : "X"
        
        if !computerMode{
            sender.setTitle(currentShape, for: .normal)
            checkWinner(senderShape: sender.getTitle())
        }else{
            sender.setTitle(currentShape, for: .normal)
            checkWinner(senderShape: currentShape)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.currentShape = self.currentShape == "X" ? "O" : "X"
                self.computerTurn()
            }
        }
        sender.isEnabled = false
        freeButtons[sender.tag] = -1
        
    }
    
    func resetFreeButtons(){
        for (i, _) in freeButtons.enumerated(){
            freeButtons[i] = i
        }
    }
    
    func checkWinner(senderShape: String){
        if checkThreeButtons(button1: buttonsCollection[0], button2: buttonsCollection[1], button3: buttonsCollection[2]){
            winnerFound(winnerShape: senderShape)
            ColorButtonTitle(button: buttonsCollection[0], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[1], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[2], color: UIColor.red)
        }
        if checkThreeButtons(button1: buttonsCollection[3], button2: buttonsCollection[4], button3: buttonsCollection[5]){
            winnerFound(winnerShape: senderShape)
            ColorButtonTitle(button: buttonsCollection[3], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[4], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[5], color: UIColor.red)
        }
        if checkThreeButtons(button1: buttonsCollection[6], button2: buttonsCollection[7], button3: buttonsCollection[8]){
            winnerFound(winnerShape: senderShape)
            ColorButtonTitle(button: buttonsCollection[6], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[7], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[8], color: UIColor.red)
        }
        if checkThreeButtons(button1: buttonsCollection[0], button2: buttonsCollection[3], button3: buttonsCollection[6]){
            winnerFound(winnerShape: senderShape)
            ColorButtonTitle(button: buttonsCollection[0], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[3], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[6], color: UIColor.red)
        }
        if checkThreeButtons(button1: buttonsCollection[1], button2: buttonsCollection[4], button3: buttonsCollection[7]){
            winnerFound(winnerShape: senderShape)
            ColorButtonTitle(button: buttonsCollection[1], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[4], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[7], color: UIColor.red)
        }
        if checkThreeButtons(button1: buttonsCollection[2], button2: buttonsCollection[5], button3: buttonsCollection[8]){
            winnerFound(winnerShape: senderShape)
            ColorButtonTitle(button: buttonsCollection[2], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[5], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[8], color: UIColor.red)
        }
        if checkThreeButtons(button1: buttonsCollection[0], button2: buttonsCollection[4], button3: buttonsCollection[8]){
            winnerFound(winnerShape: senderShape)
            ColorButtonTitle(button: buttonsCollection[0], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[4], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[8], color: UIColor.red)
        }
        if checkThreeButtons(button1: buttonsCollection[2], button2: buttonsCollection[4], button3: buttonsCollection[6]){
            winnerFound(winnerShape: senderShape)
            ColorButtonTitle(button: buttonsCollection[2], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[4], color: UIColor.red)
            ColorButtonTitle(button: buttonsCollection[6], color: UIColor.red)
        }else{
            if checkEndGame(){
                showAlert(title: "End game", message: "Play Again?")
            }
        }
    }
    
    func checkThreeButtons(button1: UIButton, button2: UIButton, button3: UIButton) -> Bool{
        return button1.getTitle() == button2.getTitle() && button2.getTitle() == button3.getTitle() && button1.getTitle() != "" && button2.getTitle() != "" && button3.getTitle() != ""
    }
    
    func winnerFound(winnerShape: String){
        winnerLabel.text = "Winner: \(winnerShape)"
        showAlert(title: "\(winnerShape) is the WINNER!" , message: "Play Again?")
        isGameEnded = true
    }
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        viewDidLoad()
    }
    
    func resetGame(){
        currentShape = "O"
        viewDidLoad()
    }
    
    func computerTurn(){
        guard !isGameEnded else { return }
        guard freeButtons.sorted().last != -1 else { return }
        
        let range = 0...8
        let randomNumber = Int.random(in: range)
        
        if buttonsCollection[randomNumber].getTitle() == "" && freeButtons[randomNumber] != -1 {
            buttonsCollection[randomNumber].setTitle(currentShape, for: .normal)
            freeButtons[randomNumber] = -1
        }else{
            computerTurn()
        }
        buttonsCollection[randomNumber].isEnabled = false
        checkWinner(senderShape: currentShape)
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn{
            computerMode = true
            resetGame()
        }else{
            computerMode = false
            resetGame()
        }
    }
    
    
    func checkEndGame() -> Bool{
        print (freeButtons)
        var endGame: Bool = true
        for button in buttonsCollection{
            if button.getTitle() != ""{
                continue
            }else{
                endGame = false
            }
        }
        return endGame
    }
    
    func showAlert(title: String, message: String){
        let alertConroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: {
            UIAlertAction in
            self.resetGame()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            UIAlertAction in
            exit(0)
        })
        alertConroller.addAction(okButton)
        alertConroller.addAction(cancelButton)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.present(alertConroller, animated: true, completion: nil)
//        }
    }
    
    func ColorButtonTitle(button: UIButton, color: UIColor){
        button.setTitleColor(color, for: .normal)
        
    }
    
    
}

extension UIButton{
    func getTitle() -> String{
        return self.title(for: .normal) ?? ""
    }
}
