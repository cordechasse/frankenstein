/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	
	import flash.display.MovieClip;
	import frankenstein.errors.ArgumentTypeError;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 16 décembre 2008<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour la gestion des frames d'un MovieClip.
	 * </p>
	 * 
	 * 
	 */
	public class UFrame {

		/**
		 * 
		 * Détermine le numéro de frame d'un label.
		 * 
		 * @param target
		 * Le MovieClip où chercher la frame.
		 * 
		 * @param label
		 * Le nom du label à chercher.
		 * 
		 * @return
		 * Le numéro de label ou -1 si le label n'a pas été trouvé.
		 */
		public static function getFrameNumberForLabel(target : MovieClip, label : String) : int {
			var labels : Array = target.currentLabels;
			var l : int = labels.length;
			
			while (l--)
				if (labels[l].name == label)
					return labels[l].frame;
			
			return -1;
		}

		
		/**
		 * Retourne si un label existe dans un MovieClip.
		 * 
		 * @param target
		 * Le MovieClip où tester l'existance de la frame.
		 * 
		 * @param label
		 * Le nom du label à tester.
		 * 
		 */
		public static function doesFramelabelExists(target : MovieClip, label : String) : Boolean {
			return getFrameNumberForLabel(target, label) != -1;
		}
		
		/**
		 * Appele une méthode spécifique quand une frame d'un MovieClip est atteint. (addFrameScript).
		 * 
		 * @param target
		 * Le MovieClip qui contient la frame
		 * 
		 * @param frame
		 * La frame sur laquelle on ajoute le framescript. La valeur peut être le numero de frame (uint) 
		 * ou le nom de frame (String).
		 * 
		 * @param callback
		 * La méthode qui sera appelée lorsque la frame sera atteinte.
		 * 
		 * @return
		 * Retourne si le framescript a bien été ajoutée ou non (non = pas de frame existante)
		 * 
		 * @throws frankenstein.errors.ArgumentTypeError Si le type de frame passé n'est ni un String ni un uint.
		 *  
		 */
		public static function addFrameScript(target : MovieClip, frame : *, callback : Function) : Boolean {
			if (frame is String)
				frame = UFrame.getFrameNumberForLabel(target, frame);
			else if (!(frame is uint))
				throw new ArgumentTypeError('frame');
			
			if (frame == -1 || frame == 0 || frame > target.totalFrames)
				return false;
			
			target.addFrameScript(frame - 1, callback);
			
			return true;
		}

		
		/**
		 * Retire un addFrameScript.
		 * 
		 * @param target
		 * Le MovieClip sur lequel le framescript a été mis.
		 * 
		 * @param frame
		 * La frame sur laquelle on retire le framescript. La valeur peut être le numero de frame (uint) 
		 * ou le nom de frame (String).
		 * 
		 * @throws frankenstein.errors.ArgumentTypeError Si le type de frame passé n'est ni un String ni un uint.
		 *  
		 */
		public static function removeFrameScript(target : MovieClip, frame : *) : void {
			if (frame is String)
				frame = UFrame.getFrameNumberForLabel(target, frame);
			else if (!(frame is uint))
				throw new ArgumentTypeError('frame');
			
			if (frame == -1 || frame == 0 || frame > target.totalFrames)
				return;
			
			target.addFrameScript(frame - 1, null);
		}
	}
}
