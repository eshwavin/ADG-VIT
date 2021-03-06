//
//  DataManager.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 29/01/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DataManager {
    
    // MARK: - News
    
    func getNews(child: String, completion: @escaping (_ result: [String]) -> Void, inCaseOfError: @escaping () -> Void) {
        
        var data: [String] = []
        
        let headlinesReference = FIRDatabase.database().reference().child("headlines")
        
        headlinesReference.child(child).observe(FIRDataEventType.value, with: { (snapshot) in
            if !(snapshot.value is NSNull) {
                let dictionary = snapshot.value! as! [String: String]
                
                let keys = dictionary.keys.sorted(by: { $0 < $1})
                
                data = []
                
                for key in keys {
                    data.append(dictionary[key]!)
                }
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
                
            }
        }) { (error) in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                DispatchQueue.main.async {
                    inCaseOfError()
                }
            }
        }
        
    }
    
    // MARK: - Weather
    
    func weatherAPI(_ urlString: String,  completion: @escaping (_ result: [String: AnyObject]) -> Void, inCaseOfError: @escaping () -> Void) {
        
        let config = URLSessionConfiguration.ephemeral
        
        let session = URLSession(configuration: config)
        
        let url = URL(string: urlString)!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    DispatchQueue.main.async {
                        inCaseOfError()
                    }
                }

            }
            else {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary,
                        let weather = json["weather"] as? JSONArray,
                        let main = json["main"] as? JSONDictionary,
                        let temp = main["temp"] as? Float,
                        let item = weather[0] as? JSONDictionary,
                        let description = item["description"] as? String,
                        let icon = item["icon"] as? String {
                        
                        var result = [String: AnyObject]()
                        
                        result["description"] = description as AnyObject
                        result["icon"] = icon as AnyObject
                        result["temp"] = temp as AnyObject
                        
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                            DispatchQueue.main.async {
                                completion(result)
                            }
                        }
                        
                    }
                }
                
                catch {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                        DispatchQueue.main.async {
                            inCaseOfError()
                        }
                    }
                }
                
            }
        }
        
        task.resume()
        
    }
    
//    func getVideoImage(_ imageIconUrl: String, imageView: UIImageView, inCaseOfError: @escaping () -> Void) {
//        
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
//            
//            let data = NSData(contentsOf: NSURL(string: imageIconUrl)! as URL)
//            
//            var image: UIImage?
//            if data != nil {
//                image = UIImage(data: data! as Data)
//            }
//            else {
//                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
//                    DispatchQueue.main.async {
//                        inCaseOfError()
//                    }
//                }
//            }
//            
//            DispatchQueue.main.async {
//                imageView.image = image
//            }
//            
//            
//        }
//        
//    }
//    
//    func getVideoImageWithAlwaysTemplateRendering(_ imageIconUrl: String, imageView: UIImageView, inCaseOfError: @escaping () -> Void) {
//        
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
//            
//            let data = NSData(contentsOf: NSURL(string: imageIconUrl)! as URL)
//            
//            var image: UIImage?
//            if data != nil {
//                image = UIImage(data: data! as Data)!.withRenderingMode(.alwaysTemplate)
//            }
//            else {
//                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
//                    DispatchQueue.main.async {
//                        inCaseOfError()
//                    }
//                }
//            }
//            
//            DispatchQueue.main.async {
//                imageView.image = image
//                imageView.tintColor = UIColor.white
//            }
//            
//            
//        }
//        
//    }
    
    // MARK: - Projects
    
    func getProjects(child: String, completion: @escaping (_ result: [[String: String]]) -> Void, inCaseOfError: @escaping () -> Void) {
        
        
        let projectsReference = FIRDatabase.database().reference().child("projects")
        
        projectsReference.child(child).observe(FIRDataEventType.value, with: { (snapshot) in
            
            if !(snapshot.value is NSNull) {
                
                let dictionary = snapshot.value! as! [String: JSONDictionary]
                
                var data: [[String: String]] = []
                
                for dict in dictionary {
                    data.append(dict.value as! [String: String])
                }
                
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }

                
                
            }
            
        }) { (error) in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                DispatchQueue.main.async {
                    inCaseOfError()
                }
            }
        }
        
    }
    
    func getProjectsImage(url: String, completion: @escaping (_ image: UIImage) -> Void) {
        
        let firebaseStorageReference = FIRStorage.storage().reference(forURL: "gs://adg-vit-83017.appspot.com")
        
        firebaseStorageReference.child("projects").child(url).data(withMaxSize: 1024 * 1024) { (data, error) in
            if error == nil {
                let image = UIImage(data: data!)!
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
            else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    DispatchQueue.main.async {
                        completion(UIImage(named: "general2")!)
                    }
                }
            }
        }
        
        
    }
    
    // MARK: Events

    func getEvents(child: String, completion: @escaping (_ result: [[String: AnyObject]]) -> Void, inCaseOfError: @escaping () -> Void) {
        
        
        let projectsReference = FIRDatabase.database().reference().child("events")
        
        projectsReference.child(child).observe(FIRDataEventType.value, with: { (snapshot) in
            
            if !(snapshot.value is NSNull) {
                
                let dictionary = snapshot.value! as! [String: JSONDictionary]
                
                var data: [[String: AnyObject]] = []
                
                for dict in dictionary {
                    data.append(dict.value)
                }
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
                
                
                
            }
            
        }) { (error) in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                DispatchQueue.main.async {
                    inCaseOfError()
                }
            }
        }
        
    }
    
    func getEventsImage(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        let firebaseStorageReference = FIRStorage.storage().reference(forURL: "gs://adg-vit-83017.appspot.com")
        
        firebaseStorageReference.child("events").child(url).data(withMaxSize: 1024 * 1024) { (data, error) in
            if error == nil {
                let image = UIImage(data: data!)!
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
            else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
        
        
    }

    
}
