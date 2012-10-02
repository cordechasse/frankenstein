/*
 * Copyright © CorDeChasse 1999-2011
 */
 
 package frankenstein.display {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 28 juin 2012<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>v1.0.0 by nicobush</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>Classe abstraite à overrider pour créer tout type de Bitamp<br />
	 * Cette classe apporte : <ul>
	 * 		<li>méthodes spécifiques appelées lors de l'ajout / retrait de la scène (onStaged, onUnStaged)</li>
	 * 		<li>méthode appelée lors du resize de la scène (onLayout) : seulement appelé si la variable listenToLayout est à true</li>
	 * 		</ul>
	 * </p>
	 * 
	 * 	
	 * @author n.bush
	 * @since 28 juin 2012
	 * @version 1.0.0
	 * 
	 */
	public class ABitmap extends Bitmap {


		private var _listenToLayout : Boolean;

		/**
		 * Constructeur : attention la classe est abstraite, elle doit donc être étendue mais jamais instanciée seule.
		 */
		public function ABitmap(bitmapData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false) {
			super(bitmapData, pixelSnapping, smoothing);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
		}

		
		/**
		 * @private
		 */
		private function _onRemovedFromStage(event : Event) : void {
			stage.removeEventListener(Event.RESIZE, _onStageResize);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			onUnStaged();
		}

		
		/**
		 * @private
		 */
		private function _onAddedToStage(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
			
			onStaged();
			
			if (_listenToLayout){
				stage.addEventListener(Event.RESIZE, _onStageResize);
				onLayout();
			}
			
		}

		
		/**
		 * @private
		 */
		private function _onStageResize(event : Event) : void {
			onLayout();
		}

		
		//--------------------------------------
		//					LAYOUT
		//--------------------------------------
		
		/**
		 * Méthode à overrider<br />
		 * Cette méthode est appelée quand le clip est ajouté à la scène.
		 * 
		 * @return void
		 * 
		 */
		protected function onStaged() : void {
		}		

		
		/**
		 * Méthode à overrider<br />
		 * Cette méthode est appelée quand le clip est retiré de la scène.
		 * 
		 * @return void
		 * 
		 */

		protected function onUnStaged() : void {
		}		

		
		/**
		 * Méthode à overrider<br />
		 * Cette méthode est appelée quand le stage est redimmensionné.
		 * 
		 * @return void
		 * 
		 */
		protected function onLayout() : void {
		}
		
		
		/**
		 * Défini si la méthode onLayout est appelée lors d'un resize stage (par default false)
		 * 
		 * @default false
		 * 
		 */
		public function get listenToLayout() : Boolean {
			return _listenToLayout;
		}
		
		public function set listenToLayout(b : Boolean):void{
			_listenToLayout = b;
			
			if (stage){
				if (b){
					stage.addEventListener(Event.RESIZE, _onStageResize);
					onLayout();
				}
				else
					stage.removeEventListener(Event.RESIZE, _onStageResize);
			}
		}
	}
}
