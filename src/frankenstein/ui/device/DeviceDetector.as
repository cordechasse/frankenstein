/*
 * Copyright © CorDeChasse 1999-2011
 */
 

package frankenstein.ui.device {
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import frankenstein.events.DeviceDetectionEvent;


	/**
	 *  Une caméra valide est détectée.
	 *  @eventType frankenstein.events.DeviceDetectionEvent.CAMERA_DETECTED
	 */
	[Event(name="cameraDetected", type="frankenstein.events.DeviceDetectionEvent")]

	/**
	 *  L'utilisateur a refusé l'utilisation de sa caméra.
	 *  @eventType frankenstein.events.DeviceDetectionEvent.CAMERA_DENIED
	 */
	[Event(name="cameraDenied", type="frankenstein.events.DeviceDetectionEvent")]

	/**
	 *  Aucune caméra valide n'a été trouvée.
	 *  @eventType frankenstein.events.DeviceDetectionEvent.CAMERA_NOT_FOUND
	 */
	[Event(name="cameraNotFound", type="frankenstein.events.DeviceDetectionEvent")]

	/**
	 *  Un microphone valide est détecté.
	 *  @eventType frankenstein.events.DeviceDetectionEvent.MICROPHONE_DETECTED
	 */
	[Event(name="cameraDetected", type="frankenstein.events.DeviceDetectionEvent")]

	/**
	 *  L'utilisateur a refusé l'utilisation de son microphone.
	 *  @eventType frankenstein.events.DeviceDetectionEvent.MICROPHONE_DENIED
	 */
	[Event(name="cameraDenied", type="frankenstein.events.DeviceDetectionEvent")]

	/**
	 *  Aucun microphone valide n'a été trouvé.
	 *  @eventType frankenstein.events.DeviceDetectionEvent.MICROPHONE_NOT_FOUND
	 */
	[Event(name="cameraNotFound", type="frankenstein.events.DeviceDetectionEvent")]

	/**
	 *  Tous les microphones valides ont été detéctés.
	 *  @eventType frankenstein.events.DeviceDetectionEvent.MICROPHONE_LIST_GOT
	 */
	[Event(name="cameraNotFound", type="frankenstein.events.DeviceDetectionEvent")]

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 27 nov 2008<br />
	 * 		<b>Version </b> 1.0.2<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>1.0.0 par kaltura (http://corp.kaltura.com/)</li>
	 * 				<li>v1.0.1 par Antoine Lassauzay<br />
	 * 						Ajout de la detection du micro<br />
	 *	 					Diverses optimisations.
	 * 				</li>
	 * 				<li>v1.0.2 par NicoBush<br />
	 * 						Classe transformée en classe statique.<br />
	 * 						Renommage de la méthode detectDefaultCamera en detectCamera.
	 * 				</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * 
	 * </div>
	 * <p>
	 * 	Classe permettant de faciliter la detection de la webcam et du micro.<br />
	 * 	Elle est pratique en particulier pour les Mac qui disposent de plusieurs drivers de Webcam. La classe
	 * 	teste alors les differentes webcam à la suite et dès qu'elle trouve une image, selectionne la webcam.<br />
	 * 	Elle fait la même chose pour la detection du microphone.
	 * </p>
	 * La classe est entièrement statique. 
	 * 
	 * @example
	 * Détection de la webcam
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		//on ecoute les evenement camera
	 * 		DeviceDetector.addEventListener(DeviceDetectionEvent.CAMERA_DENIED, _onCameraDenied);
	 * 		DeviceDetector.addEventListener(DeviceDetectionEvent.CAMERA_DETECTED, _onCameraFound);
	 * 		DeviceDetector.addEventListener(DeviceDetectionEvent.CAMERA_NOT_FOUND, _onCameraNotFound);
	 * 		
	 * 		//on lance la detection
	 * 		DeviceDetector.detectCamera();
	 * 		
	 * 		function _onCameraFound(e : DeviceDetectionEvent) : void {
	 * 			trace("camera Found");
	 * 			
	 * 			var camera : Camera = e.detectedCamera;
	 * 			
	 * 			var video : Video = new Video(camera.width, camera.height);
	 * 			video.attachCamera(camera);
	 * 			addChild(video);
	 * 		}
	 * 		
	 * 		function _onCameraNotFound(e : DeviceDetectionEvent) : void {
	 * 			trace("camera NotFound");
	 * 		}
	 * 		
	 * 		function _onCameraDenied(e : DeviceDetectionEvent) : void {
	 * 			trace("camera Denied");
	 * 		}
	 * 	</pre>
	 * </listing>
	 * 
	 * @example
	 * Détection du micro: 
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		
	 * 		//on ecoute les evenement microphone
	 * 		DeviceDetector.addEventListener(DeviceDetectionEvent.MICROPHONE_DENIED, _onMicroDenied);
	 * 		DeviceDetector.addEventListener(DeviceDetectionEvent.MICROPHONE_DETECTED, _onMicroFound);
	 * 		DeviceDetector.addEventListener(DeviceDetectionEvent.MICROPHONE_NOT_FOUND, _onMicroNotFound);
	 * 		
	 * 		//on lance la detection
	 * 		DeviceDetector.detectMicrophone();
	 * 		
	 * 		function _onMicroFound(e : DeviceDetectionEvent) : void {
	 *			event.detectedMicrophone.setLoopBack(true);
	 *			addEventListener(Event.ENTER_FRAME, _getMicVolume);
	 *		}
	 *		
	 * 		function _getMicVolume(event : Event) : void {
	 * 			trace(DeviceDetector.getDetectedMicrophone().activityLevel);
	 * 		}
	 * 		
	 * 		function _onMicroNotFound(e : DeviceDetectionEvent) : void {
	 * 			trace("micro NotFound");
	 * 		}
	 * 		
	 * 		function _onMicroDenied(e : DeviceDetectionEvent) : void {
	 * 			trace("micro Denied");
	 * 		}
	 * 	</pre>
	 * </listing>
	 * 
	 */
	public class DeviceDetector extends EventDispatcher {

		private var defaultCamera : Camera = null;
		private var camerasNumber : int = Camera.names.length;
		private var testedCameraIndex : int = -1;
		private var testedCamera : Camera;
		private var testedVideo : Video = new Video(50, 50);
		private var testRect : Rectangle = new Rectangle(0, 0, 50, 50);
		private var testedBitmapData : BitmapData = new BitmapData(50, 50, false, 0x0);
		private var blackBitmapData : BitmapData = new BitmapData(50, 50, false, 0x0);
		private var delayDetectCameraIndex : uint = 0;
		private var cameraFails : uint = 0;

		/**
		 * Nombre de test infructueux maximum de webcam.
		 */
		public var maxCameraFails : uint = 3;

		private var testedMicrophone : Microphone = null;
		private var defaultMicrophone : Microphone = null;		
		private var delayTime : uint = 500;
		private var delayAfterFail : uint = 1000;
		private var _enableChoice : Boolean = false;

		//////
		//		CCCCCCCCC		AAAAAAAAAAA			MMMMMM		   MMMMMM
		//		CCCCCCCCC		AAAAAAAAAAA			MMMMMMMMMM MMMMMMMMMM
		//		CCC				AAA		AAA			MMMM    MMMMM	 MMMM
		//		CCC				AAAAAAAAAAA			MMM		 MMM	  MMM
		//		CCCCCCCCC		AAA		AAA			MMM		  M		  MMM
		//		CCCCCCCCC		AAA		AAA			MMM				  MMM
		//////
		
		/**
		 * Renvoi l'objet Camera détecté (null si aucune détectée).
		 * 
		 * @return
		 * L'objet Camera.
		 */
		public static function getDetectedCamera() : Camera {
			return getInstance().getDetectedCamera();
		}
		 
		 
		 /**
		  * @private
		  */		
		protected function getDetectedCamera() : Camera {
		
			return defaultCamera;
		}

		
		/**
		 * Lancer la détection de la webcam.<br />
		 * Vous pouvez d'abord vérifier si elle a déja été détéctée grâce à la méthode getDefaultCamera().
		 * 
		 * Écoutez les évènements DeviceDetectionEvent pour obtenir le résultat.
		 * 
		 * @return void
		 */
		public static function detectCamera() : void {
			getInstance().detectCamera();
		}

		
		/**
		 * @private
		 */
		protected function detectCamera() : void {
			testedCameraIndex = -1;
			if (delayDetectCameraIndex != 0)
				clearTimeout(delayDetectCameraIndex);
			testedBitmapData = new BitmapData(testRect.width, testRect.height, false, 0x0);
			blackBitmapData = new BitmapData(testRect.width, testRect.height, false, 0x0);
			blackBitmapData.fillRect(testRect, 0x0);
			detectNextCamera();
		}

		
		private function detectNextCamera() : void {
			cameraFails = 0;

			if (defaultCamera) {
				dispatchCameraSuccess();
				return;
			}

			if (testedCameraIndex > 0 && testedCamera != null)
				testedCamera.removeEventListener(StatusEvent.STATUS, statusCameraHandler);

			if ((++testedCameraIndex) >= camerasNumber) {
				//we didn't find any camera on the system..
				dispatchCameraError();
				return;
			}

			testedCamera = Camera.getCamera(testedCameraIndex.toString());

			if (testedCamera == null) {
				if (camerasNumber > 0) {
					//there are devices on the system but we don't get access directly to them...
					//let the user set the access to the default camera:
					// NOTE: this should never happen here, because we use the specific access to the camera object
					// rather than using the default getCamera ();
					Security.showSettings(SecurityPanel.CAMERA);
				} else {
					//we don't have any camera device!
					dispatchCameraError();
				}
				return;
			}

			testedBitmapData.fillRect(testRect, 0x0);
			testedVideo.attachCamera(null);
			testedVideo.clear();
			testedCamera.addEventListener(StatusEvent.STATUS, statusCameraHandler);
			testedVideo.attachCamera(testedCamera);

			if (!testedCamera.muted) {
				//trace("User selected Accept already.");
				delay_testCameraImage();
			} else {
				//the user selected not to allow access to the devices.
				//trace("User selected Deny by default.");
				Security.showSettings(SecurityPanel.PRIVACY);
			}
		}

		
		private function statusCameraHandler(event : StatusEvent) : void {
			switch (event.code) {
				case "Camera.Muted":
					//trace("Camera: User clicked Deny.");
					dispatchCameraDeny();
					break;

				case "Camera.Unmuted":
					//trace("Camera: User clicked Accept.");
					delay_testCameraImage();
					break;
			}
		}

		
		/**
		 * delays the image test.
		 * <p>the system takes abit of time to initialize the connection to the physical camera and return image
		 * so we give the camera 1.5 seconds to actually be attached and return an image
		 * unfortunatly we don't have any event from the flash player that notify a physical initialization and that image was given.
		 * we additionaly give more time for slower machines (or cameras) if we fail.
		 * you can set the maximum fail tryouts by setting the maxFails variable.</p>
		 */
		private function delay_testCameraImage() : void {
			delayDetectCameraIndex = setTimeout(testCameraImage, (cameraFails > 0) ? delayAfterFail : delayTime);
		}

		
		private function testCameraImage() : void {
			try {
				testedBitmapData.draw(testedVideo);
				var testResult : Object = testedBitmapData.compare(blackBitmapData);
				//trace ("camera test: " + Camera.names[testedCameraIndex] + ' ('+ testedCameraIndex + ')');
				if (testResult is BitmapData) {
					//it's different, we have an image!
					dispatchCameraSuccess();
				} else {
					//camera is not available for some reson, we don't get any image.
					// move to check the next camera
					if ((++cameraFails) < maxCameraFails) {
						delay_testCameraImage();
					} else {
						detectNextCamera();
					}
				}
			}
			catch (err : Error){
				trace(this, "testCameraImage", "/!\\ testCamera image failed : " + err.message);
				delay_testCameraImage();
			}
		}

		
		private function dispatchCameraSuccess() : void {
			disposeCamera();
			defaultCamera = Camera.getCamera(testedCameraIndex.toString());
			
			var e : DeviceDetectionEvent = new DeviceDetectionEvent(DeviceDetectionEvent.CAMERA_DETECTED);
			e.detectedCamera = defaultCamera;
			dispatchEvent(e);
		}

		
		private function dispatchCameraError() : void {
			disposeCamera();
			defaultCamera = null;
			var e : DeviceDetectionEvent = new DeviceDetectionEvent(DeviceDetectionEvent.CAMERA_NOT_FOUND);
			dispatchEvent(e);
		}

		
		private function dispatchCameraDeny() : void {
			disposeCamera();
			defaultCamera = null;
			var e : DeviceDetectionEvent = new DeviceDetectionEvent(DeviceDetectionEvent.CAMERA_DENIED);
			dispatchEvent(e);
		}

		
		private function disposeCamera() : void {
			if (testedCamera)
				testedCamera.removeEventListener(StatusEvent.STATUS, statusCameraHandler);
			testedCamera = null;
			testedVideo.attachCamera(null);
			testedVideo.clear();
			if (blackBitmapData)
				blackBitmapData.dispose();
			if (testedBitmapData)
				testedBitmapData.dispose();
		}

		
		//////
		//		MMMMMM		   MMMMMM			IIIIIIIIIII			CCCCCCCCC
		//		MMMMMMMMMM MMMMMMMMMM			IIIIIIIIIII			CCCCCCCCC
		//		MMMM    MMMMM	 MMMM				III				CCC
		//		MMM		 MMM	  MMM				III				CCC
		//		MMM		  M		  MMM			IIIIIIIIIII			CCCCCCCCC
		//		MMM				  MMM			IIIIIIIIIII			CCCCCCCCC
		//////
		
		/**
		 * Renvoi l'objet Microphone détecté (null si aucun).
		 * 
		 * @return
		 * L'objet Microphone.
		 */
		public static function getDetectedMicrophone() : Microphone {
			return getInstance().getDetectedMicrophone();
		}

		
		/**
		 * @private
		 */	
		protected function getDetectedMicrophone() : Microphone {
		
			return defaultMicrophone;
		}

		
		/**
		 * Lance la détection du microphone.
		 * 
		 * @return void
		 */
		public static function detectMicrophone() : void {
			getInstance().detectMicrophone();
		}

		
		/**
		 * @private
		 */
		protected function detectMicrophone() : void {
			// On récupère le micro par défaut
			testedMicrophone = Microphone.getMicrophone(-1);
			
			// S'il n'y a aucun micro
			if(testedMicrophone == null || Microphone.names.length == 0) {
				dispatchMicrophoneError();
				return;
			}

			// Si on veut laisser le choix
			// Ou si on est sous-mac (pb de micros inexistants)
			// Ou si le micro n'est pas activé
			// --> On propose le panneau de choix webcam

			testedMicrophone.addEventListener(StatusEvent.STATUS, _onMuteUnmute);

			if(testedMicrophone.muted) {
				trace('Mic muted');
				Security.showSettings(SecurityPanel.DEFAULT);
				return;
			}
			
			_enableChoice = Capabilities.os.indexOf('Mac') > -1;
						
			if(_enableChoice)
				Security.showSettings(SecurityPanel.MICROPHONE);
				
			defaultMicrophone = testedMicrophone;
			dispatchMicrophoneSuccess();	
		}

		
		private function _onMuteUnmute(event : StatusEvent) : void {
						
			defaultMicrophone = Microphone.getMicrophone(-1);
						
			switch (event.code) {
				case "Microphone.Muted":
					
					// L'utilisateur refuse l'accès
					dispatchMicrophoneDeny();
		           
					break;

				case "Microphone.Unmuted":
					// On a trouvé un micro

					if(_enableChoice) {
						_enableChoice = false;
						Security.showSettings(SecurityPanel.MICROPHONE);
					}
		           
					dispatchMicrophoneSuccess();
					break;
			}
		}

		
		private function dispatchMicrophoneSuccess() : void {
			
			disposeMicrophone();
			var e : DeviceDetectionEvent = new DeviceDetectionEvent(DeviceDetectionEvent.MICROPHONE_DETECTED);
			e.detectedMicrophone = defaultMicrophone;
			
			dispatchEvent(e);
		}

		
		private function dispatchMicrophoneError() : void {
			
			disposeMicrophone();
			defaultMicrophone = null;
			
			var e : DeviceDetectionEvent = new DeviceDetectionEvent(DeviceDetectionEvent.MICROPHONE_NOT_FOUND);
			
			dispatchEvent(e);
		}

		
		private function dispatchMicrophoneDeny() : void {

			disposeMicrophone();
			defaultMicrophone = null;
			
			var e : DeviceDetectionEvent = new DeviceDetectionEvent(DeviceDetectionEvent.MICROPHONE_DENIED);
			dispatchEvent(e);
		}

		
		private function disposeMicrophone() : void {
						
			if (testedMicrophone) {
				testedMicrophone.setLoopBack(false);
				testedMicrophone.removeEventListener(StatusEvent.STATUS, _onMuteUnmute);
			}
			testedMicrophone = null;
		}

		/////// ============= singletone
		/**
		 *Constructor + getInsance.
		 */
		static private var _instance : DeviceDetector;

		/**
		 * @private
		 */
		public function DeviceDetector(p : DeviceDetectorEnforcer) : void {
			if (_instance)
				throw (new Error("you can't instantiate singletone more than once, use getInstance instead."));

			testedVideo.smoothing = false;
			testedVideo.deblocking = 1;
		}

		
		/**
		 * Retourne l'unique instance de la classe DeviceDetector.
		 * 
		 * @return DeviceDetector
		 */
		private static function getInstance() : DeviceDetector {
			if (!_instance)
				_instance = new DeviceDetector(new DeviceDetectorEnforcer());
			return _instance;
		}

		
		/**
		 * Libère la mémoire et vide la liste des accessoires détectés.
		 * 
		 * @return void
		 */
		public static function dispose() : void {
			getInstance().dispose();
		}

		
		/**
		 * @private
		 */		
		protected function dispose() : void {

			defaultMicrophone = null;
			defaultCamera = null;
		
			disposeCamera();
			disposeMicrophone();	
		}
		
		
		//--------------------------------------
		//				STATIC EVENT DISPATCHER					
		//--------------------------------------
		
		/**
		 * Ajoute un écouteur d'évènements.
		 * 
		 * @param type
		 * Le type d'évènement à écouter.
		 * 
		 * @param listener
		 * La méthode appelée lorsque l'évènement est dispatché.
		 * 
		 * @param useCapture.
		 *  
		 * @param priority
		 * Priorité d'écoute.
		 * 
		 * @param useWeakReference
		 * Référence faible.
		 * 
		 */
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false):void {
			getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Retire l'écouteur d'évènements.
		 * 
		 * @param type
		 * Le type d'évènement qui est écouté.
		 * 
		 * @param listener
		 * La méthode appelée lorsque l'évènement est dispatché.
		 * 
		 */
		public static function removeEventListener(type : String, listener : Function):void {
			getInstance().removeEventListener(type, listener);
		}
		
	}
}

/**
 * @private
 */
class DeviceDetectorEnforcer {
	
	function DeviceDetectorEnforcer(){
		//do nada
	}
}


