/*
 * Copyright © CorDeChasse 1999-2011
 */
 
 
package frankenstein.sound.type {
	import flash.media.SoundTransform;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 4 nov 2009<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>NicoBush v1.0.0</li>
	 * 				<li>NicoBush v1.0.1 : variable loop passée en int à la place d'uint</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * Objet permettant de spécifier les options de lecture d'un AdvancedSound.<br />
	 * Cette classe permet de modifier des propriétés de lecture de son sans avoir à modifier le son dans un logiciel.<br />
	 * On peut :
	 * <ul>
	 * 	<li>Modifier le volume</li>
	 * 	<li>Définir un nombre de boucle</li>
	 * 	<li>Spécifier ou commence la tête de lecture (pour couper les blancs de début de fichier)</li>
	 * </ul>
	 * 
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		var sndTransform : SoundTransform = new SoundTransform();
	 * 		sndTransform.volume = 0.8;
	 * 		var sndOptions : SoundOptions = new SoundOptions(sndTransform);
	 * 	
	 * 		var snd : AdvancedSound = new AdvancedSound(new URLRequest("son.mp3"), null, sndOptions));
	 * 		SoundPlayer.play(snd);	
	 * 	</pre>
	 * </listing>
	 * 
	 * @see frankenstein.sound.players.SoundPlayer
	 * @see frankenstein.sound.type.AdvancedSound
	 * 
	 * 
	 * 
	 * @author n.bush
	 * @project TweenMaxFunction
	 * @date 4 nov. 2009
	 * 
	 */
	public class SoundOptions {
		private var _startTime : Number = 0;
		private var _transform : SoundTransform;
		private var _loops : int;
		
		/**
		 * Crée un nouveau SoundOptions.
		 * 
		 * @param soundTransform
		 * La transformation sur le son qui sera appliquée à la lecture.
		 * 
		 * @param loops
		 * Le nombre de boucle à faire.
		 * 
		 * @param startTime
		 * Le temps de départ (en millisecondes).
		 *  
		 */
		public function SoundOptions(soundTransform : SoundTransform = null, loops : uint = 0, startTime : Number = 0){
			_transform = soundTransform == null ? new SoundTransform() : soundTransform;
			_loops = loops;
			_startTime = startTime;
		}

		
		//--------------------------------------
		//					START TIME
		//--------------------------------------
		/**
		 * Le temps de départ.
		 */
		public function get startTime() : Number {
			return _startTime;
		}

		public function set startTime(timeToStart : Number) : void {
			_startTime = timeToStart;
		}

		//--------------------------------------
		//					TRANSFORM
		//--------------------------------------
		/**
		 * Le soundTransform appliqué sur le son.
		 */		
		public function get transform() : SoundTransform {
			return _transform;
		}

		public function set transform(transform : SoundTransform) : void {
			_transform = transform;
		}

		//--------------------------------------
		//					LOOP
		//--------------------------------------
		/**
		 * Le nombre de boucles.
		 */		
		public function get loops() : int {
			return _loops;
		}
				
		public function set loops(loops : int) : void {
			_loops = loops;
		}

	}
}
