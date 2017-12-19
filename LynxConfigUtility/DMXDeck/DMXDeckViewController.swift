//
//  DMXDeckViewController.swift
//  LynxConfigUtility
//
//  Created by Richard Hodge on 12/13/17.
//  Copyright © 2017 Binary Platypus Software. All rights reserved.
//

import Cocoa

class DMXDeckViewController: NSViewController, NSComboBoxDelegate, NSComboBoxDataSource {

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

    var dataSource: [String] = ["Off"]

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
        return dataSource[index]
    }

    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return dataSource.count
    }

    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
        if let index = dataSource.index(of: string) {
            return index
        } else {
            return 0
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
}
