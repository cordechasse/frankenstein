package frankenstein.display {
	import flash.display.MovieClip;

	/**
	 * @author cordechasse
	 * @project Franche comte - originale experience
	 * @date 25 janv. 2012
	 */
	public class AFlexSprite extends ASprite {
		
		protected var _asset : MovieClip;
		
		public function AFlexSprite(className : Class) {
			super();
			
			if( className != null )
			{
				_asset = new className();
				addChild(_asset);
			}
			
		}
	}
}
