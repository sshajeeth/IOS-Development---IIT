//
//  RGBController.swift
//  RGB Mixer
//
//  Created by Shajeeth Suwarnarajah on 2021-02-03.
//

import UIKit

class RGBController: UIViewController {
    
    @IBOutlet weak var red_value_label: UILabel!
    @IBOutlet weak var red_slider: UISlider!
    
    @IBOutlet weak var green_value_label: UILabel!
    @IBOutlet weak var green_slider: UISlider!
    
    @IBOutlet weak var blue_value_label: UILabel!
    @IBOutlet weak var blue_slider: UISlider!
    
    @IBOutlet weak var output_img: UIImageView!
    
    
    var generated_color:Color?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColor()
    }
    
    
    private func setupColor(){
        //        Initializing the values for slider labels
        red_value_label.text = "0"
        green_value_label.text = "0"
        blue_value_label.text = "0"
        
        //        Slider Customizations
        //        Red
        red_slider.tintColor = UIColor.red
        red_slider.thumbTintColor = UIColor.red
        
        //        Green
        green_slider.tintColor = UIColor.green
        green_slider.thumbTintColor = UIColor.green
        
        //        Blue
        blue_slider.tintColor = UIColor.blue
        blue_slider.thumbTintColor = UIColor.blue
        
        
        //        Initializing the initial color of the output image
        generated_color = Color(red: 0.0, green: 0.0, blue: 0.0)
        output_img.backgroundColor = generated_color?.getColor()
        
        
        //        Color Output Image Customization
        output_img.layer.borderWidth = 1
        output_img.layer.borderColor = UIColor.darkGray.cgColor
        output_img.layer.masksToBounds = false
        output_img.layer.cornerRadius = output_img.frame.size.width/3
    }
    
    
    @IBAction func red_slide(_ sender: UISlider) {
        red_value_label.text = String(format:"%.0f", sender.value)
        generated_color?.red_value = sender.value
        output_img.backgroundColor = generated_color?.getColor()
        
    }
    
    @IBAction func green_slide(_ sender: UISlider) {
        green_value_label.text = String(format:"%.0f", sender.value)
        generated_color?.green_value = sender.value
        output_img.backgroundColor = generated_color?.getColor()
    }
    
    @IBAction func blue_slide(_ sender: UISlider) {
        
        blue_value_label.text = String(format:"%.0f", sender.value)
        generated_color?.blue_value = sender.value
        output_img.backgroundColor = generated_color?.getColor()
    }
    
    
    
}
