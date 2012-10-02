/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.ui.key {
	import frankenstein.tools.UArray;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 17 déc 2008<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>NicoBush v1.0.1</li>
	 * 				<li>NicoBush v1.0.1 : ajout des constantes KONAMI_CODE et COR_DE_CHASSE</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * Objet de définition d'une séquence de touches.<br />
	 * Une Séquence est une liste de touches appuyés dans l'ordre. 
	 * (elle peut contenir des KeyCodes et des KeyCombos).
	 * </p>
	 * 
	 * @example
	 * Street Fighter HADOKEN : Bas, DiagBasDroite, Droite, A.
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		//on crée la Combo Diagonale Bas	
	 * 		var keyComboDiagBD : KeyCombo = new KeyCombo([KeyCode.DOWN, KeyCode.RIGHT]);
	 * 		
	 * 		//on crée la séquence
	 * 		var keySequenceHadoken : KeySequence = new KeySequence([KeyCode.DOWN, keyComboDiagBD, KeyCode.RIGHT, KeyCode.A]);
	 * 		
	 * 		//on écoute la séquence avec le KeyManager
	 * 		StageReference.stage = stage;
	 * 		
	 * 		KeyManager.addEventListener(KeyManagerEvent.SEQUENCE_PERFORMED, _onSequencePerformed);
	 * 		KeyManager.addKeySequence(keySequenceHadoken);
	 * 		
	 * 		function _onSequencePerformed(e : KeyManagerEvent) : void {
	 * 			trace("HADOKEN");
	 * 		}
	 * 	</pre>
	 * </listing>
	 */
	public class KeySequence {
		
		public static const KONAMI_CODE : KeySequence = new KeySequence([KeyCode.UP,
																		 KeyCode.UP,
																		 KeyCode.DOWN,
																		 KeyCode.DOWN,
																		 KeyCode.LEFT,
																		 KeyCode.RIGHT,
																		 KeyCode.LEFT,
																		 KeyCode.RIGHT,
																		 KeyCode.B,
																		 KeyCode.A]);
		
		public static const COR_DE_CHASSE : KeySequence = new KeySequence([KeyCode.C,
																		 KeyCode.O,
																		 KeyCode.R,
																		 KeyCode.D,
																		 KeyCode.E,
																		 KeyCode.C,
																		 KeyCode.H,
																		 KeyCode.A,
																		 KeyCode.S,
																		 KeyCode.S,
																		 KeyCode.E]);
		
		
		
		private var _keyList : Array; 
		
		/**
		 * Crée un nouveau KeySequence.
		 * 
		 * @param keyList
		 * Tableau contenant des KeyCode ou des KeyCombos. L'ordre du tableau est bien sûr très 
		 * important.
		 * 
		 */
		public function KeySequence(keyList : Array){
			if (keyList.length <= 1)
				throw(new Error("Warning : a sequence is compounded at least 2 key / keycombos"));
			
			_keyList = keyList;
		}
		
		
		/**
		 * Retourne si une Séquence est identique à l'objet en cours.
		 * 
		 * @param keySequence
		 * la KeySequence à comparer.
		 * 
		 * @return
		 * True si les séquences disposent des mêmes touches dans le même ordre.
		 */
		public function equals(keySequence : KeySequence):Boolean{
			if (keySequence == this)
				return true;
			
			return UArray.equals(_keyList, keySequence.keyList);
		}
		
		
		/**
		 * Retourne la liste des touches de la Séquence.
		 */
		 public function get keyList():Array {
			return _keyList;
		}
		
		/**
		 * Retourne la longueur de la Séquence.
		 */
		public function get length():uint {
			return _keyList.length;
		}
		
		
		
	}
}
