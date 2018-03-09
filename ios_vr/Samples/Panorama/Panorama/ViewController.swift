//
//  ViewController.swift
//  Panorama
//
//  Created by MARCEN, RAFAEL on 2/27/18.
//  Copyright © 2018 MARCEN, RAFAEL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var preambleLabel: UILabel!
    @IBOutlet weak var panoView: GVRPanoramaView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postambleLabel: UILabel!
    @IBOutlet weak var attributionTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Panorama"
        self.view.backgroundColor = UIColor.white
        
        titleLabel.text = "Machu Picchu\nWorld Heritage Site"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        subtitleLabel.text = "The world-famous citadel of the Andes"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        
        preambleLabel.text = "Machu Picchu is an Incan citadel set high in the Andes Mountains in Peru, above the Urubamba River valley."
        preambleLabel.font = UIFont.systemFont(ofSize: 16)
        
        panoView.load(UIImage(named: "andes.jpg"))
        panoView.enableCardboardButton = true
        panoView.enableFullscreenButton = true
        
        captionLabel.text = "A 360 panoramic view of Machu Picchu"
        captionLabel.font = UIFont.systemFont(ofSize: 14)
        captionLabel.textColor = UIColor.darkGray
        
        postambleLabel.text = "It is situated on a mountain ridge above the Sacred Valley which is 80 kilometres (50 mi) northwest of Cuzco and through which the Urubamba River flows. Most archaeologists believe that Machu Picchu was built as an estate for the Inca emperor Pachacuti (1438–1472). Often mistakenly referred to as the \"Lost City of the Incas\" (a title more accurately applied to Vilcabamba), it is the most familiar icon of Inca civilization.\n\nThe Incas built the estate around 1450, but abandoned it a century later at the time of the Spanish Conquest. Although known locally, it was not known to the Spanish during the colonial period and remained unknown to the outside world before being brought to international attention in 1911 by the American historian Hiram Bingham. Most of the outlying buildings have been reconstructed in order to give tourists a better idea of what the structures originally looked like. By 1976, 30% of Machu Picchu had been restored; restoration continues today.\n\nMachu Picchu was declared a Peruvian Historical Sanctuary in 1981 and a UNESCO World Heritage Site in 1983. In 2007, Machu Picchu was voted one of the New Seven Wonders of the World in a worldwide Internet poll."
        postambleLabel.font = UIFont.systemFont(ofSize: 16)
        
        let sourceText = "Source: "
        let attributedText = NSMutableAttributedString(string: "\(sourceText)Wikipedia")
        attributedText.addAttribute(.link, value: "https://en.wikipedia.org/wiki/Machu_Picchu",
                                      range: NSRange(location: sourceText.count,
                                                     length: attributedText.length - sourceText.count))
        attributionTextView.isEditable = false
        attributionTextView.attributedText = attributedText
        attributionTextView.font = UIFont.systemFont(ofSize: 16)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
