//
//  UserInfoViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/9.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    let fileManager = FileManager.default
    
    var storageSize:String = ""{
        didSet{
            self.showTheStorageSize.text = "暫存容量：\(storageSize)"
        }
    }
    
    
    @IBOutlet weak var showTheStorageSize: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDocumentSize { (success, size) in
            if success{
                self.storageSize = size
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearTheStorage(_ sender: UIButton) {
        
        clearStorage()
        
    }
    
    
    //MARK: - Remove the document's file ,storage clear
    func clearStorage(){
        
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do{
            
            let filePaths = try fileManager.contentsOfDirectory(atPath: documentURL.path)
            
            for file in filePaths{
                
                try fileManager.removeItem(at: documentURL.appendingPathComponent(file))
            }
            
            print("Storage clear ok!")
            getDocumentSize(completion: { (_, size) in
                self.storageSize = size
            })
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    //MARK: - Look document size
    typealias HandleCompletion = (Bool,String) -> Void
    func getDocumentSize(completion: HandleCompletion){
        
        // get your directory url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // check if the url is a directory
        var bool: ObjCBool = false
        if FileManager.default.fileExists(atPath: documentsDirectoryURL.path, isDirectory: &bool),
            bool.boolValue  {
            print("url is a folder url")
            
            // lets get the folder files
            do {
                let files = try FileManager.default.contentsOfDirectory(at: documentsDirectoryURL, includingPropertiesForKeys: nil, options: [])
                var folderFileSizeInBytes: UInt64 = 0
                for file in files {
                    folderFileSizeInBytes += (try? FileManager.default.attributesOfItem(atPath: file.path)[.size] as? NSNumber)??.uint64Value ?? 0
                }
                // format it using NSByteCountFormatter to display it properly
                let  byteCountFormatter =  ByteCountFormatter()
                byteCountFormatter.allowedUnits = .useMB
                byteCountFormatter.countStyle = .file
                
                let folderSizeToDisplay = byteCountFormatter.string(fromByteCount: Int64(folderFileSizeInBytes))
                
                completion(true, folderSizeToDisplay)
                print("Document size:\(folderSizeToDisplay)")  // "X,XXX,XXX bytes"
            } catch {
                print(error)
            }
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
