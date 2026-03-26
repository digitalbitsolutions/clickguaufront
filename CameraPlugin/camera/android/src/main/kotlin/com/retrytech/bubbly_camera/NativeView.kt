package com.retrytech.bubbly_camera

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Matrix
import android.graphics.RectF
import android.graphics.SurfaceTexture
import android.hardware.camera2.*
import android.media.CamcorderProfile
import android.media.MediaRecorder
import android.os.Environment
import android.os.Handler
import android.os.HandlerThread
import android.os.Looper
import android.util.Log
import android.util.Size
import android.view.LayoutInflater
import android.view.Surface
import android.view.TextureView.SurfaceTextureListener
import android.view.View
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.FileProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.io.File
import java.io.IOException
import java.util.*
import java.util.concurrent.Semaphore
import java.util.concurrent.TimeUnit


internal class NativeView(
    private val context: Context?,
    id: Int,
    creationParams: Map<String?, Any?>?,
    private val channel: MethodChannel
) :
    PlatformView, MethodChannel.MethodCallHandler {

    private var mBackgroundThread: HandlerThread? = null
    private val view: View =
        LayoutInflater.from(context).inflate(R.layout.item_camera_view, null, false)

    override fun getView(): View {
        return view
    }

    override fun dispose() {
        stopBackgroundThread()
        closeCamera()
    }

    private val methodChannel: MethodChannel = channel

    private var mTextureView: AutoFitTextureView? = null

    init {
        var fdf: FileProvider
        methodChannel.setMethodCallHandler(this)
        mTextureView = view.findViewById(R.id.viewFinder)
    }

    private fun startCamera() {
        if (mTextureView?.isAvailable == true) {
            mTextureView?.let { openCamera(it.width, it.height) }
            return
        }
        mTextureView?.surfaceTextureListener = object : SurfaceTextureListener {
            override fun onSurfaceTextureAvailable(
                surface: SurfaceTexture,
                width: Int,
                height: Int
            ) {
                openCamera(width, height)
            }

            override fun onSurfaceTextureSizeChanged(
                surface: SurfaceTexture,
                width: Int,
                height: Int
            ) {

            }

            override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean {
                return true
            }

            override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {

            }
        }
    }


    override fun onFlutterViewAttached(flutterView: View) {
        startBackgroundThread()
        startCamera()
    }


    override fun onFlutterViewDetached() {
        stopBackgroundThread()
        closeCamera()
    }

    var isFlashOn = false
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == null) return
        if (call.method != null && call.method == "start") {
            startRecordingVideo()
            return
        }

        if (call.method != null && call.method == "pause") {
            mMediaRecorder?.pause()
            return
        }

        if (call.method != null && call.method == "resume") {
            mMediaRecorder?.resume()
            return
        }

        if (call.method != null && call.method == "stop") {
            mMediaRecorder?.stop()
            channel.invokeMethod("url_path", getOutputMediaFile()?.absolutePath)
            return
        }

        if (call.method != null && call.method == "toggle") {
            cameraFacing = if (cameraFacing == 0) {
                1
            } else {
                0
            }
            stopBackgroundThread()
            closeCamera()
            startBackgroundThread()
            startCamera()
            return
        }

        if (call.method != null && call.method == "flash") {
            isFlashOn = !isFlashOn
            stopBackgroundThread()
            closeCamera()
            startBackgroundThread()
            startCamera()
            return
        }
    }

    /**
     * Tries to open a [CameraDevice]. The result is listened by `mStateCallback`.
     */
    private val mCameraOpenCloseLock = Semaphore(1)


    private var mSensorOrientation: Int? = null
    private var mPreviewBuilder: CaptureRequest.Builder? = null

    private var mVideoSize: Size? = null
    private var mPreviewSize: Size? = null
    private var cameraFacing = 0
    private fun openCamera(width: Int, height: Int) {
        val manager = context?.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        try {
            Log.d("TAG", "tryAcquire")
            if (!mCameraOpenCloseLock.tryAcquire(2500, TimeUnit.MILLISECONDS)) {
                throw RuntimeException("Time out waiting to lock camera opening.")
            }
            /**
             * default front camera will activate
             */
            val cameraId = manager.cameraIdList[cameraFacing]
            val characteristics = manager.getCameraCharacteristics(cameraId)
            val map = characteristics
                .get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
            mSensorOrientation = characteristics.get(CameraCharacteristics.SENSOR_ORIENTATION)
            if (map == null) {
                throw RuntimeException("Cannot get available preview/video sizes")
            }

            mVideoSize = chooseVideoSize(map.getOutputSizes(MediaRecorder::class.java))
            mPreviewSize = mVideoSize?.let {
                chooseOptimalSize(
                    map.getOutputSizes(SurfaceTexture::class.java),
                    width, height, it
                )
            }
            mPreviewSize?.let {
                it.height.let { it1 ->
                    it.width.let { it2 ->
                        mTextureView?.setAspectRatio(
                                it1,
                                it2
                        )
                    }
                }
            }
//            configureTransform(width, height)
            mMediaRecorder = MediaRecorder()
            if (ActivityCompat.checkSelfPermission(
                    context,
                    Manifest.permission.CAMERA
                ) != PackageManager.PERMISSION_GRANTED
            ) {

                return
            }
            manager.openCamera(cameraId, mStateCallback, null)


        } catch (e: CameraAccessException) {
            Log.e("TAG", "openCamera: Cannot access the camera.")
        } catch (e: NullPointerException) {
            Log.e("TAG", "Camera2API is not supported on the device.")
        } catch (e: InterruptedException) {
            throw RuntimeException("Interrupted while trying to lock camera opening.")
        }
    }

    private fun closeCamera() {
        try {
            mCameraOpenCloseLock.acquire()
            closePreviewSession()
            if (null != mCameraDevice) {
                mCameraDevice!!.close()
                mCameraDevice = null
            }
            if (null != mMediaRecorder) {
                mMediaRecorder!!.release()
                mMediaRecorder = null
            }
        } catch (e: InterruptedException) {
            throw java.lang.RuntimeException("Interrupted while trying to lock camera closing.")
        } finally {
            mCameraOpenCloseLock.release()
        }
    }

    private var mCameraDevice: CameraDevice? = null
    private val mStateCallback: CameraDevice.StateCallback = object : CameraDevice.StateCallback() {
        override fun onOpened(@NonNull cameraDevice: CameraDevice) {
            mCameraDevice = cameraDevice
            startPreview()
            mCameraOpenCloseLock.release()

            if (null != mTextureView) {
//                configureTransform(mTextureView!!.width, mTextureView!!.height)
            }
        }

        override fun onDisconnected(@NonNull cameraDevice: CameraDevice) {
            mCameraOpenCloseLock.release()
            cameraDevice.close()
            mCameraDevice = null
        }

        override fun onError(@NonNull cameraDevice: CameraDevice, error: Int) {
            mCameraOpenCloseLock.release()
            cameraDevice.close()
            mCameraDevice = null
        }
    }

    private var mBackgroundHandler: Handler? = Handler(Looper.getMainLooper())
    private fun startPreview() {
        if (null == mCameraDevice || !mTextureView!!.isAvailable || null == mPreviewSize) {
            return
        }
        try {
            closePreviewSession()
            val texture = mTextureView!!.surfaceTexture!!
            texture.setDefaultBufferSize(mPreviewSize!!.width, mPreviewSize!!.height)
            mPreviewBuilder = mCameraDevice!!.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
            val surfaces: MutableList<Surface> = ArrayList()

            /**
             * Surface for the camera preview set up
             */

            val previewSurface = Surface(texture)
            surfaces.add(previewSurface)
            mPreviewBuilder!!.addTarget(previewSurface)

            mCameraDevice!!.createCaptureSession(
                listOf(previewSurface),
                object : CameraCaptureSession.StateCallback() {
                    override fun onConfigured(@NonNull session: CameraCaptureSession) {
                        mPreviewSession = session
                        updatePreview()
                    }

                    override fun onConfigureFailed(@NonNull session: CameraCaptureSession) {
                        Log.e("TAG", "onConfigureFailed: Failed ")
                    }
                }, mBackgroundHandler
            )
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
    }

    private fun updatePreview() {
        if (null == mCameraDevice) {
            return
        }
        try {
            if (isFlashOn) {
                mPreviewBuilder?.set(CaptureRequest.FLASH_MODE, CameraMetadata.FLASH_MODE_TORCH)
            } else {
                mPreviewBuilder?.set(CaptureRequest.FLASH_MODE, CameraMetadata.FLASH_MODE_OFF)
            }
            setUpCaptureRequestBuilder(mPreviewBuilder!!)
            val thread = HandlerThread("CameraPreview")
            thread.start()
            mPreviewSession!!.setRepeatingRequest(
                mPreviewBuilder!!.build(),
                null,
                mBackgroundHandler
            )

        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
    }

    private fun setUpCaptureRequestBuilder(builder: CaptureRequest.Builder) {
        builder.set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO)
    }

    private var mPreviewSession: CameraCaptureSession? = null

    private fun closePreviewSession() {
        if (mPreviewSession != null) {
            mPreviewSession?.close()
            mPreviewSession = null
        }
    }

    private fun configureTransform(viewWidth: Int, viewHeight: Int) {

        if (null == mTextureView || null == mPreviewSize) {
            return
        }
//        val rotation = context.windowManager.defaultDisplay.rotation
        val matrix = Matrix()
        val viewRect = RectF(0F, 0F, viewWidth.toFloat(), viewHeight.toFloat())
        val bufferRect = RectF(
            0F, 0F, mPreviewSize!!.height.toFloat(),
            mPreviewSize!!.width.toFloat()
        )
        val centerX = viewRect.centerX()
        val centerY = viewRect.centerY()
//        if (Surface.ROTATION_90 == rotation || Surface.ROTATION_270 == rotation) {
        bufferRect.offset(centerX - bufferRect.centerX(), centerY - bufferRect.centerY())
        matrix.setRectToRect(viewRect, bufferRect, Matrix.ScaleToFit.CENTER)
        val scale = Math.max(
            viewHeight.toFloat() / mPreviewSize!!.height,
            viewWidth.toFloat() / mPreviewSize!!.width
        )
        matrix.postScale(scale, scale, centerX, centerY)
        matrix.postRotate((90 * (90 - 2)).toFloat(), centerX, centerY)
//        }
        mTextureView!!.setTransform(matrix)

    }

    private fun chooseVideoSize(choices: Array<Size>): Size? {
        for (size in choices) {
            if (1920 == size.width && 1080 == size.height) {
                return size
            }
        }
        for (size in choices) {
            if (size.width == size.height * 4 / 3 && size.width <= 1080) {
                return size
            }
        }
        Log.e("TAG", "Couldn't find any suitable video size")
        return choices[choices.size - 1]
    }

    private fun chooseOptimalSize(
        choices: Array<Size>,
        width: Int,
        height: Int,
        aspectRatio: Size
    ): Size? {
        val bigEnough: MutableList<Size> = ArrayList()
        val w = aspectRatio.width
        val h = aspectRatio.height
        for (option in choices) {
            if (option.height == option.width * h / w && option.width >= width && option.height >= height) {
                bigEnough.add(option)
            }
        }
        return if (bigEnough.size > 0) {
            Collections.min(bigEnough, CompareSizesByArea())
        } else {
            Log.e("TAG", "Couldn't find any suitable preview size")
            choices[0]
        }
    }

    internal class CompareSizesByArea : Comparator<Size?> {

        override fun compare(o1: Size?, o2: Size?): Int {
            return java.lang.Long.signum(
                o1!!.width.toLong() * o1!!.height -
                        o2!!.width.toLong() * o2!!.height
            )
        }
    }


    private var mCurrentFile: File? = null
    private val VIDEO_DIRECTORY_NAME = "AndroidWave"
    private var mMediaRecorder: MediaRecorder? = null

    @Throws(IOException::class)
    private fun setUpMediaRecorder() {
        mMediaRecorder?.setAudioSource(MediaRecorder.AudioSource.MIC)
        mMediaRecorder?.setVideoSource(MediaRecorder.VideoSource.SURFACE)
        mMediaRecorder?.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        /**
         * create video output file
         */
        mCurrentFile = getOutputMediaFile()
        /**
         * set output file in media recorder
         */
        mMediaRecorder?.setOutputFile(mCurrentFile?.getAbsolutePath())
        val profile = CamcorderProfile.get(CamcorderProfile.QUALITY_720P)
        mMediaRecorder?.setVideoFrameRate(profile.videoFrameRate)
        mMediaRecorder?.setVideoSize(profile.videoFrameWidth, profile.videoFrameHeight)
        mMediaRecorder?.setVideoEncodingBitRate(profile.videoBitRate)
        mMediaRecorder?.setVideoEncoder(MediaRecorder.VideoEncoder.H264)
        mMediaRecorder?.setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
        mMediaRecorder?.setAudioEncodingBitRate(profile.audioBitRate)
        mMediaRecorder?.setAudioSamplingRate(profile.audioSampleRate)
        mMediaRecorder?.setOrientationHint(90)
        mMediaRecorder?.prepare()
    }

    fun startRecordingVideo() {
        if (null == mCameraDevice || !mTextureView!!.isAvailable || null == mPreviewSize) {
            return
        }
        try {
            closePreviewSession()
            setUpMediaRecorder()
            val texture = mTextureView!!.surfaceTexture!!
            texture.setDefaultBufferSize(mPreviewSize!!.width, mPreviewSize!!.height)
            mPreviewBuilder = mCameraDevice!!.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
            val surfaces: MutableList<Surface> = ArrayList()

            /**
             * Surface for the camera preview set up
             */
            val previewSurface = Surface(texture)
            surfaces.add(previewSurface)
            mPreviewBuilder!!.addTarget(previewSurface)
            //MediaRecorder setup for surface
            val recorderSurface = mMediaRecorder!!.surface
            surfaces.add(recorderSurface)
            mPreviewBuilder!!.addTarget(recorderSurface)
            // Start a capture session
            mCameraDevice!!.createCaptureSession(
                surfaces,
                object : CameraCaptureSession.StateCallback() {
                    override fun onConfigured(cameraCaptureSession: CameraCaptureSession) {
                        mPreviewSession = cameraCaptureSession
                        updatePreview()
//                    getActivity().runOnUiThread({
//                        mIsRecordingVideo = true
                        // Start recording
                        mMediaRecorder!!.start()
//                    })
                    }

                    override fun onConfigureFailed(cameraCaptureSession: CameraCaptureSession) {
                        Log.e("TAG", "onConfigureFailed: Failed")
                    }
                },
                mBackgroundHandler
            )
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    @Throws(Exception::class)
    fun stopRecordingVideo() {
        try {
//            mPreviewSession!!.stopRepeating()
//            mPreviewSession!!.abortCaptures()
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
        // Stop recording
        mMediaRecorder!!.stop()
        mMediaRecorder!!.reset()
        stopBackgroundThread()
        closeCamera()
        startBackgroundThread()

        startCamera()
    }

    private fun startBackgroundThread() {
        mBackgroundThread = HandlerThread("CameraBackground")
        mBackgroundThread?.start()
        mBackgroundHandler = mBackgroundThread?.looper?.let { Handler(it) }
    }


    private fun stopBackgroundThread() {
        mBackgroundThread?.quitSafely()
        try {
            mBackgroundThread?.join()
            mBackgroundThread = null
            mBackgroundHandler = null
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }
    }

    private fun getOutputMediaFile(): File? {
        // External sdcard file location
//        val mediaStorageDir = File(
//            Environment.getExternalStorageDirectory(),
//            VIDEO_DIRECTORY_NAME
//        )
//        // Create storage directory if it does not exist
//        if (!mediaStorageDir.exists()) {
//            if (!mediaStorageDir.mkdirs()) {
//                Log.d(
//                    "TAG", "Oops! Failed create "
//                            + VIDEO_DIRECTORY_NAME + " directory"
//                )
//                return null
//            }
//        }
        val state: String = Environment.getExternalStorageState()
        val filesDir: File? = if (Environment.MEDIA_MOUNTED == state) {
            // We can read and write the media
            context?.getExternalFilesDir(null)
        } else {
            // Load another directory, probably local memory
            context?.filesDir
        }
        return File(filesDir, "finalvideo.mp4")
    }


}
