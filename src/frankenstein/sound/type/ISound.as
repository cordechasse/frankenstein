/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.sound.type {
	import flash.events.IEventDispatcher;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 4 nov 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * Interface de son pouvant être lu par le SoundPlayer.
	 * </p>
	 * 
	 * @see frankenstein.sound.players.SoundPlayer
	 * 
	 * @author n.bush
	 * @project TweenMaxFunction
	 * @date 4 nov. 2009
	 * 
	 */
	public interface ISound extends IEventDispatcher {

		/**
		 * Force le chargement selon les paramètres passés dans le constructeur.
		 * 
		 */
		function internalLoad() : void;

		
		/**
		 * Joue le son.
		 * 
		 * @param soundIdx
		 * Index de son spécifié par le SoundPlayer.
		 */
		function playSound(idxSound : uint) : void;

		
		/**
		 * Arrête le son.
		 * 
		 * @param soundIdx
		 * Index du son à arrêter.
		 */
		function stop(idxSound : uint) : void;

		
		/**
		 *	Met le son en pause.
		 *	
		 * @param soundIdx
		 * Index du son à mettre en pause.
		 */	
		function pause(idxSound : uint) : void;

		
		/**
		 * Spécifie si le média est chargé
		 * 
		 * @return
		 * Le média est chargé oui / non 
		 */		
		function get isLoaded() : Boolean;

		
		/**
		 * Retourne le volume d'un son.
		 * 
		 * @param soundIdx
		 * Index du son.
		 * 
		 * @return le volume du son.
		 */
		function getVolume(idxSound : uint) : Number;

		
		/**
		 * Définit le volume d'un son.
		 * 
		 * @param soundIdx
		 * Index du son.
		 * 
		 * @param volume
		 * Le volume (entre 0 et 1).
		 * 
		 */		
		function setVolume(idxSound : uint, v : Number) : void;

		
		/**
		 * Retourne les soundOptions.
		 */
		function get soundOptions() : SoundOptions;
	}
}
