/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.events {
	import flash.events.Event;

	/**
	 * 
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 22 avr 2008<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>NicoBush v1.0.0</li>
	 * 				<li>NicoBush v1.0.1 : override de la méthode clone</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Les évènements SoundEvent sont dispatchés pour tout évènement son.<br />
	 * Ils sont utilisés par les classes SoundManager, SoundPlayer et MusicPlayer
	 * </p>
	 * 
	 * @see frankenstein.sound.SoundManager
	 * @see frankenstein.sound.players.SoundPlayer
	 * @see frankenstein.sound.players.MusicPlayer
	 *  
	 * @author n.bush
	 * @since 22 avr 2008
	 * @version 1.0.0
	 */
	public class SoundEvent extends Event {

		/**
		 * Le volume change 
		 */
		public static const VOLUME_CHANGE : String = "volume_change";
		
		/**
		 * Le son est coupé
		 */
		public static const MUTE : String = "mute";
		
		/**
		 * Le son est réactivé
		 */
		public static const UNMUTE : String = "unmute";
		
		/**
		 * Le son est terminé
		 */
		public static const SOUND_COMPLETE : String = "sound_complete";
		
		/**
		 * Le tween volume du son est terminé
		 */
		public static const TWEEN_SOUND_COMPLETE : String = "tween_sound_complete";

		/**
		 * La valeur du volume
		 */
		public var volume : Number;
		
		/**
		 * L'index du son (index defini par le SoundPlayer)
		 */
		public var soundIdx : uint;

		/**
		 * 
		 * Crée un nouveau SoundEvent
		 * 
		 * @param type
		 * Le type d'évènement.
		 * 
		 * @param bubbles.
		 * Détermine si l'évènement remonte dans la hierarchie des clips (effet bubble).
		 * 
		 * @param cancelable
		 * Détermine si l'évènement peut être annulé.
		 * 
		 */	
		public function SoundEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event {
			var e : SoundEvent = new SoundEvent(type, bubbles, cancelable);
			e.volume = volume;
			e.soundIdx = soundIdx;
			return e;
		}
	}
}
