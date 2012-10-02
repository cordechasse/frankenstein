/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.ui.printer {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 16 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>Classe qui permet de faciliter l'impression.<br />
	 * Elle permet de gérer : 
	 * 	<ul>
	 * 		<li>Les fonds de pages (entête et pied de pages).</li>
	 * 		<li>L'orientation.</li>
	 * 		<li>Le multipage (automatisé).</li>
	 * 	</ul>
	 * </p>
	 * <p>
	 * <p>&nbsp;</p>
	 * <b>Logique de fonctionnement : </b><br />
	 * <br />
	 * <u>1.Fond de page (papier d'impression) : classe PaperPrint</u><br />
	 * Pour chaque impression on a toujours un fond de page. Ce fond de page est composé (généralement) d'un 
	 * entête et pied de page avec logo. Le pied de page peut comporter un paging spécifiant le numéro de page 
	 * (par ex: 1/5).<br />
	 * Le contenu des pages (généralement textes + images) sont positionnés dans la page dans une zone.<br />
	 * Cette zone est appelé "safeZone".
	 * </p>
	 * <p>
	 * <u>2.Contenu des pages : classe PrintPage</u><br />
	 * Le contenu des pages est composé généralement de textes et d'images. Etant donné que la zone d'impression 
	 * diffère selon les imprimantes, ce n'est pas sûr que le contenu demandé rentre dans une seule page.<br /> 
	 * Pour palier à ce problème, on crée itérativement plusieurs pages jusqu'à ce que tous les contenus soient
	 * insérés.
	 * <p>Ex : <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. On crée une nouvelle page, et on insère le texte "Salut tu vas bien".<br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--> La page est trop petite et "tu vas bien" ne rentre pas.<br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. On crée une nouvelle page, et on insère le texte "tu vas bien".<br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--> La page est trop petite et "bien" ne rentre pas.<br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. On crée une nouvelle page, et on insère le texte "bien".<br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--> Tout le contenu est rentré.<br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. On lance l'impression des 3 pages.<br />
	 * </p>
	 * <p> 
	 * Concrètement en code :<br />
	 * La page doit implémenter la classe <code>PrintPage</code>.<br />
	 * C'est la méthode <code>insertContent</code> qui insère le contenu spécifié dans la zone<br />
	 * La méthode <code>insertContent</code> renvoie un objet de type <code>PrintPageResult</code> qui définit si
	 * le contenu rentre dans la zone, et quel est le contenu restant à intégrer dans la page suivante.
	 * </p>
	 * <br />
	 * Mode de fonctionnement interne de la classe Printer pour la gestion du multipage :</p> 
	 * <p align='center'><img src="../../../images/schemaPrintPage.jpg" /></p>
	 * 
	 * <p>
	 * Les appels des <code>new PrintPage()</code> et les appels aux méthodes <code>insertContent</code> sont gérées 
	 * automatiquement par la classe Printer.
	 * </p>
	 * 
	 * <p>
	 * <b>En conclusion, pour gérer une impression, il faut : </b>
	 * <ul>
	 * 	<li>Coder le resize du PaperPrint</li>
	 * 	<li>Créer des PrintPage dans lequels on a prévu les appels recursifs de la méthode <code>insertContent</code></li>
	 * 	<li>Construire le tout grâce à la classe <code>Printer</code></li> 
	 * </ul>
	 * 
	 * 
	 * @example
	 * Classe principale Main.as :
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		//on crée un objet Printer auquel on spécifie l'orientation
	 * 		var printer = new Printer(PrintJobOrientation.LANDSCAPE);
	 * 		
	 * 		//on spécifie la classe du PaperPrint
	 * 		printer.paperPrintClass = PaperPrintPerso;
	 * 		
	 * 		//on ajoute la page
	 * 		printer.addPage(PrintPagePerso, ["mon contenu texte", bitmapDataImage]);
	 * 		
	 * 		//on lance l'impression
	 * 		printer.print();
	 * 	</pre>
	 * </listing>
	 * <br />
	 * Classe du fond PaperPrintPerso.as (La classe est linkée à un clip composé d'un background, logo et 
	 * txtPaging) :
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 	package {
	 * 		import frankenstein.ui.printer.APaperPrint;
	 * 		import flash.display.Sprite;
	 * 		import flash.text.TextField;
	 * 		
	 * 		//la classe étend APaperPrint
	 * 		public class PaperPrintPerso extends APaperPrint {
	 * 			public var background : Sprite;
	 * 			public var logo : Sprite;
	 * 			public var txtPaging : TextField;
	 * 			
	 * 			//constructeur dans lequel on ne fait rien de plus
	 * 			public function PaperPrintPerso() {
	 * 				super();
	 * 			}
	 * 			
	 * 			//on override la méthode setSize
	 * 			public override function setSize(width : Number, height : Number):void {
	 * 				
	 * 				//on resize le background	
	 * 				background.width = width;
	 * 				background.height = height;
	 * 				
	 * 				//on repositionne le logo
	 * 				logo.x = width / 2;
	 * 				logo.y = height - 100;
	 * 				
	 * 				//on repositionne le texte pour le paging (page 1 / 5)
	 * 				txtPaging.x = width - 50;
	 * 				txtPaging.y = height - 50;
	 * 				
	 * 				//on met à jour la safeZone (zone dans laquelle sera insérée le contenu)
	 * 				_safeZone.x = 36;
	 * 				_safeZone.y = 83;
	 * 				_safeZone.width = width - 36 * 2;
	 * 				_safeZone.height = height - 83 - 120;
	 * 			}
	 * 			
	 * 			//on override la méthode set pageNumber
	 * 			public override function setPageNumber(num : uint, totalPages : uint) : void {
	 * 				//on redéfini le texte du txtPaging
	 * 				txtPaging.text = "Page " + num + "/" + totalPages;
	 * 			}
	 * 		}
	 * 	}
	 * 	</pre>
	 * </listing>
	 * <br />
	 * Classe de la page PrintPagePerso.as (La classe est linkée à un clip composé d'un champs texte "txt") :
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 	package {
	 * 	
	 * 		import frankenstein.tools.UTextField;
	 * 		import frankenstein.ui.printer.IPrintPage;
	 * 		import frankenstein.ui.printer.PrintPageResult;
	 * 		
	 * 		import flash.display.MovieClip;
	 * 		import flash.text.TextField;
	 * 		
	 * 		public class PrintPageMustela extends MovieClip implements IPrintPage {
	 * 		
	 * 			public var txt : TextField;
	 * 			
	 * 			// On crée une méthode insertContent qui insère un contenu (décrit dans params) dans la 
	 * 			// zone de taille pageWidth x pageHeight
	 * 			// La méthode renvoie un objet PrintPageResult qui décrit si le contenu est rentré 
	 * 			// dans la zone, et si ce n'est pas le cas, le contenu restant
	 * 			public function insertContent(pageWidth : Number, pageHeight : Number, params : * = null) : PrintPageResult{
	 * 				
	 * 				//on resize le texte selon la taille
	 * 				txt.width = pageWidth;
	 * 				txt.height = pageHeight;
	 * 				
	 * 				//on insere le texte dans le champs
	 * 				txt.text = params;
	 * 				
	 * 				// si le champs texte déborde, on récupère le texte restant  
	 * 				// et on renvoie un PrintPageResult avec la propriété pageFits à false
	 * 				// et en paramètre le texte restant 
	 * 				if (UTextField.hasOverFlow(txt)){
	 * 					var textLeft : String = UTextField.removeOverFlow(txt, "");
	 * 					return new PrintPageResult(false, textLeft);
	 * 				}
	 * 				
	 * 				// ici le texte est rentré entièrement
	 * 				// on retourne l'objet PrintPageResult avec la propriété pageFits à true
	 * 				return new PrintPageResult(true);
	 * 			}
	 * 		}
	 * 	}
	 * 	</pre>
	 * </listing>
	 * 
	 * <p>
	 * <b>NB:</b><br />
	 * Tous les objets passés à la classe PrintPage doivent déjà être chargés. Ainsi, on passera un BitmapData
	 * et non l'url d'une image.
	 * </p>
	 * 
	 */
	 public class Printer extends Sprite {
		
		private var _paperPrintClass : Class;
		private var _contents : Array;
		private var _contentsParams : Array;
		private var _orientation : String;
		
		private var _safeZone : Rectangle;
		private var _numPage : Number;
		
		private var _preview : Array;
		
		private static const MAX_PAGE : uint = 10;
		
		/**
		 * Crée un nouvel objet Printer
		 * 
		 * @param orientation
		 * L'orientation de la page définit par les constantes PrintJobOrientation
		 * 
		 * @see flash.printing.PrintJobOrientation
		 */
		public function Printer(orientation : String):void {
			_contents = [];
			_contentsParams = [];
			_orientation = orientation;
		}

		/**
		 * Classe du papier d'impression, cette classe doit obligatoirement étendre la classe PaperPrint
		 * 
		 * @see frankenstein.ui.printer.PaperPrint
		 */
		public function set paperPrintClass(c : Class):void {
			_paperPrintClass = c;
		}
		
		
		//--------------------------------------
		//					ADD / REMOVE PAGE
		//--------------------------------------
		/**
		 * Ajoute une nouvelle page à la liste des pages à imprimer.
		 * 
		 * @param printPageClass
		 * La classe de la page. Elle doit obligatoirement implémenter IPrintPage
		 * 
		 * @param initParams
		 * Les contenus à intégrés dans la classe. Ils sont passés dans un tableau.
		 * 
		 * @return
		 * L'index de la page insérée.
		 * 
		 * @see frankenstein.ui.printer.IPrintPage
		 * 
		 */
		public function addPage(printPageClass : Class, initParams : Array):uint {
			_contents.push(printPageClass);
			_contentsParams.push(initParams);
			return 	_contents.length;
		}
		
		
		/**
		 * Retire une page.
		 * 
		 * @param pageIdx
		 * L'index de la page à supprimer.
		 * 
		 */
		public function removePage(pageIdx : uint):void {
			_contents.slice(pageIdx, 1);
			_contentsParams.slice(pageIdx, 1);
		}

		
		//--------------------------------------
		//					PRINT
		//--------------------------------------
		/**
		 * Lance l'impression.
		 * 
		 * @param printAsBitmap
		 * L'impression doit-elle se faire en bitmap.
		 * 
		 */
		public function print(printAsBitmap : Boolean = false):void{
			var pj : PrintJob = new PrintJob();
			if (pj.start()){
			
				var pageWidth : uint = pj.pageWidth;
				var pageHeight : uint = pj.pageHeight;
				var orientation : String = pj.orientation;
			
				_safeZone = _getSafeZone(orientation, pageWidth, pageHeight);
				_numPage = 1;
			
				var printOptions : PrintJobOptions = new PrintJobOptions();
				printOptions.printAsBitmap = printAsBitmap;	
				
				
				_preview = [];
				
				var currentPage : Sprite;
				
				//on construit toutes les pages	
				for (var i:uint=0; i<_contents.length; i++){
					
					var printResult : PrintPageResult = new PrintPageResult(false, _contentsParams[i]);
					var tour : uint = 0;
					
					while (!printResult.pageFits && tour < MAX_PAGE){
						var page  : IPrintPage = new _contents[i]();
						printResult = page.insertContent(_safeZone.width, _safeZone.height, printResult.params);
						
						currentPage = _getFinalPage(page, orientation, pageWidth, pageHeight);
						_preview.push(currentPage);
						
						//pj.addPage(currentPage, null, printOptions);
						
						tour++;
					}
				}
			
				//on reboucle pour passer les bons parametres de numéro de page.
				var numPages : uint = 	_preview.length;
				for (var j : uint = 0; j < numPages; j++) {
					currentPage = _preview[j];
					var paperPrint : APaperPrint = APaperPrint(Sprite(currentPage.getChildByName("contentPage")).getChildByName("paperPrint"));
					if (paperPrint){
						paperPrint.setPageNumber(j + 1, numPages);
					}
					pj.addPage(currentPage, null, printOptions);
				}
			
				
				pj.send();
			}
			else {
				throw (new Error("can't open print window"));
			}
		}
		
		
		private function _getFinalPage(pageContent : IPrintPage, orientation : String, pageWidth : Number, pageHeight : Number):Sprite{
			
			var finalpage : Sprite = new Sprite();
			var contentPage : Sprite = new Sprite();
			contentPage.name = "contentPage";
			finalpage.addChild(contentPage);
			
			//on rotationne si l'orientation demandée est differente de celle specifiée
			if (_orientation != orientation){
				contentPage.rotation = -90;
				contentPage.y = pageHeight;
			}
			
			var paperPrint : APaperPrint;
			//on ajoute le paperprint
			if (_paperPrintClass != null){
				paperPrint = new _paperPrintClass();
				paperPrint.name = "paperPrint";
				paperPrint.setSize(_orientation == orientation ? pageWidth : pageHeight, _orientation == orientation ? pageHeight : pageWidth);
				//paperPrint.setPageNumber(_numPage);
				contentPage.addChild(paperPrint);
			}
			
			//on positionne la page de contenu et on l'ajoute
			DisplayObject(pageContent).x = _safeZone.x;
			DisplayObject(pageContent).y = _safeZone.y;
			contentPage.addChild(DisplayObject(pageContent));
			
			
			_numPage++;
			
			return finalpage;
		}
		
		
		
		
		private function _getSafeZone(orientation : String, pageWidth : Number, pageHeight : Number) : Rectangle {
			
			var paperPrint : APaperPrint;
			//on ajoute le paperprint
			if (_paperPrintClass != null){
				paperPrint = new _paperPrintClass();
				paperPrint.setSize(_orientation == orientation ? pageWidth : pageHeight, _orientation == orientation ? pageHeight : pageWidth);
			}
			
			//on ajoute le contenu
			var safeZone : Rectangle;
			if (_paperPrintClass == null){
				safeZone = new Rectangle(0, 0, _orientation == orientation ? pageWidth : pageHeight, _orientation == orientation ? pageHeight : pageWidth);
			}
			else {
				safeZone = (paperPrint as APaperPrint).safeZone; 
			}
			
			return safeZone.clone();
		}
		
		
		
		/**
		 * Tableau de clip des pages générées.
		 * Permet de visualiser les pages générés sans avoir à lancer l'impression.
		 */
		public function get preview():Array{
			return _preview;
		}
		
		
		
	}
}
