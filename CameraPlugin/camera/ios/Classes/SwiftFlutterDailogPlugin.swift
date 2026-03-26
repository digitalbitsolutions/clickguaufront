import Flutter
import UIKit
import AVFoundation
import AVKit
import CameraManager
import SwiftVideoGenerator
import OSLog

extension AVMutableComposition {
    
    func mergeVideo(_ urls: [URL], completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil, nil)
            return
        }
        
        let outputURL = documentDirectory.appendingPathComponent("finalvideo.mp4")

        let url = NSURL(fileURLWithPath: documentDirectory.path)
        if let pathComponent = url.appendingPathComponent("finalvideo.mp4") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                do {
                    try fileManager.removeItem(atPath: pathComponent.path)
                } catch {
                    print("Old file removing error")
                } 
            } else {
                print("FILE NOT AVAILABLE")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        // If there is only one video, we dont to touch it to save export time.
        print("Count :", urls.count)
        if let url = urls.first, urls.count == 1 {
            do {
                try FileManager().copyItem(at: url, to: outputURL)
                completion(outputURL, nil)
            } catch let error {
                completion(nil, error)
            }
            return
        }
        
        let maxRenderSize = CGSize(width: 1280.0, height: 720.0)
        var currentTime = CMTime.zero
        var renderSize = CGSize.zero
        // Create empty Layer Instructions, that we will be passing to Video Composition and finally to Exporter.
        var instructions = [AVMutableVideoCompositionInstruction]()

        urls.enumerated().forEach { index, url in
            let asset = AVAsset(url: url)
            let assetTrack = asset.tracks.first!
            
            // Create instruction for a video and append it to array.
            let instruction = AVMutableComposition.instruction(assetTrack, asset: asset, time: currentTime, duration: assetTrack.timeRange.duration, maxRenderSize: maxRenderSize)
            instructions.append(instruction.videoCompositionInstruction)
            
            // Set render size (orientation) according first video.
            if index == 0 {
                renderSize = instruction.isPortrait ? CGSize(width: maxRenderSize.height, height: maxRenderSize.width) : CGSize(width: maxRenderSize.width, height: maxRenderSize.height)
            }
            
            do {
                let timeRange = CMTimeRangeMake(start: .zero, duration: assetTrack.timeRange.duration)
                // Insert video to Mutable Composition at right time.
                try insertTimeRange(timeRange, of: asset, at: currentTime)
                currentTime = CMTimeAdd(currentTime, assetTrack.timeRange.duration)
            } catch let error {
                completion(nil, error)
            }
        }
        
        // Create Video Composition and pass Layer Instructions to it.
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = instructions
        // Do not forget to set frame duration and render size. It will crash if you dont.
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        videoComposition.renderSize = renderSize
       
        guard let exporter = AVAssetExportSession(asset: self, presetName: AVAssetExportPreset1280x720) else {
            completion(nil, nil)
            return
        }
        
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        // Pass Video Composition to the Exporter.
        exporter.videoComposition = videoComposition
        
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                completion(exporter.outputURL, nil)
            }
        }
    }
    
    static func instruction(_ assetTrack: AVAssetTrack, asset: AVAsset, time: CMTime, duration: CMTime, maxRenderSize: CGSize)
        -> (videoCompositionInstruction: AVMutableVideoCompositionInstruction, isPortrait: Bool) {
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: assetTrack)

            // Find out orientation from preffered transform.
            let assetInfo = orientationFromTransform(assetTrack.preferredTransform)
            
            // Calculate scale ratio according orientation.
            var scaleRatio = maxRenderSize.width / assetTrack.naturalSize.width
            if assetInfo.isPortrait {
                scaleRatio = maxRenderSize.height / assetTrack.naturalSize.height
            }
            
            // Set correct transform.
            var transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            transform = assetTrack.preferredTransform.concatenating(transform)
            layerInstruction.setTransform(transform, at: .zero)
            
            // Create Composition Instruction and pass Layer Instruction to it.
            let videoCompositionInstruction = AVMutableVideoCompositionInstruction()
            videoCompositionInstruction.timeRange = CMTimeRangeMake(start: time, duration: duration)
            videoCompositionInstruction.layerInstructions = [layerInstruction]
            
            return (videoCompositionInstruction, assetInfo.isPortrait)
    }
    
    static func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        
        switch [transform.a, transform.b, transform.c, transform.d] {
        case [0.0, 1.0, -1.0, 0.0]:
            assetOrientation = .right
            isPortrait = true
            
        case [0.0, -1.0, 1.0, 0.0]:
            assetOrientation = .left
            isPortrait = true
            
        case [1.0, 0.0, 0.0, 1.0]:
            assetOrientation = .up
            
        case [-1.0, 0.0, 0.0, -1.0]:
            assetOrientation = .down

        default:
            break
        }
    
        return (assetOrientation, isPortrait)
    }
    
}

public class SwiftFlutterDailogPlugin: NSObject, FlutterPlugin {
    
    
    // In App Purchase
    static var products = [SKProduct]()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bubbly_camera", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterDailogPlugin()
    let factory = FLNativeViewFactory(messenger: registrar.messenger(),channel: channel)
            registrar.register(factory, withId: "camera")

    registrar.addMethodCallDelegate(instance, channel: channel)
    
    channel.setMethodCallHandler { (call, result) in
        print("called")
if(call.method == "path"){
    
    //Checks if file exists, removes it if so.
    let path = call.arguments as! String
    if FileManager.default.fileExists(atPath: path) {
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        let fileURL = documentsUrl.appendingPathComponent("myqrcode.png")
        do {
            let imageData = try Data(contentsOf: fileURL)
            UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
        } catch {
            print("Error loading image : \(error)")
        }
        
//        do {
//            let url = URL(string: path)
//            let imageData = try Data(contentsOf: url!)
//            print(url!, imageData)
//            //UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
//        } catch {
//            print("Error loading image : \(error)")
//        }
        
//        if let url = URL(string: call.arguments as! String),
//           let data = try? Data(contentsOf: url),
//           let image = UIImage(data: data) {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
        
//        do {
//            try FileManager.default.removeItem(atPath: path)
//            print("Removed old image")
//        } catch let removeError {
//            print("couldn't remove file at path", removeError)
//        }

    }
    
//    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
//        if let url = URL(string: call.arguments as! String),
//                let data = try? Data(contentsOf: url),
//                let image = UIImage(data: data) {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }else {
//            print("11111")
//        }
//    }
    }
        if (call.method == "in_app_purchase_id") {
            print(call.arguments)
            
            
            if let productId = call.arguments as? String {
                print("In Product id")
                PKIAPHandler.shared.setProductIds(ids: [productId])
                PKIAPHandler.shared.fetchAvailableProducts {(products)   in
                    print("Product fetched")
                print(products)
                self.products = products.sorted(by: { Int($0.price) < Int($1.price) })
                
                for obj in products {
                    if obj.productIdentifier == productId {
                        PKIAPHandler.shared.purchase(product: obj) { (alert, product, transaction) in
                            if let tran = transaction, let prod = product {
                                //use transaction details and purchased product as you want
                                if tran.error == nil {
                                    print("Purchase successfully ", productId)
                                    channel.invokeMethod("is_success_purchase", arguments: true)
                                } else {
                                    print("In App Purchase error")
                                    channel.invokeMethod("is_success_purchase", arguments: false)
                                }
                            } else {
                                print("In App Purchase error")
                                channel.invokeMethod("is_success_purchase", arguments: false)
                            }
                        }
                        break
                    }
                }
                
            }
        } else {
            print("Something went wrong to product id arguments")
        }
        }
    }
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if (call.method == "getPlatformVersion") {
             result("iOS " + UIDevice.current.systemVersion)
         }
         else if (call.method == "showAlertDialog") {
             DispatchQueue.main.async {
                 let alert = UIAlertController(title: "Alert", message: "Hi, My name is flutter", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil);
             }
         }
   }
  
}

import Flutter
import UIKit
import StoreKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var channel: FlutterMethodChannel!

    init(messenger: FlutterBinaryMessenger, channel: FlutterMethodChannel) {
        self.messenger = messenger
        self.channel = channel
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        if #available(iOS 10.0, *) {
            return FLNativeView(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args,
                binaryMessenger: messenger,
                channel: channel)
        } else {
            return FLNativeView1(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args,
                binaryMessenger: messenger)
        }
    }
}
class FLNativeView1: NSObject, FlutterPlatformView {
    private var _view: UIView
   
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
    }
}
@available(iOS 10.0, *)
class FLNativeView: NSObject, FlutterPlatformView {
    
    private var _view: UIView
    
    let deviceWidth = UIScreen.main.bounds.size.width
    let deviceHeight = UIScreen.main.bounds.size.height
    
    var isBackCamera = true
    var isTouchOn = false
    
    let cameraManager = CameraManager()
    
    deinit {
        self.stopRecording()
    }
    
    var videoURLArray = [URL]()
    var isRecording = false
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        channel: FlutterMethodChannel
    ) {
        _view = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceWidth * 1.77))
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
        channel.setMethodCallHandler { (call, result) in
            print(call.method)
            if (call.method == "toggle") {
                self.cameraManager.cameraDevice = self.cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
            } else if (call.method == "flash") {
                if self.isBackCamera {
                    self.isTouchOn.toggle()
                } else {
                    self.isTouchOn = false
                }
                self.toggleTorch(on: self.isTouchOn)
            } else if (call.method == "start") {
                self.startRecording()
            } else if (call.method == "pause") {
                self.stopRecording(call: result)
            } else if (call.method == "resume") {
                self.startRecording()
            } else if (call.method == "stop") {
                self.stopRecording(isVideoCompleted: true, channel: channel, call: result)
            }  else if (call.method == "cameraDispose") {
                self.cameraManager.stopCaptureSession()
                result(true)
            } else if (call.method == "merge_audio_video") {
                print("merge_audio_video")
                
//                self.cameraManager.stopVideoRecording({ (videoURL, recordError) -> Void in
//                    print(recordError);
//                    print("stop recording")
//                    if let videoURL = videoURL {
//                        self.videoURLArray.append(videoURL)
//                    }
                    
                    AVMutableComposition().mergeVideo(self.videoURLArray) { (url, error) in
                        self.videoURLArray = []
                        let audioURL = call.arguments as! String
                        print(url ?? "", audioURL, URL(fileURLWithPath: audioURL), "=======")
                        self.mergeVideoAndAudio(videoUrl: url!, audioUrl: URL(fileURLWithPath: audioURL), shouldFlipHorizontally: false) { (error, mergeVideoURL) in
                            if error == nil {
                                channel.invokeMethod("url_path", arguments: mergeVideoURL!.path)
                            }
                        }
                    }

//                })
               

            }
            
        }
    }

    func view() -> UIView {
        return _view
    }
    
    

    func createNativeView(view _view: UIView){
        
        _view.backgroundColor = .black
        setupCameraManager()
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        if currentCameraState == .notDetermined {
            self.askCameraAndMicrophonePermission()
        } else if currentCameraState == .ready {
            addCameraToView()
        } else {
            self.askCameraAndMicrophonePermission()
        }
        
        
    }
    
    func askCameraAndMicrophonePermission() {
        cameraManager.askUserForCameraPermission { permissionGranted in
            
            if permissionGranted {
                self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    fileprivate func addCameraToView() {
        cameraManager.shouldEnableTapToFocus = false
        cameraManager.shouldEnablePinchToZoom = false
        cameraManager.shouldEnableExposure = false
        cameraManager.shouldUseLocationServices = false
        cameraManager.shouldRespondToOrientationChanges = false
        cameraManager.shouldFlipFrontCameraImage = false
        
        cameraManager.addPreviewLayerToView(self._view, newCameraOutputMode: CameraOutputMode.videoWithMic)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            
        }
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
    }
    
    func getBackCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        
        return AVCaptureVideoOrientation.portrait
        
    }
    
    //MARK:- Recording Methods
    
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = true
        
        cameraManager.writeFilesToPhoneLibrary = false
        
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
    }
    
    
    func startRecording() {
        isRecording = true
        cameraManager.startRecordingVideo()
    }
    
    func stopRecording(isVideoCompleted: Bool = false, channel: FlutterMethodChannel? = nil, call:  FlutterResult? = nil) {
        
        if isVideoCompleted && !isRecording {
            VideoGenerator.presetName = AVAssetExportPresetMediumQuality
            
            let savePathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/movie.m4v")
            if FileManager.default.fileExists(atPath: savePathUrl.path) {
                do {
                    try FileManager.default.removeItem(atPath: savePathUrl.path)
                } catch {
                    print("Remove error")
                }
            }
            
            VideoGenerator.mergeMovies(videoURLs: self.videoURLArray) { (result) in
                print("MergeMovie : \(result)")
                self.videoURLArray = []
                channel?.invokeMethod("url_path", arguments: savePathUrl.path)
            }
            return
        }
        
        cameraManager.stopVideoRecording({ (videoURL, recordError) -> Void in
            self.isRecording = false
            print("Stop recording")
//            print(recordError?.localizedDescription)
            guard let videoURL = videoURL else {
                //Handle error of no recorded video URL
                return
            }
            
            self.videoURLArray.append(videoURL)
            if call != nil {
                (call)!(true)
            }
            if isVideoCompleted {
                VideoGenerator.presetName = AVAssetExportPresetMediumQuality
                
                let savePathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/movie.m4v")
                if FileManager.default.fileExists(atPath: savePathUrl.path) {
                    do {
                        try FileManager.default.removeItem(atPath: savePathUrl.path)
                    } catch {
                        print("Remove error")
                    }
                }
                
                
                VideoGenerator.mergeMovies(videoURLs: self.videoURLArray) { (result) in
                    print(result)
                    self.videoURLArray = []
                    channel?.invokeMethod("url_path", arguments: savePathUrl.path)
                }
            }

        })
    }
    
    // Merge audio & video
    
    func mergeVideoAndAudio(videoUrl: URL,
                  audioUrl: URL,
                  shouldFlipHorizontally: Bool = false,
                  completion: @escaping (_ error: Error?, _ url: URL?) -> Void) {
        let mixComposition = AVMutableComposition()
        var mutableCompositionVideoTrack = [AVMutableCompositionTrack]()
        var mutableCompositionAudioTrack = [AVMutableCompositionTrack]()
        //@@@var mutableCompositionAudioOfVideoTrack = [AVMutableCompositionTrack]()
        //start merge
        print(audioUrl)
        let aVideoAsset = AVAsset(url: videoUrl)
        let aAudioAsset = AVAsset(url: audioUrl)
        let compositionAddVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                     preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAddAudio = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                     preferredTrackID: kCMPersistentTrackID_Invalid)!
        //@@@let compositionAddAudioOfVideo = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        //@@@let aAudioOfVideoAssetTrack: AVAssetTrack? = aVideoAsset.tracks(withMediaType: AVMediaType.audio).first
        if aAudioAsset.tracks(withMediaType: AVMediaType.audio).count == 0 {
//          MBProgressHUD.hide(for: self.view, animated: true)
//          self.view.makeToast("Something went wrong...")
          return
        }
        let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]
        // Default must have tranformation
        compositionAddVideo!.preferredTransform = aVideoAssetTrack.preferredTransform
        if shouldFlipHorizontally {
          // Flip video horizontally
          var frontalTransform: CGAffineTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
          frontalTransform = frontalTransform.translatedBy(x: -aVideoAssetTrack.naturalSize.width, y: 0.0)
          frontalTransform = frontalTransform.translatedBy(x: 0.0, y: -aVideoAssetTrack.naturalSize.width)
          compositionAddVideo!.preferredTransform = frontalTransform
        }
        mutableCompositionVideoTrack.append(compositionAddVideo!)
        mutableCompositionAudioTrack.append(compositionAddAudio)
        //@@@mutableCompositionAudioOfVideoTrack.append(compositionAddAudioOfVideo!)
        do {
          try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                            duration: aVideoAssetTrack.timeRange.duration),
                                    of: aVideoAssetTrack,
                                    at: CMTime.zero)
          //In my case my audio file is longer then video file so i took videoAsset duration
          //instead of audioAsset duration
          try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                            duration: aVideoAssetTrack.timeRange.duration),
                                    of: aAudioAssetTrack,
                                    at: CMTime.zero)
          // adding audio (of the video if exists) asset to the final composition
          //@@@      if let aAudioOfVideoAssetTrack = aAudioOfVideoAssetTrack {
          //        try mutableCompositionAudioOfVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
          //                                              duration: aVideoAssetTrack.timeRange.duration),
          //                                      of: aAudioOfVideoAssetTrack,
          //                                      at: CMTime.zero)
          //      }
        } catch {
          print(error.localizedDescription)
        }
        // Exporting
        let savePathUrl: URL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/newVideo.mp4")
        do { // delete old video
          try FileManager.default.removeItem(at: savePathUrl)
        } catch { print(error.localizedDescription) }
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)!
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = savePathUrl
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronously { () -> Void in
          switch assetExport.status {
          case AVAssetExportSession.Status.completed:
            print("success")
            completion(nil, savePathUrl)
          case AVAssetExportSession.Status.failed:
            print("failed \(assetExport.error?.localizedDescription ?? "error nil")")
            completion(assetExport.error, nil)
          case AVAssetExportSession.Status.cancelled:
            print("cancelled \(assetExport.error?.localizedDescription ?? "error nil")")
            completion(assetExport.error, nil)
          default:
            print("complete")
            completion(assetExport.error, nil)
          }
        }
      }
    
}

