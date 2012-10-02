/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.social {
	import frankenstein.tools.UJavascript;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> Nicolas Bush<br />
	 * 		<b>Date </b> 22 avril 2009<br />
	 * 		<b>Version </b> 1.1.0<br />
	 * 		<b>History </b>
	 * 			<ul>
	 * 				<li>1.0.0 : creation</li>
	 * 				<li>1.1.0 : modification de la méthode share de facebook</li>
	 * 			</ul>
	 * 			
	 * 		
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques permettant de faire des liens vers les partages des reseaux sociaux tels que :
	 * 	<ul>
	 * 		<li>Facebook</li>
	 * 		<li>Blogger</li>
	 * 		<li>Delicious</li>
	 * 		<li>Myspace</li>
	 * 		<li>Flickr</li>
	 * 		<li>Yahoo</li>
	 * 		<li>Twitter</li>
	 * 		<li>Viadeo</li>
	 * 		<li>Digg</li>
	 * 	</ul>
	 * </p>
	 * 
	 */
	public class ViralLinks {
		
		
		/**
		 * Retourne un lien de partage Facebook
		 * 
		 * @params pURL
		 * Url à partager. Elle doit diriger vers une page HTML contenant des metadatas spécifiques pour Facebook.
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function facebookShare( url : String, title : String, popupWidth : uint = 660, popupHeight : uint = 352 ) : void {
			var link : String = "http://www.facebook.com/sharer.php?u=" + encodeURIComponent(url) + "&t=" + encodeURIComponent(title);
			UJavascript.openPopup(link, "facebooksharer", popupWidth, popupHeight);
		}

		/**
		 * Retourne un lien de partage Blogger
		 * 
		 * @params pURL
		 * Url à partager. 
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function getBloggerLink( pTitle : String, pDesc : String, pLink : String ) : String {
			var sLink : String = "http://www.blogger.com/blog_this.pyra?t=" + pDesc + "&u=" + pLink + "&n=" + pTitle;
			return sLink;
		}

		/**
		 * Retourne un lien de partage Delicious
		 * 
		 * @params pURL
		 * Url à partager. 
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function getDeliciousLink( pURL : String, pTitle : String ) : String {
			var sLink : String = "http://del.icio.us/post?url=" + pURL + "&title=" + pTitle;
			return sLink;
		}

		/**
		 * Retourne un lien de partage MySpace
		 * 
		 * @params pURL
		 * Url à partager. 
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function getMyspaceLink( pTitle : String, pDesc : String, pImg : String ) : String {
			var sLink : String = "http://www.myspace.com/index.cfm?fuseaction=postto&t=" + pTitle + "&c=" + pDesc + "&u=" + pImg;
			return sLink;
		}

		/**
		 * Retourne un lien de partage Flickr
		 * 
		 * @params pURL
		 * Url à partager. 
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function getFlickrLink( pImg : String ) : String {
			var sLink : String = "http://www.flickr.com/tools/sendto.gne?url=" + pImg;
			return sLink;
		}

		/**
		 * Retourne un lien de partage Yahoo
		 * 
		 * @params pURL
		 * Url à partager. 
		 * 
		 * @params pTitle
		 * Titre du partage.
		 * 
		 * @params pDesc
		 * Description du partage.
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function getYahooLink( pURL : String, pTitle : String, pDesc : String ) : String {
			var sLink : String = "http://myweb2.search.yahoo.com/myresults/bookmarklet?u=" + pURL + "&t=" + pTitle + "&d=" + pDesc;
			return sLink;
		}

		/**
		 * Retourne un lien de partage Twitter
		 * 
		 * @params pURL
		 * Url à partager. 
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function getTwitterLink( pDesc : String ) : String {
			var sLink : String = "http://twitter.com/home?status=" + encodeURIComponent(pDesc);
			return sLink;
		}

		/**
		 * Retourne un lien de partage Viadeo
		 * 
		 * @params pURL
		 * Url à partager.
		 * 
		 * @params pTitle
		 * Titre du partage. 
		 * 
		 * @params pLanguage
		 * Language du partage. 
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function getViadeoLink( pURL : String, pTitle : String, pLanguage : String = "fr" ) : String {
			var sLink : String = "http://www.viadeo.com/shareit/share/?url=" + pURL + "&title=" + pTitle + "&urllanguage=" + pLanguage;
			return sLink;
		}

		/**
		 * Retourne un lien de partage Digg
		 * 
		 * @params pURL
		 * Url à partager. 
		 * 
		 * @params pTitle
		 * Titre du partage.
		 * 
		 * @params pDesc
		 * Description du partage.
		 * 
		 * @return
		 * L'url de partage. (faire un navigateToUrl)  
		 */
		public static function getDiggLink( pURL : String, pTitle : String,  pDesc : String) : String {
			var sLink : String = "http://digg.com/submit?phase=2&title=" + pTitle + "&bodytext=" + pDesc + "&url=" + pURL;
			return sLink;
		}
	}
}