/*
 * Copyright © CorDeChasse 1999-2011
 */
 

package frankenstein.events {
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Microphone;	

	/**
	 * 
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> a.lassauzay<br />
	 * 		<b>Date </b> 01 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Les évènements DeviceDetectionEvent sont dispatchés par le DeviceDetector.</p>
	 * 
	 * 
	 * @author a.lassauzay
	 * @since 01 jan 2009
	 * @version 1.0.0
	 */
	public class DeviceDetectionEvent extends Event {

		/**
		 * La webcam n'a pas été trouvée.
		 */
		public static const CAMERA_NOT_FOUND : String = "cameraNotFound";
		
		/**
		 * La webcam a pas été détectée.
		 */
		public static const CAMERA_DETECTED : String = "cameraDetected";
		
		/**
		 * L'utilisateur a refusé au flashplayer l'accès à la caméra.
		 */		public static const CAMERA_DENIED : String = "cameraDenied";
		/**
		 * Le microphone n'a pas été trouvé.
		 */
		public static const MICROPHONE_NOT_FOUND : String = "microphoneNotFound";
		
		/**
		 * Le microphone a été trouvé.
		 */
		public static const MICROPHONE_DETECTED : String = "microphoneDetected";
		
		/**
		 * L'utilisateur a refusé au flashplayer l'accès au micro.
		 */
		public static const MICROPHONE_DENIED : String = "microphoneDenied";

		/**
		 * L'objet Camera détecté.
		 */
		public var detectedCamera : Camera = null;
		
		
		/**
		 * L'objet Microphone détecté. 
		 */
		public var detectedMicrophone : Microphone = null;

		public function DeviceDetectionEvent(type : String) : void {
			super(type, false, false);
		}

		
		override public function clone() : Event {
			return new DeviceDetectionEvent(this.type);
		}

		
		override public function toString() : String {
			return formatToString('DeviceDetectionEvent', 'type', 'detectedCamera', 'detectedMicrophone');	
		}
	}
}