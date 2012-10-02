/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.core {
	
	import flash.display.Stage;
	import frankenstein.errors.StageReferenceError;


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> Bruno Cherios<br />
	 * 		<b>Date </b> 18 mars 2010<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe statique permettant de définir une référence globale au stage.<br />
	 * 	Cette référence doit être définie pour le bon fonctionnement des classes : 
	 * 	<ul>
	 * 		<li>UFlashvars</li>
	 * 		<li>FPSCounter</li>
	 * 		<li>Inactivity</li>
	 * 		<li>KeyManager</li>
	 * 		<li>MacMouseWheel</li>
	 * 		<li>...</li>
	 * 	</ul>
	 * </p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		StageReference.stage = stage;
	 * 	</pre>
	 * </listing>
	 * 
	 * @see frankenstein.tools.UFlashvars
	 * @see FPSCounter
	 * @see frankenstein.time.Inactivity
	 * @see frankenstein.ui.key.KeyManager
	 * @see frankenstein.ui.osx.MacMouseWheel
	 * 
	 */
	public class StageReference {
		
		private static var _stage : Stage;
		
		public static function get stage():Stage{
			if (!_stage){
				throw (new StageReferenceError());
			}
			return _stage;	
		}
		
		
		public static function set stage(s : Stage) : void {
			_stage = s;
		}
		
		
		
	}
}
