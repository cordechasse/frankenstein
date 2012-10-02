/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.ui.key {
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import frankenstein.core.StageReference;
	import frankenstein.events.KeyManagerEvent;
	import frankenstein.tools.UArray;


	/**
	 * Une touche est appuyée.
	*
	* @eventType frankenstein.events.KeyManagerEvent.KEY_DOWN
	*/
	[Event(name="key_down", type="frankenstein.events.KeyManagerEvent")]
	
	/**
	* Une touche est relachée.
	*
	* @eventType frankenstein.events.KeyManagerEvent.KEY_UP
	*/
	[Event(name="key_up", type="frankenstein.events.KeyManagerEvent")]
	
	/**
	* Une combo est réalisée.
	*
	* @eventType frankenstein.events.KeyManagerEvent.COMBO_DOWN
	*/
	[Event(name="combo_down", type="frankenstein.events.KeyManagerEvent")]
	
	/**
	* Une combo est relachée.
	*
	* @eventType frankenstein.events.KeyManagerEvent.COMBO_UP
	*/
	[Event(name="combo_up", type="frankenstein.events.KeyManagerEvent")]
	
	/**
	* Une séquence est réalisée.
	*
	* @eventType frankenstein.events.KeyManagerEvent.SEQUENCE_PERFORMED
	*/
	[Event(name="sequence_performed", type="frankenstein.events.KeyManagerEvent")]
	
	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 17 déc 2008<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>NicoBush v1.0.1</li>
	 * 				<li>NicoBush v1.1.0 :<br />
	 * 						- ajout des séquences Konami code et Cor de chasse<br />
	 * 						- dispatch de la séquence la plus longue quand plusieurs séquences sont réalisées</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * Classe de gestion du clavier avancé.<br />
	 * Cette classe permet de gérer : 
	 * <ul>
	 * 	<li>L'appui sur 1 touche</li>
	 * 	<li>La réalisation de Combos (plusieurs touches appuyées en même temps)</li>
	 * 	<li>La réalisation de Séquences (suite de touches appuyés dans un temps spécifique)</li>
	 * </ul>
	 * La classe est entièrement statique. 
	 * </p>
	 * <p>
	 * <font color='red'><b>Attention:</b></font><br />
	 * Il existe le risque que les touches dispatchés ne correspondent pas exactement aux touches sur
	 * lesquelles l'utilisateur à réellement appuyé. En effet on rencontre des différences selon les 
	 * systèmes d'exploitation, ordinateur portable ou fixe, langues etc.<br />
	 * Il faut donc se limiter aux touches les plus communes qui sont :
	 * <ul>
	 * 	<li>Touches de A à Z sauf M</li>
	 * 	<li>Flèches</li>
	 * 	<li>Touches de F1 à F8</li>
	 * 	<li>Touches de 0 à 9 (pas celles du pavés numériques)</li>
	 * 	<li>CTRL</li>
	 * 	<li>ALT</li>
	 * 	<li>ESPACE</li>
	 * 	<li>SHIFT</li>
	 * 	<li>TAB</li>
	 * 	<li>BACKSPACE</li>
	 * </ul>
	 * et éviter les caractères spéciaux, touches système (Pomme, touche Windows), Les touches du pavés numériques 
	 * (tous les ordinateurs n'en ont pas forcément), les ponctuations etc.	
	 * </p> 
	 * 
	 * @example
	 * Ecoute des touches claviers :  
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		StageReference.stage = stage;
	 * 	
	 * 		//on écoute les events KEY_UP et KEY_DOWN
	 * 		KeyManager.addEventListener(KeyManagerEvent.KEY_DOWN, _onKeyDown);
	 * 		KeyManager.addEventListener(KeyManagerEvent.KEY_UP, _onKeyUp);
	 * 		
	 * 		function _onKeyDown(e : KeyManagerEvent) : void {
	 * 			trace("keyDown", e.keyCode, KeyCode.getKeyString(e.keyCode))
	 * 		}
	 * 		
	 * 		function _onKeyUp(e : KeyManagerEvent) : void {
	 * 			trace("keyUp", e.keyCode, KeyCode.getKeyString(e.keyCode))
	 * 		}
	 * 	</pre>
	 * </listing>
	 * 
	 * 
	 * @example
	 * Ecoute des combos :  
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		StageReference.stage = stage;
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
	 * 		
	 * 		//on ajoute les combos à la liste d'écoute
	 * 		var keyComboDiagBD : KeyCombo = new KeyCombo([KeyCode.DOWN, KeyCode.RIGHT]);
	 * 		KeyManager.addKeyCombo(keyComboDiagBD);
	 * 		
	 * 		
	 * 	</pre>
	 * </listing>
	 * 
	 * 
	 * @example
	 * Ecoute des séquences :  
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		StageReference.stage = stage;
	 * 	
	 *		//on écoute l'event SEQUENCE_PERFORMED
	 * 		KeyManager.addEventListener(KeyManagerEvent.SEQUENCE_PERFORMED, _onSequencePerformed);
	 * 		
	 * 		function _onSequencePerformed(e : KeyManagerEvent) : void {
	 * 			trace("keyIsDown", e.keySequence)
	 * 		}
	 * 		
	 * 		//on ajoute la séquence à la liste d'écoute
	 * 		var keySequencePIF : KeySequence = new KeySequence([KeyCode.P, KeyCode.I, KeyCode.F]);
	 * 		KeyManager.addKeySequence(keySequencePIF);
	 * 	</pre>
	 * </listing>
	 * 
	 */
	public class KeyManager extends EventDispatcher {
		/**
		 * @private
		 */
		protected static var _instance : KeyManager;

		/**
		 * @private
		 */
		protected var _keysDownGeneral : Dictionary;

		/**
		 * @private
		 */
		protected var _keyCombos : Array;
		
		/**
		 * @private
		 */
		protected var _keySequences : Array;

		/**
		 * @private
		 */
		protected var _keyCombosDownDispatched : Array;
		
		/**
		 * @private
		 */
		protected var _keysDownDispatched : Array;

		/**
		 * @private
		 */
		private var _previousCombosUsed : Array;

		/**
		 * @private
		 */
		private var _currentSequence : Array;
		
		/**
		 * @private
		 */
		private var _sequenceSpeed : uint = 500;
		
		
		/**
		 * @private
		 */
		protected static function getInstance() : KeyManager {
			if (KeyManager._instance == null)
				KeyManager._instance = new KeyManager(new SingletonEnforcer());
			
			return KeyManager._instance;
		}

		
		/**
		 * @private
		 */
		public function KeyManager(singletonEnforcer : SingletonEnforcer) {
			this._keysDownGeneral = new Dictionary();
			
			_keyCombos = [];
			_keySequences = [];
			
			_currentSequence = [];
			
			_keyCombosDownDispatched = [];
			_keysDownDispatched = [];
			
			stage = StageReference.stage;
		}

		
		/**
		 * @private
		 */
		protected function set stage(s : Stage) : void {
			s.addEventListener(KeyboardEvent.KEY_DOWN, this._onKeyDown, false, 0, true);
			s.addEventListener(KeyboardEvent.KEY_UP, this._onKeyUp, false, 0, true);
		}

		
		/**
		 * Détermine si un touche est appuyée
		 * 
		 * @param keyCode
		 * Le code ascii de la touche (Les touches sont définies dans la classe KeyCode).
		 * 
		 * @return
		 * Si la touche est appuyée ou non.
		 * 
		 */
		public static function isDown(keyCode : uint) : Boolean {
			return getInstance().isDown(keyCode);
		}

		
		protected function isDown(keyCode : uint) : Boolean {
			return _keysDownGeneral[keyCode];
		}

		
		/**
		 * Détermine si une combo est réalisée.
		 * 
		 * @param keyCombo
		 * Le keyCombo à tester
		 * 
		 * @return
		 * Si la combo est réalisée ou non.
		 * 
		 */
		public static function isComboDown(keyCombo : KeyCombo) : Boolean {
			return getInstance().isComboDown(keyCombo);
		}

		
		protected function isComboDown(keyCombo : KeyCombo) : Boolean {
			return UArray.containsValue(_getComboUsed(), keyCombo);
		}

		
		//--------------------------------------
		//					ADD / REMOVE KEY COMBO
		//--------------------------------------

		/**
		 * Ajoute une combo à la liste d'écoute.
		 * 
		 * @param keyCombo
		 * La keyCombo à écouter.
		 * 
		 */
		public static function addKeyCombo(keyCombo : KeyCombo) : void {
			getInstance().addKeyCombo(keyCombo);			
		}

		
		protected function addKeyCombo(keyCombo : KeyCombo) : void {
			removeKeyCombo(keyCombo);
			_keyCombos.push(keyCombo);
		}

		
		/**
		 * Retire une combo de la liste d'écoute.
		 * 
		 * @param keyCombo
		 * La keyCombo à retirer.
		 *  
		 */
		public static function removeKeyCombo(keyCombo : KeyCombo) : void {
			getInstance().removeKeyCombo(keyCombo);	
		}
		
		protected function removeKeyCombo(keyCombo : KeyCombo) : void {
			for (var i : uint = 0;i < _keyCombos.length; i++) {
				if ((_keyCombos[i] as KeyCombo).equals(keyCombo)) {
					_keyCombos.splice(i, 1);
					return;
				}
			}
		}
		
		
		/**
		 * Retire toutes les combos de la liste d'écoute.
		 * 
		 */
		public static function removeAllCombos() : void {
			getInstance().removeAllCombos();	
		}
		
		protected function removeAllCombos():void {
			_keyCombos = [];	
		}

		
		
		
		
		//--------------------------------------
		//					ADD / REMOVE KEY SEQUENCE
		//--------------------------------------

		/**
		 * Ajoute une séquence à la liste d'écoute.
		 * 
		 * @param keySequence
		 * La keySequence à écouter.
		 * 
		 */
		public static function addKeySequence(keySequence : KeySequence) : void {
			getInstance().addKeySequence(keySequence);
		}

		
		protected function addKeySequence(keySequence : KeySequence) : void {
			_keySequences.push(keySequence);
			
			for (var i : uint = 0;i < keySequence.keyList.length; i++) {
				if (keySequence.keyList[i] is KeyCombo) {
					addKeyCombo(keySequence.keyList[i]);			
				}
			}
		}

		
		/**
		 * Retire une séquence de la liste d'écoute.
		 * 
		 * @param keySequence
		 * La keySequence à retirer.
		 *  
		 */
		public static function removeKeySequence(keySequence : KeySequence) : void {
			getInstance().removeKeySequence(keySequence);	
		}

		
		
		protected function removeKeySequence(keySequence : KeySequence) : void {
			for (var i : uint = 0;i < _keySequences.length; i++) {
				if ((_keySequences[i] as KeySequence).equals(keySequence)) {
					_keySequences.splice(i, 1);
				}
			}
		}


		/**
		 * Retire toutes les séquences de la liste d'écoute.
		 */
		public static function removeAllKeySequences() : void {
			getInstance().removeAllKeySequences();	
		}

		protected function removeAllKeySequences() : void {
			_keySequences = [];
		}
		
		
		
		
		//--------------------------------------
		//					EVENTS KEY DOWN / KEY UP
		//--------------------------------------
		
		/**
		 * @private
		 */
		protected function _onKeyDown(e : KeyboardEvent) : void {
			
			_keysDownGeneral[e.keyCode] = true;
			
			//on dispatche les combos
			var combosUsed : Array = _getComboUsed();
			_dispComboEvent(combosUsed, KeyManagerEvent.COMBO_DOWN);
			
			//on dispatche les key qui sont enfoncées pour la premiere fois
			if (!_isKeyDispatched(e.keyCode)) {
				var e2 : KeyManagerEvent = new KeyManagerEvent(KeyManagerEvent.KEY_DOWN);
				e2.keyCode = e.keyCode;
				dispatchEvent(e2);
				_keysDownDispatched.push(e.keyCode);
			}
			
			
			//on ajoute la touche appuyée à la sequence
			var keyUsedByCombos : Array = [];
			var l : uint = combosUsed.length;
			for (var i : uint = 0;i < l; i++) {
				keyUsedByCombos = keyUsedByCombos.concat((combosUsed[i] as KeyCombo).keyCodes);
			}
			
			if (!UArray.containsValue(keyUsedByCombos, e.keyCode)) {
				_addToSequence(e.keyCode);
			}
			
			
			//on stocke les combos precedents
			_previousCombosUsed = combosUsed;
		}

		
		/**
		 * @private
		 */
		protected function _onKeyUp(e : KeyboardEvent) : void {
			
			delete _keysDownGeneral[e.keyCode];
			
			//on compare les combos en cours et les precedents
			var comboUsed : Array = _getComboUsed();
			
			var comboNotUsedAnymore : Array = UArray.less(_previousCombosUsed, comboUsed);
			
			//on dispatche les combos qui ne sont plus utilisées
			_dispComboEvent(comboNotUsedAnymore, KeyManagerEvent.COMBO_UP);
			
			var e2 : KeyManagerEvent = new KeyManagerEvent(KeyManagerEvent.KEY_UP);
			e2.keyCode = e.keyCode;
			dispatchEvent(e2);
			
			_keysDownDispatched = UArray.removeItem(_keysDownDispatched, e.keyCode);
			
			//on dispatche les touches qui etaient utilisées par les combos, et qui sont maintenant utilisées en solo
			for (var j : uint = 0;j < comboNotUsedAnymore.length; j++) {
				var _keysDown : Array = _getKeysDown();
				for (var k : uint = 0;k < _keysDown.length; k++) {
					if (UArray.containsValue(comboNotUsedAnymore[j].keyCodes, _keysDown[k]) && (!_isKeyUsedInCurrentCombos(_keysDown[k]))) {
						_addToSequence(_keysDown[k]);
					}
				}
			}
			
			_previousCombosUsed = comboUsed;
		}

		
		/*
		private function _traceKeys(state : String) : void {
		var s : String = _getKeysDown().join("+");
		trace(this, "_traceKeys", state, s);
		}
		 */
		
		//--------------------------------------
		//					COMBO USED
		//--------------------------------------

		private function _getComboUsed() : Array {
			//on cree une combo de toute les touches pressées
			var combo : KeyCombo = new KeyCombo(_getKeysDown());
		
			var comboUsed : Array = [];
			
			for (var i : uint = 0;i < _keyCombos.length; i++) {
				if (combo.contains(_keyCombos[i])) {
					comboUsed.push(_keyCombos[i]);
				}
			}	
			
			return comboUsed;
		}

		
		private function _getKeysDown() : Array {
			var keysPressed : Array = [];
			for (var j : Object in _keysDownGeneral) {
				keysPressed.push(j);
			}
			
			return keysPressed;
		}

		
		private function _isKeyDispatched(keyCode : uint) : Boolean {
			return UArray.containsValue(_keysDownDispatched, keyCode);
		}

		
		private function _isKeyUsedInCurrentCombos(keyCode : uint) : Boolean {
			var comboUsed : Array = _getComboUsed();
			
			for (var i : uint = 0;i < comboUsed.length; i++) {
				if (UArray.containsValue(comboUsed[i].keyCodes, keyCode))
					return true;
			}
			
			return false;
		}

		
		//--------------------------------------
		//					DISPATCHE LES COMBOS UP / DOWN
		//--------------------------------------

		private function _dispComboEvent(combos : Array, event : String) : void {
			for (var i : uint = 0;i < combos.length; i++) {
				var e : KeyManagerEvent = new KeyManagerEvent(event);
				e.keyCombo = combos[i];
				
				if (event == KeyManagerEvent.COMBO_DOWN) {
					if (!UArray.containsValue(_keyCombosDownDispatched, combos[i])) {
						_keyCombosDownDispatched.push(combos[i]);
						dispatchEvent(e);
						
						
						_addToSequence(combos[i]);
					}
				} else {
					_keyCombosDownDispatched = UArray.removeItem(_keyCombosDownDispatched, combos[i]);
					dispatchEvent(e);	
				}
			}
		}

		
		
		//--------------------------------------
		//					KEYSEQUENCE
		//--------------------------------------

		private function _addToSequence(key : *) : void {
			
			var t : uint = new Date().getTime();
			
			//si la derniere touche de la derniere sequence date de plus de 1sec
			//on clear la sequence
			if (_currentSequence.length > 0 && (_currentSequence[_currentSequence.length - 1].time < (t - _sequenceSpeed)))
				_currentSequence = [];
			
			
			_currentSequence.push({time : t, action : key});
			
			if (_currentSequence.length > 1)
				_checkSequence();	
		}

		
		
		
		
		private function _checkSequence() : void {
			
			//on recupere les code actions sans les temps
			var keys : Array = [];
			for (var j : uint = 0;j < _currentSequence.length; j++) {
				keys.push(_currentSequence[j].action);	
			}
			
			if (_isSequencePerformed(keys, KeySequence.KONAMI_CODE)){
				var e0 : KeyManagerEvent = new KeyManagerEvent(KeyManagerEvent.SEQUENCE_KONAMI_CODE);
				dispatchEvent(e0);
			}
			
			if (_isSequencePerformed(keys, KeySequence.COR_DE_CHASSE)){
				var e1 : KeyManagerEvent = new KeyManagerEvent(KeyManagerEvent.SEQUENCE_CORDECHASSE);
				dispatchEvent(e1);
			}
			
			var allSeqPerformed : Array = [];
			
			for (var i : uint = 0;i < _keySequences.length; i++) {
				var sequence : KeySequence = _keySequences[i] as KeySequence;
				
				if (_isSequencePerformed(keys, sequence)){
					allSeqPerformed.push(sequence);
				}
				
			}
			//on ne dispatche que la sequence la plus longue
			if (allSeqPerformed.length > 0){
				var e : KeyManagerEvent = new KeyManagerEvent(KeyManagerEvent.SEQUENCE_PERFORMED);
				e.keySequence = _getLonguestSequence(allSeqPerformed);
				dispatchEvent(e);
			}
		}

		private function _isSequencePerformed(keys : Array, sequence : KeySequence) : Boolean {
			if (keys.length >= sequence.length){
				var performedSeq : KeySequence = new KeySequence(keys.slice((keys.length - sequence.length), keys.length));
				return sequence.equals(performedSeq);
			}
			return false;
		}

		private function _getLonguestSequence(seqList : Array) : KeySequence {
			var longuest : uint = 0;
			var i : uint = 1;
			var l : uint = seqList.length;
			
			while (i < l){
				if (seqList[i].length > seqList[longuest].length)
					longuest = i;
				
				i++;
			}
			
			return seqList[longuest];
		}


		
		
		
		/**
		 * Redéfinit le temps (en millisecondes) max entre l'appuie de 2 touches pour réaliser une séquence.
		 */
		public static function set sequenceSpeed(time : uint) : void {
			getInstance().sequenceSpeed = time;
		}

		
		protected function set sequenceSpeed(time : uint) : void {
			_sequenceSpeed = time;
		}

		
		public static function get sequenceSpeed() : uint {
			return getInstance().sequenceSpeed;
		}

		
		protected function get sequenceSpeed() : uint {
			return _sequenceSpeed;
		}

		
		/**
		 * Reset le KeyManager : retire tous les KeySequences et KeyCombos enregistrés et tue l'objet.
		 */
		public static function reset():void {
			getInstance().reset();			
			_instance = null;
		}


		protected function reset():void{
			StageReference.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this._onKeyDown);
			StageReference.stage.removeEventListener(KeyboardEvent.KEY_UP, this._onKeyUp);
			removeAllKeySequences();
			removeAllCombos();
			
		}

		
		//--------------------------------------
		//					EVENTDISPATCHER
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
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
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
		public static function removeEventListener(type : String, listener : Function) : void {
			getInstance().removeEventListener(type, listener);
		}
	}
}

class SingletonEnforcer {
}