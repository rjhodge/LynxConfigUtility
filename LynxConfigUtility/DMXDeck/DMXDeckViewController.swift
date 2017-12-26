//
//  DMXDeckViewController.swift
//  LynxConfigUtility
//
//  Created by Richard Hodge on 12/13/17.
//  Copyright © 2017 Binary Platypus Software. All rights reserved.
//

import Cocoa
import ORSSerial

class DMXDeckViewController: NSViewController, NSComboBoxDelegate, NSComboBoxDataSource, ORSSerialPortDelegate {

    @IBOutlet weak var sliderCombo1: NSComboBox!
    @IBOutlet weak var sliderCombo2: NSComboBox!
    @IBOutlet weak var sliderCombo3: NSComboBox!
    @IBOutlet weak var sliderCombo4: NSComboBox!
    @IBOutlet weak var sliderCombo5: NSComboBox!
    @IBOutlet weak var sliderCombo6: NSComboBox!
    @IBOutlet weak var sliderCombo7: NSComboBox!
    @IBOutlet weak var sliderCombo8: NSComboBox!
    @IBOutlet weak var sliderCombo9: NSComboBox!
    @IBOutlet weak var sliderCombo10: NSComboBox!
    @IBOutlet weak var sliderCombo11: NSComboBox!
    @IBOutlet weak var sliderCombo12: NSComboBox!
    @IBOutlet weak var sliderCombo13: NSComboBox!
    @IBOutlet weak var sliderCombo14: NSComboBox!
    @IBOutlet weak var sliderCombo15: NSComboBox!
    @IBOutlet weak var sliderCombo16: NSComboBox!

    @IBOutlet weak var verticalSlider1: NSSlider!
    @IBOutlet weak var verticalSlider2: NSSlider!
    @IBOutlet weak var verticalSlider3: NSSlider!
    @IBOutlet weak var verticalSlider4: NSSlider!
    @IBOutlet weak var verticalSlider5: NSSlider!
    @IBOutlet weak var verticalSlider6: NSSlider!
    @IBOutlet weak var verticalSlider7: NSSlider!
    @IBOutlet weak var verticalSlider8: NSSlider!
    @IBOutlet weak var verticalSlider9: NSSlider!
    @IBOutlet weak var verticalSlider10: NSSlider!
    @IBOutlet weak var verticalSlider11: NSSlider!
    @IBOutlet weak var verticalSlider12: NSSlider!
    @IBOutlet weak var verticalSlider13: NSSlider!
    @IBOutlet weak var verticalSlider14: NSSlider!
    @IBOutlet weak var verticalSlider15: NSSlider!
    @IBOutlet weak var verticalSlider16: NSSlider!

    @IBOutlet weak var sliderLabel1: NSTextField!
    @IBOutlet weak var sliderLabel2: NSTextField!
    @IBOutlet weak var sliderLabel3: NSTextField!
    @IBOutlet weak var sliderLabel4: NSTextField!
    @IBOutlet weak var sliderLabel5: NSTextField!
    @IBOutlet weak var sliderLabel6: NSTextField!
    @IBOutlet weak var sliderLabel7: NSTextField!
    @IBOutlet weak var sliderLabel8: NSTextField!
    @IBOutlet weak var sliderLabel9: NSTextField!
    @IBOutlet weak var sliderLabel10: NSTextField!
    @IBOutlet weak var sliderLabel11: NSTextField!
    @IBOutlet weak var sliderLabel12: NSTextField!
    @IBOutlet weak var sliderLabel13: NSTextField!
    @IBOutlet weak var sliderLabel14: NSTextField!
    @IBOutlet weak var sliderLabel15: NSTextField!
    @IBOutlet weak var sliderLabel16: NSTextField!

    @IBOutlet weak var linkCheckBox1: NSButton!
    @IBOutlet weak var linkCheckBox2: NSButton!
    @IBOutlet weak var linkCheckBox3: NSButton!
    @IBOutlet weak var linkCheckBox4: NSButton!
    @IBOutlet weak var linkCheckBox5: NSButton!
    @IBOutlet weak var linkCheckBox6: NSButton!
    @IBOutlet weak var linkCheckBox7: NSButton!
    @IBOutlet weak var linkCheckBox8: NSButton!
    @IBOutlet weak var linkCheckBox9: NSButton!
    @IBOutlet weak var linkCheckBox10: NSButton!
    @IBOutlet weak var linkCheckBox11: NSButton!
    @IBOutlet weak var linkCheckBox12: NSButton!
    @IBOutlet weak var linkCheckBox13: NSButton!
    @IBOutlet weak var linkCheckBox14: NSButton!
    @IBOutlet weak var linkCheckBox15: NSButton!
    @IBOutlet weak var linkCheckBox16: NSButton!

    @IBOutlet weak var sequentialChannelsButton: NSButton!
    @IBOutlet weak var linkAllChannelsButton: NSButton!
    @IBOutlet weak var isBroadcastingButton: NSButton!
    @IBOutlet weak var comPortComboBox: NSComboBox!

    var dataSource: [String] = ["Off"]
    var comPortDataSource: [String] = USBSerialDevices.getDevices()
    var serialPort: ORSSerialPort?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        dataSource = []
        for index in 0...512 {
            if index == 0 {
                dataSource.append("Off")
            } else {
                dataSource.append("\(index)")
            }
        }

        for index in 1...16 {
            if let slider = self.value(forKey: "verticalSlider\(index)") as? NSSlider {
                slider.integerValue = 0
                slider.tag = index
            }
            if let combo = self.value(forKey: "sliderCombo\(index)") as? NSComboBox {
                combo.selectItem(at: 0)
                combo.tag = index
                if sequentialChannelsButton.state == .on && index != 1 {
                    combo.isEnabled = false
                }
                combo.reloadData()
            }
            if let label = self.value(forKey: "sliderLabel\(index)") as? NSTextField {
                label.stringValue = "0"
                label.tag = index
            }
            if let link = self.value(forKey: "linkCheckBox\(index)") as? NSButton {
                link.state = .off
                link.tag = index
            }
        }
    }

    // MARK: - NSComboBox Datasource Methods
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if comboBox == comPortComboBox {
            return comPortDataSource[index]
        } else {
            return dataSource[index]
        }
    }

    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if comboBox == comPortComboBox {
            return comPortDataSource.count
        } else {
            return dataSource.count
        }
    }

    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
        if comboBox == comPortComboBox {
            if let index = comPortDataSource.index(of: string) {
                return index
            } else {
                return 0
            }
        } else {
            if let index = dataSource.index(of: string) {
                return index
            } else {
                return 0
            }
        }
    }

    // MARK: - NSComboBox Delegate Methods
    func comboBoxSelectionDidChange(_ notification: Notification) {
        updateChannelNumbers()
    }

    // MARK: - IBActions
    @IBAction func verticalSliderValueChanged(_ sender: NSSlider) {
        if let label = self.value(forKey: "sliderLabel\(sender.tag)") as? NSTextField {
            label.stringValue = "\(sender.integerValue)"
        }
        if let _ = self.value(forKey: "linkCheckBox\(sender.tag)") as? NSButton {
            updatelinkedChannels(index: sender.tag, slider: true)
        }
    }

    @IBAction func linkCheckBoxClick(_ sender: NSButton) {
        if linkAllChannelsButton.state == .on && sender.state == .off {
            linkAllChannelsButton.state = .off
        } else if linkAllChannelsButton.state == .off && sender.state == .on {
            var count = 0
            for index in 1...16 {
                guard let b = self.value(forKey: "linkCheckBox\(index)") as? NSButton, b.state == .on else {
                    continue
                }
                count += 1
            }
            if count == 16 {
                linkAllChannelsButton.state = .on
            }
        }

        if sender.state == .on {
            updatelinkedChannels(index: sender.tag, slider: false)
        }
    }

    @IBAction func sequentialChannelsButtonClick(_ sender: NSButton) {
        updateChannelNumbers()
    }

    @IBAction func linkAllChannelsButtonClick(_ sender: NSButton) {
        for index in 1...16 {
            guard let b = self.value(forKey: "linkCheckBox\(index)") as? NSButton else {
                continue
            }
            b.state = sender.state
        }
    }

    @IBAction func isBroadcastingButtonClick(_ sender: NSButton) {
        if sender.state == .on {
            sender.title = "Stop Broadcasting"
            let comPort: String = comPortComboBox.stringValue
            serialPort = ORSSerialPort(path: comPort)
            if let port = serialPort {
                port.delegate = self
                port.allowsNonStandardBaudRates = true
                port.baudRate = 250000
                port.parity = .none
                port.numberOfStopBits = 1
                timer = Timer.scheduledTimer(withTimeInterval: 0.050, repeats: true, block: { (timer) in
                    self.sendDMX()
                })
            }
        } else {
            sender.title = "Start Broadcasting"
            if let port = serialPort {
                port.close()
                serialPort = nil
            }
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }

    // MARK: - Update Functions
    func updateChannelNumbers() {
        if sequentialChannelsButton.state == .on {
            for index in 1...16 {
                if let combo = self.value(forKey: "sliderCombo\(index)") as? NSComboBox {
                    if index != 1 {
                        combo.isEnabled = false
                        if sliderCombo1.indexOfSelectedItem == 0 {
                            combo.selectItem(at: 0)
                        } else {
                            combo.selectItem(at: sliderCombo1.indexOfSelectedItem + index - 1)
                        }
                    }
                }
            }
        } else {
            for index in 1...16 {
                if let combo = self.value(forKey: "sliderCombo\(index)") as? NSComboBox {
                    combo.isEnabled = true
                }
            }
        }
    }

    func updatelinkedChannels(index: Int, slider: Bool) {
        if slider {
            guard let slider = self.value(forKey: "verticalSlider\(index)") as? NSSlider,
                let label = self.value(forKey: "sliderLabel\(index)") as? NSTextField,
                let button = self.value(forKey: "linkCheckBox\(index)") as? NSButton,
                button.state == .on else {
                    return
            }
            for i in  1...16 {
                guard i != index else {
                    continue
                }
                guard let s = self.value(forKey: "verticalSlider\(i)") as? NSSlider,
                    let l = self.value(forKey: "sliderLabel\(i)") as? NSTextField,
                    let b = self.value(forKey: "linkCheckBox\(i)") as? NSButton else {
                        continue
                }
                if b.state == .on {
                    l.stringValue = label.stringValue
                    s.integerValue = slider.integerValue
                }
            }
        } else {
            guard let slider = self.value(forKey: "verticalSlider\(index)") as? NSSlider,
                let label = self.value(forKey: "sliderLabel\(index)") as? NSTextField,
                let button = self.value(forKey: "linkCheckBox\(index)") as? NSButton,
                button.state == .on else {
                return
            }
            for i in  1...16 {
                guard i != index else {
                    continue
                }
                guard let s = self.value(forKey: "verticalSlider\(i)") as? NSSlider,
                    let l = self.value(forKey: "sliderLabel\(i)") as? NSTextField,
                    let b = self.value(forKey: "linkCheckBox\(i)") as? NSButton else {
                    continue
                }
                if b.state == .on {
                    label.stringValue = l.stringValue
                    slider.integerValue = s.integerValue
                    return
                }
            }
        }
    }

    // MARK: - Send DMX
    func sendDMX() {
        var output: [String] = []
        let length: Int = 512
        let lsb: Int = (length + 1) & 0xFF
        let msb: Int = ((length + 1) >> 8) & 0xff
        output.append("7E")              // Start of Message
        output.append("06")              // DMX Send
        output.append(intToHex(lsb))     // Length LSB
        output.append(intToHex(msb))     // Length MSB
        output.append("00")              // DMX Start
        for _ in 1 ... length {          // DMX Packet
            output.append("00")
        }
        output.append("E7")              // End of Message
        for i in  1...16 {
            guard let combo = self.value(forKey: "sliderCombo\(i)") as? NSComboBox,
                let slider = self.value(forKey: "verticalSlider\(i)") as? NSSlider else {
                    continue
            }
            if combo.indexOfSelectedItem != 0 {
                let channel = combo.indexOfSelectedItem + 4
                let intensity: String = intToHex(slider.integerValue)
                output[channel] = intensity
            }
        }
        let outputString: String = output.joined(separator: "")
        let outputData: Data = dataWithHexString(hex: outputString)
        guard let port = serialPort else {
            return
        }
        port.open()
        port.send(outputData)
        port.close()
    }

    func intToHex(_ int: Int, bytes: Int = 2) -> String {
        return String(format:("%0\(bytes)X"), int)
    }

    func dataWithHexString(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }

    // MARK: ORSSerialPortDelegate
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        self.serialPort = nil
    }

    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print(error)
    }

    func serialPort(_ serialPort: ORSSerialPort, requestDidTimeout request: ORSSerialRequest) {
        print("timeout")
    }

}
