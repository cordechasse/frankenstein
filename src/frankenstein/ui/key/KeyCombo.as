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
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * Objet de définition d'une Combo de touches.<br />
	 * Une Combo est plusieurs touches appuyées en même temps.<br />
	 * </p>
	 * 
	 * @example
	 * Diagonale bas droite est la Combo flèche Bas + flèche Droite.
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		StageReference.stage = stage;
	 * 		
	 * 		//on crée la combo
	 * 		var keyComboDiagBD : KeyCombo = new KeyCombo([KeyCode.DOWN, KeyCode.RIGHT]);
	 * 		
	 * 		//on l'ajoute à la liste d'écoute du KeyManager
	 * 		KeyManager.addKeyCombo(keyComboDiagBD);
	 * 		
	 * 		//on écoute les events COMBO_UP et COMBO_DOWN
	 * 		KeyManager.addEventListener(KeyManagerEvent.COMBO_UP, _onComboUp);
	 * 		KeyManager.addEventListener(KeyManagerEvent.COMBO_DOWN, _onComboDown);
	 * 		
	 * 		function _onComboDown(e : KeyManagerEvent) : void {
	 * 			trace("comboDown", e.keyCombo);
	 * 		}
	 * 		
	 * 		function _onComboUp(e : KeyManagerEvent) : void {
	 * 			trace("comboDown", e.keyCombo);
	 * 		}
	 * 	</pre>
	 * </listing>
	 */
	public class KeyCombo {
		
		protected var _keyCodes : Array;

		/**
		 * Crée un nouvel objet KeyCombo.
		 * 
		 * @param keyCodes
		 * Tableau contenant les touches qui composent la Combo.
		 * 
		 */
		public function KeyCombo(keyCodes : Array) {
			_keyCodes = UArray.clone(keyCodes);
		}

		
		/**
		 * Retourne le tableau contenant les touches qui composent la Combo.
		 */
		public function get keyCodes() : Array {
			return UArray.clone(_keyCodes);
		}

		
		/**
		 * Détermine si la KeyCombo passé en paramètre possède les mêmes touches que l'objet en cours.
		 * 
		 * @param keyCombo
		 * La KeyCombo à comparer.
		 * 
		 * @return
		 * Si les KeyCombo sont identiques.
		 */
		public function equals(keyCombo : KeyCombo) : Boolean {
			if (keyCombo == this)
				return true;
			
			return UArray.equals(_keyCodes.sort(), keyCombo.keyCodes.sort());
		}

		/**
		 * @private
		 */
		public function toString() : String {
			var s : String = "";
			for (var i : uint = 0;i < _keyCodes.length; i++) {
				s += i != 0 ? " + " : "";
				s += KeyCode.getKeyString(_keyCodes[i]);
			}
			return s;
		}

		/**
		 * Retourne si l'objet possède toutes les touches d'une autre KeyCombo.
		 * 
		 * @param keyCombo
		 * La KeyCombo à tester.
		 * 
		 */		
		public function contains(keyCombo : KeyCombo) : Boolean {
			return UArray.containsArray(_keyCodes, keyCombo.keyCodes);
		}
	}
}