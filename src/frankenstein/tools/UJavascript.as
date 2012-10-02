/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 23 mars 2010<br />
	 * 		<b>Version </b> 1.0.2<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour les appels javascripts.
	 * </p>
	 * 
	 * 
	 */
	public class UJavascript extends EventDispatcher {

		/**
		 * Ouvre une popup. Cette méthode permet de faire des popup sous Safari 4.<br />
		 * <br />
		 * Safari bloque les popups quand l'appel est fait depuis un click depuis flash.<br /> 
		 * Pour permettre l'ouverture de la popup, sous Safari, on lance l'ouverture en javascript avec
		 * un simple javascript <code>window.open</code>. Si l'ouverture a échoué, on ouvre la popup avec
		 * un <code>navigateToUrl</code> en passant en paramètre GET le width et le height spécifié.<br />
		 * <br />
		 * Attention, il faut que le paramètre "name" dans les attributs HTML du swf soit défini (même valeur 
		 * que celui de l'id).<br />
		 * Il faut également que la propriété allowScriptAccess soit à "always" ou "sameDomain".
		 * 
		 * 
		 * @param url
		 * Url de la page (String ou URLRequest).
		 * 
		 * @param title	
		 * Identifiant de la popup : celui-ci ne doit pas contenir d'espace ni de caractères spéciaux.
		 * 
		 * @param width	
		 * Largeur de la popup.
		 * 
		 * @param height
		 * Hauteur de la popup.
		 * 
		 * @param toolbar
		 * Ajoute la toolbar.
		 * 
		 * @param scrollbar	
		 * Ajoute la scrollbar.
		 * 
		 * @param resizable	
		 * Popup redimmensionnable.
		 * 
		 * @param location
		 * Affiche la zone d'adresse
		 * 
		 * @param directories
		 * Affiche la barre de liens
		 * 
		 * @param menubar
		 * Affiche la barre de menu
		 * 
		 * @param status
		 * Affiche la barre de statut
		 * 
		 */
		public static function openPopup(urllink : String, title : String, width : Number, height : Number, toolbar : Boolean = false, scrollbars : Boolean = true, resizable : Boolean = true, location : Boolean = false, directories : Boolean = false, menubar : Boolean = false, status : Boolean = false) : void {
			trace("[UJavascript]", "openPopup", "call");
			var js : XML = <script>
			<![CDATA[
			function openPopup(idSwf, urllink, title, width, height, toolbar, scrollbars, resizable, location, directories, menubar, status){
				var paramsWindow = "height=" + String(height);
				paramsWindow += ",width=" + String(width);
				paramsWindow += ",toolbar=" + (toolbar? "yes" : "no");
				paramsWindow += ",scrollbars=" + (scrollbars? "yes" : "no");
				paramsWindow += ",resizable=" + (resizable? "yes" : "no");
				paramsWindow += ",location=" + (location? "yes" : "no");
				paramsWindow += ",directories=" + (directories? "yes" : "no");
				paramsWindow += ",menubar=" + (menubar? "yes" : "no");
				paramsWindow += ",status=" + (status? "yes" : "no");
			
				
				var newWindow = window.open(urllink, title, paramsWindow);
				
				if (newWindow){
					newWindow.focus();
				}
				else {
					document.getElementById(idSwf).openPopupError(urllink, width, height);
				}
			}
			]]>
			</script>;
			
			
			if (ExternalInterface.available){
				ExternalInterface.addCallback("openPopupError", _onErrorOpeningPopup);
				ExternalInterface.call(js, ExternalInterface.objectID, urllink, title, width, height, toolbar, scrollbars, resizable, location, directories, menubar, status);
				
			}
			else {
				var paramsWindow : String = "height=" + String(height);
				paramsWindow += ",width=" + String(width);
				paramsWindow += ",toolbar=" + (toolbar? "yes" : "no");
				paramsWindow += ",scrollbars=" + (scrollbars? "yes" : "no");
				paramsWindow += ",resizable=" + (resizable? "yes" : "no");
				paramsWindow += ",location=" + (location? "yes" : "no");
				paramsWindow += ",directories=" + (directories? "yes" : "no");
				paramsWindow += ",menubar=" + (menubar? "yes" : "no");
				paramsWindow += ",status=" + (status? "yes" : "no");
				
				var jscommand : String = "var newWindow=window.open('" + urllink + "','" + title + "','" +paramsWindow + "');newWindow.focus();void(0);";
				var request : URLRequest = new URLRequest("javascript:" + jscommand);             
				navigateToURL(request, "_self");	
			}
		}
		
		
		private static function _onErrorOpeningPopup(urllink : String, width : Number, height : Number) : void {
		    trace("[UJavascript]", "_onErrorOpeningPopup");
		    var request : URLRequest = new URLRequest(urllink + (urllink.indexOf("?") == -1 ? "?" : "&") + "height=" + height + "&width=" + width);
		    navigateToURL(request, "_blank");
		}

	
		/**
		 * Ouvre une alerte javascript.
		 * 
		 * @param message
		 * Message d'alerte à afficher.
		 * 
		 * @throws Error Erreur si l'externalInterface est inactive
		 */
		public static function alert(message : String) : void {
			if (ExternalInterface.available) {
				ExternalInterface.call("alert", message);
			}
			else {
				throw new Error("ExternalInterface is not avaible");
			}
		}
	}
}
