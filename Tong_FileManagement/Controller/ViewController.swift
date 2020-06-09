//
//  ViewController.swift
//  Tong_FileManagement
//
//  Created by Tong Yi on 5/17/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var fileNameTF: UITextField!
    @IBOutlet var editorTV: UITextView!
    @IBOutlet var comparedFileTF: UITextField!
    
    var fileName = ""
    var editor = ""
    let fileManager = FileManager.default
    let fM = FileManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI()
    {
        fileNameTF.delegate = self
        editorTV.delegate = self
        comparedFileTF.delegate = self
    }
    
    //MARK: - create Document Directory URL
    func documentDirURL() -> URL
    {
        var documentDirURL: URL?
        do
        {
            documentDirURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        }
        catch
        {
            print(error.localizedDescription)
            alert("ERROR!", "\(error.localizedDescription)")
        }
        
        return documentDirURL!
    }
    
    //MARK: - Button actions

    @IBAction func searchButtonTapped(_ sender: Any)
    {
        editorTV.text = nil
        if checkFileName()
        {
            let fileURL = documentDirURL().appendingPathComponent(fileName)
            if fileManager.fileExists(atPath: fileURL.path)
            {
                readFile(fileURL)
            }
            else
            {
                alert("WARNING!", "The file is not exist!")
            }
        }
        else
        {
            alert("WARNING!", "Please enter a file name!")
        }
    }
    
    @IBAction func createFileButtonTapped(_ sender: Any)
    {
        if checkFileName()
        {
            let fileURL = documentDirURL().appendingPathComponent(fileName)
            createFile(fileURL)
        }
        else
        {
            alert("WARNING!", "Please enter a file name!")
        }
    }
    
    @IBAction func removeFileButtonTapped(_ sender: Any)
    {
        if checkFileName()
        {
            let fileURL = documentDirURL().appendingPathComponent(fileName)
            if fileManager.fileExists(atPath: fileURL.path)
            {
                deleteFile(fileURL)
            }
            else
            {
                alert("WARNING!", "The file is not exist!")
            }
        }
        else
        {
            alert("WARNING!", "Please enter the file name that you want to delete!")
        }
    }
    
    @IBAction func writeFileButtonTapped(_ sender: Any)
    {
        if checkFileName()
        {
            writeFile(fileName)
            alert("NOTICE!", "Write successfully!")
        }
        else
        {
            alert("WARNING!", "Please enter the file name that you want to save!")
        }
    }
    
    @IBAction func readFileButtonTapped(_ sender: Any)
    {
        if checkFileName()
        {
            let fileURL = documentDirURL().appendingPathComponent(fileName)
            if fileManager.fileExists(atPath: fileURL.path)
            {
                readFile(fileURL)
                alert("NOTICE!", "Read successfully!")
            }
            else
            {
                alert("WARNING!", "The file is not exist!")
            }
        }
        else
        {
            alert("WARNING!", "Please enter the file name that you want to read!")
        }
    }
    
    @IBAction func moveFileButtonTapped(_ sender: Any)
    {
        if checkFileName()
        {
            let oldURL = documentDirURL().appendingPathComponent(fileName)
            let newURL = documentDirURL().appendingPathComponent("data/\(fileName)")
            if fileManager.fileExists(atPath: oldURL.path)
            {
                moveFile(oldURL, newURL)
            }
            else
            {
                alert("WARNING!", "The file is not exist!")
            }
        }
        else
        {
            alert("WARNING!", "Please enter the file name that you want to move!")
        }
    }
    
    @IBAction func copyFileButtonTapped(_ sender: Any)
    {
        if checkFileName()
        {
            let originalURL = documentDirURL().appendingPathComponent(fileName)
            let copyURL = documentDirURL().appendingPathComponent("copy.txt")
            if fileManager.fileExists(atPath: originalURL.path)
            {
                copyFile(originalURL, copyURL)
            }
            else
            {
                alert("WARNING!", "The file is not exist!")
            }
        }
        else
        {
            alert("WARNING!", "Please enter the file name that you want to copy!")
        }
    }
    
    @IBAction func filePermissionButtonTapped(_ sender: Any)
    {
        if checkFileName()
        {
            let filePath = documentDirURL().appendingPathComponent(fileName).path
            
            if fileManager.fileExists(atPath: filePath)
            {
                filePermission(filePath)
            }
            else
            {
                alert("WARNING!", "The file is not exist!")
            }
        }
        else
        {
            alert("WARNING!", "Please enter the file name that you want to check the permission!")
        }
    }
    
    @IBAction func eqaulityCheckButtonTapped(_ sender: Any)
    {
        if checkFileName(), let comparedFile = comparedFileTF.text, !comparedFile.isEmpty
        {
            let pathComponent1 = documentDirURL().appendingPathComponent(fileName).path
            let pathComponent2 = documentDirURL().appendingPathComponent(comparedFile).path
            
            if fileManager.contentsEqual(atPath: pathComponent1, andPath: pathComponent2)
            {
                alert("NOTICE!", "These two files have same contents!")
            }
            else
            {
                alert("NOTICE!", "These two files's contents are different!")
            }
        }
        else
        {
            alert("WARNING!", "Please enter the file names that you want to compared!")
        }
    }
    
    @IBAction func fileistingButtonTapped(_ sender: Any)
    {
        let filePath = documentDirURL().path
        do
        {
            let fileList = try fileManager.contentsOfDirectory(atPath: filePath)
            clear()
            for item in fileList
            {
                editorTV.text.append("\(item) \n")
            }
            alert("NOTICE", "Finished print the file List!")
        }
        catch
        {
            alert("ERROR!", "\(error.localizedDescription)")
        }
    }
    
    @IBAction func exitFileButtonTapped(_ sender: Any)
    {
        clear()
        alert("Exit", "successfully!")
    }
    
    //MARK: - check File Name is nil or not
    
    func checkFileName() -> Bool
    {
        guard let text = fileNameTF.text, !text.isEmpty else { return false }
        fileName = fileNameTF.text!
        return true
    }
    
    //MARK: - Edit File Methods
    
    func createFile(_ fileURL: URL)
    {
        self.fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        self.alert("Succssefully!", "The file \(self.fileName) has been created! \n You can edit it in the following field.")
    }
    
    // read File method
    func readFile(_ readFileURL: URL)
    {
        var readData = ""
        do
        {
            readData = try String(contentsOf: readFileURL)
        }
        catch
        {
            alert("ERROR!", "\(error.localizedDescription)")
        }
        
        if !readData.isEmpty
        {
            editorTV.text = readData
        }
        else
        {
            alert("NOTICE!", "This is an empty file!")
        }
    }
    
    // write File method
    func writeFile(_ writeFileName: String)
    {
        guard let writeString = editorTV.text, !writeString.isEmpty else {
            alert("WARNING", "The edit area is empty!")
            return
        }
        
        let fileURL = documentDirURL().appendingPathComponent(writeFileName)
        do
        {
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch
        {
            alert("ERROR!", "\(error.localizedDescription)")
        }
        
    }
    
    //move File method
    func moveFile(_ oldUrl: URL, _ newUrl: URL)
    {
        do
        {
            try fileManager.moveItem(at: oldUrl, to: newUrl)
        }
        catch
        {
            alert("ERROR!", "\(error.localizedDescription)")
        }
    }
    
    //copy File method
    func copyFile(_ originalUrl: URL, _ copyUrl: URL)
    {
        do
        {
            try fileManager.copyItem(at: originalUrl, to: copyUrl)
        }
        catch
        {
            alert("ERROR!", "\(error.localizedDescription)")
        }
    }
    
    // File permission Method
    func filePermission(_ filePath: String)
    {
        var filePermission: String = ""
        if (fileManager.isWritableFile(atPath: filePath)){
            filePermission = filePermission.appending("File is writable\n") as String
        }
        if(fileManager.isReadableFile(atPath: filePath)){
            filePermission = filePermission.appending("File is readable\n") as String
        }
        if(fileManager.isExecutableFile(atPath: filePath)){
            filePermission = filePermission.appending("File is executable\n") as String
        }
        
        alert("PERMISSION", "\(filePermission)")
    }
    
    // remove File method
    func deleteFile(_ deleteFileURL: URL)
    {
        do
        {
            try fM.removeItem(at: deleteFileURL)
        }
        catch
        {
            alert("ERROR!", "\(error.localizedDescription)")
        }
        if !fM.fileExists(atPath: deleteFileURL.path)
        {
            alert("NOTICE!", "Delete successfully!")
            clear()
        }
    }
    
    // clear UI
    func clear()
    {
        fileNameTF.text = nil
        editorTV.text = nil
    }
}

// MARK: - Alert Method

extension ViewController
{
    func alert(_ titleToShow: String, _ messageToShow: String)
    {
        let alertController = UIAlertController(title: titleToShow, message: messageToShow, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        {
            (action) -> Void in
            NSLog ("OK Pressed.")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - text view and text field delegation => return hide the keyboard

extension ViewController: UITextFieldDelegate, UITextViewDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            editorTV.resignFirstResponder()
            return false
        }
        return true
    }
}
