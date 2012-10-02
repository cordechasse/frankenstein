/*
 * Copyright © CorDeChasse 1999-2011
 */


package frankenstein.display {
	import flash.events.MouseEvent;

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 26 mai 2009<br />
	 * 		<b>Version </b> 1.2.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>1.0.0 by nicobush</li>
	 * 				<li>1.0.2 by nicocrete : Ajout de la méthode publique click()</li>
	 * 				<li>1.1.0 by nicocrete : Déplacement du listener CLICK dans la méthode onStaged</li>
	 * 				<li>1.2.0 by nicobush : Merging de AOverOutMovieClip et AButton<br/> 
	 * 										 Ajout de la condition : si mouseEnabled=false alors les méthodes over/out/click ne sont pas appelées</li>
	 * 			</ul>
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * <p>Classe abstraite à overrider pour créer un bouton "standard".<br />
	 * Cette classe gère : 
	 * <ul>
	 * 		<li>le buttonMode</li>
	 * 		<li>le gotoAndPlay sur le rollover/rollout</li>
	 * 		<li>les méthodes onStaged, onUnStaged, onLayout</li>
	 * </ul>
	 * De plus la classe hérite de AMovieClip, donc elle hérite de toutes ses propriétés et méthodes.
	 * </p>
	 * 
	 * 	
	 * @author n.crete
	 * @since 23 sep 2010
	 * @version 1.1
	 * 
	 */
	public dynamic class AFlexButton extends AFlexSprite {
		
		/**
		 * Label sur lequel se place la timeline lors d'un rollover.
		 */
		public var overLabel : String = "over";
		
		/**
		 * Label sur lequel se place la timeline lors d'un rollout.
		 */
		public var outLabel : String = "out";


		public function AFlexButton(assetClass : Class = null) {
			super(assetClass);
			
			buttonMode = true;
			mouseChildren = false;
		}
		
		//-------------------------------------
		//				STAGED
		//-------------------------------------
		/**
		 * @inheritDoc
		 */
		protected override function onStaged() : void {
			super.onStaged();
			addEventListener(MouseEvent.CLICK, _click, false, int.MAX_VALUE);
			addEventListener(MouseEvent.ROLL_OVER, _over, false, int.MAX_VALUE);
			addEventListener(MouseEvent.ROLL_OUT, _out, false, int.MAX_VALUE);
		}
		
		
		/**
		 * @inheritDoc
		 */
		protected override function onUnStaged() : void {
			super.onUnStaged();
			removeEventListener(MouseEvent.CLICK, _click);
			removeEventListener(MouseEvent.ROLL_OVER, _over);
			removeEventListener(MouseEvent.ROLL_OUT, _out);
		}
		
		
		
		//-------------------------------------
		//				OVER / OUT
		//-------------------------------------
		
		/**
		 * @private
		 */
		protected function _over(e : MouseEvent) : void {
			if (mouseEnabled)
				over();
		}

		
		/**
		 * @private
		 */
		protected function _out(e : MouseEvent) : void {
			if (mouseEnabled)
				out();
		}
		
		
		
		/**
		 * La méthode over est appelée, lorsqu'il y a un rollover sur le clip
		 */
		public function over() : void {
			_asset.gotoAndPlay(overLabel);
		}

		/**
		 * La méthode out est appelée, lorsqu'il y a un rollout sur le clip
		 */
		public function out() : void {
			_asset.gotoAndPlay(outLabel);
		}
		
		
		
		
		//-------------------------------------
		//				CLICK
		//-------------------------------------
		
		
		/**
		 * @private
		 */
		private function _click(event : MouseEvent) : void {
			if (mouseEnabled)
				click();
		}
		
		/**
		 * La méthode appelée lorsqu'il y a un click sur le bouton
		 */
		public function click() : void {
		}


		
		
		
	}
}
