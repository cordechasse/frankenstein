/*
 * Copyright © CorDeChasse 1999-2011
 */
package frankenstein.core {
	
	
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import frankenstein.net.Init;


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 31 juil 08<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>1.0.0 by nicobush</li>
	 * 				<li>1.0.1 by jonas : Modification du titre homeMade + gestion du Mac</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Redéfini le ContextMenu du site (click droit sur le flash) : 
	 * <ul>
	 * 		<li>retire les éléments par défaut</li>
	 * 		<li>ajoute l'entrée "homemade by cordechasse(s)"</li>
	 * 		<li>possibilité d'ajouter le FPSCounter dans la liste</li>
	 * </ul>
	 * </p>
	 * 
	 * @see frankenstein.net.Init
	 * @see frankenstein.core.FPSCounter
	 * 	
	 * @author n.bush
	 * @since 31 juil. 08
	 * @version 1.0.1
	 */ 
	public class CordechasseContextMenu {

		/**
		 * Message de base affiché par défaut
		 */
		public static var HOME_MADE : String = "Homemade by cordechasse";
		public static var HOME_MADE_MAC : String = "Homemade by cordechasse";
		
		/**
		 * Lien du message HomeMade by 
		 */
		public static var LINK : String = "http://blog.cordechasse.fr";

		private static var _cible : InteractiveObject;
		
		/**
		 * Défini le context menu du clip cible (en général, on utilise celui du root).
		 * 
		 * @param cible
		 * La cible du context menu.
		 * 
		 * @param isClickable
		 * Le message par défaut est cliquable oui / non.
		 * .
		 * @param enableDebugMenu
		 * Possibilité d'afficher le FPSCounter dans la liste.
		 * (uniquement si on est dans le domaine défini en mode developpement dans le Init)
		 * 
		 */
		public static function setMenu(cible : InteractiveObject, isClickable : Boolean, enableDebugMenu : Boolean = true) : void {
			
			try {
				_cible = cible;
				
				var isMac : Boolean = Capabilities.os.toLowerCase().indexOf("mac") != -1;
				
				var menu : ContextMenu = new ContextMenu();
				menu.hideBuiltInItems();

				var ctxMenu : ContextMenuItem = new ContextMenuItem(isMac? HOME_MADE_MAC:HOME_MADE);
				if (isClickable) {
					ctxMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _goToWebsite, false, 0, true);	
				}
				
				menu.customItems.push(ctxMenu);
				
				if (enableDebugMenu && Init.isDevEnvironnement()){
					//cible.root.addEventListener(type, listener)
					var menuFPS : ContextMenuItem = new ContextMenuItem("Debug : FPS");
					menuFPS.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _showFPS, false, 0, true);
					menu.customItems.push(menuFPS);
				}
				
				cible.contextMenu = menu;
			}
			catch (err : Error) {
			}
		}
		
		/**
		 * Ajoute un item dans le ContextMenu
		 * 
		 * @param item l'item à ajouter
		 */
		public static function addMenu(item : ContextMenuItem):void{
			var menu : ContextMenu = _cible.contextMenu;
			menu.customItems.push(item);
			_cible.contextMenu = menu;
		}
		

		private static function _showFPS(e : ContextMenuEvent) : void {
			FPSCounter.addToStage();
			FPSCounter.showHide();
		}
				
		private static function _goToWebsite(e : ContextMenuEvent) : void {
			var req : URLRequest = new URLRequest(LINK);
			navigateToURL(req);
		}
		
	}
}
