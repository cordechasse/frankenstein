/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.events {
	
	
	import flash.events.Event;
	import frankenstein.ui.key.KeyCombo;
	import frankenstein.ui.key.KeySequence;

	
	/**
	 * 
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 17 dec 2008<br />
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
	 * <p>Les évènements KeyManagerEvent sont dispatchés par l'objet KeyManager.<br />
	 * Ils sont dispatchés lorsqu'un utilisateur :
	 * <ul>
	 * 	<li>appuie sur une touche</li>
	 * 	<li>relache une touche</li>
	 * 	<li>réalise un combo (plusieurs touches appuyées en même temps)</li>
	 * 	<li>réalise une sequence (séquence de touches réalisés dans l'ordre dans un certain laps de temps)</li>
	 * </ul>
	 * </p>
	 * 
	 * 
	 * @see frankenstein.ui.key.KeyManager
	 * 
	 * @author n.bush
	 * @since 17 dec 2008
	 * @version 1.0.0
	 */
	public class KeyManagerEvent extends Event {
		
		/**
		 * Les touches de la combos sont appuyées
		 */
		public static const COMBO_DOWN : String = "combo_down";

		/**
		 * Les touches de la combos sont relachés
		 */
		public static const COMBO_UP : String = "combo_up";

		/**
		 * Une touche est appuyée
		 */
		public static const KEY_DOWN : String = "key_down";

		/**
		 * Une touche est relachée 
		 */
		public static const KEY_UP : String = "key_up";

		/**
		 * Une séquence est réalisée
		 */
		public static const SEQUENCE_PERFORMED : String = "sequence_performed";
		
		
		/**
		 * La séquence KONAMI CODE est réalisée
		 */
		public static const SEQUENCE_KONAMI_CODE : String = "konami_code";
		
		
		/**
		 * La séquence COR DE CHASSE est réalisée
		 */
		public static const SEQUENCE_CORDECHASSE : String = "cor_de_chasse";
		
		
		

		public var keyCombo : KeyCombo;
		public var keyCode : uint;
		public var keySequence : KeySequence;

		/**
		 * 
		 * Crée un nouveau KeyManagerEvent.
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
		public function KeyManagerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event {
			var e : KeyManagerEvent = new KeyManagerEvent(type, bubbles, cancelable);
			e.keyCombo = keyCombo;
			e.keyCode = keyCode;
			e.keySequence = keySequence;
			return e;
		}
		
	}
}