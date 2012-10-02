/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.core {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getTimer;
	import frankenstein.events.KeyManagerEvent;
	import frankenstein.time.EnterFrame;
	import frankenstein.tools.UMath;
	import frankenstein.ui.key.KeyCode;
	import frankenstein.ui.key.KeyCombo;
	import frankenstein.ui.key.KeyManager;
	import frankenstein.ui.key.KeySequence;


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> a.lassauzay<br />
	 * 		<b>Date </b> 26 mai 2009<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 		<ul>
	 * 		<li>v1.0.0 by Antoine Lassauzay</li>
	 * 		<li>v1.0.1 by NicoBush : Ajout des raccourcis claviers D, E, B, U, G, G et CTRL + ALT + D</li>
	 * 		<li>v1.0.2 by NicoBush : Changement des codes couleurs pour que ca soit plus "beau"</li>
	 * 		</ul>
	 * 		
	 * </p>
	 * <p>
	 * 		<b>Language Version:</b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version:</b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>Objet permettant d'obtenir des informations sur les performances :
	 * <ul>
	 * 		<li>FPS Moyen sur la denière seconde</li>
	 * 		<li>Taille de la mémoire actuelle</li>
	 * </ul>
	 * </p>		
	 * <p>Le double-clique permet d'afficher plus d'infos :
	 * <ul>
	 * 		<li>Graphique de l'évolution du FPS</li>
	 * 		<li>	Graphique de l'évolution de la mémoire</li>
	 * </ul>
	 * </p>
	 * 
	 * @example
	 * <p>Exemple n°1 : Crée un FPSCounter et l'attache sur le stage</p>
	 * <listing version="3.0" >
	 * 		<pre class="prettyprint">
	 * 		var fpscounter : FPSCounter = new FPSCounter();
	 * 		addChild(fpsCounter);
	 * 		</pre>
	 * </listing>
	 * 
	 * @example
	 * <p>Exemple n°2 : Crée un écouteur sur le stage. <br />
	 * A Chaque fois que les combos CTRL + ALT + D ou la séquence D , E , B , U , G , G sont réalisées, le FPSCounter est affiché/masqué
	 * </p>
	 * <listing version="3.0" >
	 * <pre class="prettyprint">
	 * 		StageReference.stage = stage;
	 * 		FPSCounter.addToStage();
	 * 	</pre>
	 * </listing>
	 * 	
	 * 	
	 * 	@author a.lassauzay
	 * 	@since 26 mai 2009
	 * 	@version 1.0.0 
	 * 	
	 */

	
	public class FPSCounter extends Sprite {

		
		//----------------------------------
		//			CALCULS
		//----------------------------------	
		
		/**
		 * 'Vraie' limite, 25% de + que la mémoire limite
		 */
		private var _memoryTop : Number;

		/**
		 * Taille maximale de la mémoire pour l'affichage des courbes
		 */
		private var _memoryLimit : Number;

		/**
		 * Mémoire actuelle
		 */
		private var _memory : Number = 0;

		/**
		 * Stockage des valeurs mémoires
		 */
		private var _memoryValues : Array;

		/**
		 * Nombre total de frames jouées sur la dernière seconde
		 */
		private var _countFrames : uint;

		/**
		 * Marqueur du dernier enregistrement du temps
		 */
		private var _lastTime : uint;

		/**
		 * FPS Moyen sur la dernière seconde
		 */
		private var _frameRate : uint;

		/**
		 * Frame rate critique
		 */
		private var _criticFrameRate : uint;

		/**
		 * Mémoire vidée
		 */
		private var _flushed : Boolean = false;

		//----------------------------------
		//			AFFICHAGE DES INFOS
		//----------------------------------
		
		/**
		 * Largeur des graphiques
		 */
		private const CHARTS_WIDTH : uint = 116;

		/**
		 * Hauteur des graphiques
		 */
		private const CHARTS_HEIGHT : uint = 100;

		/**
		 * Position en x du dernier pixel dessiné pour le fps
		 */
		private var _lastPixelXfps : int = -1;

		/**
		 * Position en x du dernier pixel dessiné pour le fps
		 */
		private var _lastPixelYfps : int;

		/**
		 * Position en x du dernier pixel dessiné pour le fps
		 */
		private var _lastPixelXmem : int = -1;

		/**
		 * Position en x du dernier pixel dessiné pour le fps
		 */
		private var _lastPixelYmem : int;

		/**
		 * Champ texte d'affichage général
		 */
		private var _tfGeneralInfo : TextField;

		/**
		 * Champ texte d'affichage général
		 */
		private var _tfFpsStage : TextField;

		/**
		 * Champ texte d'affichage général
		 */
		private var _tfFpsMax : TextField;

		/**
		 * Indication fps critique
		 */
		private var _lineFpsMax : Shape;

		/**
		 * Champ texte d'affichage général
		 */
		private var _fpsMin : TextField;

		/**
		 * Canevas pour dessiner la courbe FPS
		 */
		private var _fpsChart : BitmapData;

		/**
		 * Champ texte mémoire maximum
		 */
		private var _tfMemTop : TextField;

		/**
		 * Champ texte mémoire maximum
		 */
		private var _tfMemMax : TextField;

		/**
		 * Indication mémoire max
		 */
		private var _lineMemMax : Shape;

		/**
		 * Champ texte mémoire minimum
		 */
		private var _tfMemMin : TextField;

		/**
		 * Canevas pour dessiner la courbe mémoire
		 */
		private var _memChart : BitmapData;		

		/**
		 * Masquer les graphiques
		 */
		private var _showCharts : Boolean = false;

		//--------------------------------------
		//					STATIC
		//--------------------------------------

		private static var _fpsCounter : FPSCounter;
		private static var _keySeqDebug : KeySequence;
		private static var _keyCombo : KeyCombo;

		/**
		 * Couleurs
		 */
		private static const TEXT_CHARTS : uint = 0x333333;
		private static const LINE_CHARTS : uint = 0x80ab00;
		private static const LINE_CHARTS_ERROR : uint = 0xbe2d00;
		private static const BG_ALL : uint = 0xd9d9d9;

		//----------------------------------
		//			CONSTRUCTEUR
		//----------------------------------
		
		/**
		 * Construit un nouveau FPSCounter.
		 * 
		 * @param memoryLimit
		 * Limite de mémoire, en Mo, au dessus la courbe sera en rouge.
		 * 
		 * @param criticFramerate
		 * Limite de framerate, au dessous, la courbe sera en rouge.
		 * 
		 */
		public function FPSCounter(memoryLimit : Number = 100, criticFramerate : uint = 18) {
			
			_memoryLimit = memoryLimit;
			
			_memoryTop = int(memoryLimit * 1.25);
				
			_criticFrameRate = criticFramerate;	
				
			addEventListener(Event.ADDED_TO_STAGE, _start, false, 0, true);
	
			_addContextMenu();
		}

		
		//----------------------------------
		//			INIT
		//----------------------------------

		private function _start(...args) : void {
			
			removeEventListener(Event.ADDED_TO_STAGE, _start, false);
			addEventListener(Event.REMOVED_FROM_STAGE, flush, false, 0, true);
			
			if(!_flushed) {
				// Dessin du fond
				graphics.beginFill(BG_ALL);
				graphics.drawRect(0, 0, 250, 53 + CHARTS_HEIGHT + 15);
				
				// Champ texte général
				_tfGeneralInfo = new TextField();
				_tfGeneralInfo.width = 248;
				_tfGeneralInfo.selectable = false;
				var f : TextFormat = new TextFormat('_sans', 11, TEXT_CHARTS);
				_tfGeneralInfo.defaultTextFormat = f;
				_tfGeneralInfo.setTextFormat(f);
				_tfGeneralInfo.x = _tfGeneralInfo.y = 1;
				_tfGeneralInfo.text = 'initialisation...';
				addChild(_tfGeneralInfo);
			
				/*
				 * Affichage FPS
				 */
			
				// FPS Actuel		
				_tfFpsStage = new TextField();
				_tfFpsStage.selectable = false;
				_tfFpsStage.defaultTextFormat = new TextFormat('_sans', 9, TEXT_CHARTS);
				_tfFpsStage.text = stage.frameRate + 'fps';
				_tfFpsStage.x = 4;
				_tfFpsStage.y = 19;
				addChild(_tfFpsStage);
				
				// Graphique
				_fpsChart = new BitmapData(CHARTS_WIDTH, CHARTS_HEIGHT, true);
				var bmp : Bitmap = new Bitmap(_fpsChart);
				bmp.y = 33;
				bmp.x = 5;
				addChild(bmp);
				
				// Mémoire max	
				_lineFpsMax = new Shape();
				_lineFpsMax.graphics.lineStyle(1, 0xCCCCCC);
				_lineFpsMax.graphics.moveTo(0, 0);
				_lineFpsMax.graphics.lineTo(CHARTS_WIDTH, 0);
				_lineFpsMax.x = 4;
				_lineFpsMax.y = bmp.y + CHARTS_HEIGHT - (CHARTS_HEIGHT * (_criticFrameRate / stage.frameRate) );
				addChild(_lineFpsMax);
				
				_tfFpsMax = new TextField();
				_tfFpsMax.selectable = false;
				_tfFpsMax.defaultTextFormat = _tfFpsStage.defaultTextFormat;
				_tfFpsMax.text = _criticFrameRate + 'fps';
				_tfFpsMax.y = _lineFpsMax.y - 15;
				_tfFpsMax.x = 4;
				addChild(_tfFpsMax);
				
				// Fps min
				_fpsMin = new TextField();
				_fpsMin.selectable = false;
				_fpsMin.defaultTextFormat = _tfFpsStage.defaultTextFormat;
				_fpsMin.text = '0fps';
				_fpsMin.x = 4;
				_fpsMin.y = bmp.y + CHARTS_HEIGHT;
				addChild(_fpsMin);
				
				/*
				 * Affichage Mémoire
				 */

				var allPosX : int = 130;
			 
				// Graphique
				_memChart = new BitmapData(CHARTS_WIDTH, CHARTS_HEIGHT, true);
				var bmp2 : Bitmap = new Bitmap(_memChart);
				bmp2.y = 33;
				bmp2.x = allPosX;
				addChild(bmp2);
			 
				// Mémoire top
				_tfMemTop = new TextField();
				_tfMemTop.selectable = false;
				_tfMemTop.defaultTextFormat = _tfFpsStage.defaultTextFormat;
				_tfMemTop.text = _memoryTop + 'Mo';
				_tfMemTop.y = 19;
				_tfMemTop.x = allPosX;
				addChild(_tfMemTop);
			 
				// Mémoire max	
				_lineMemMax = new Shape();
				_lineMemMax.graphics.lineStyle(1, 0xCCCCCC);
				_lineMemMax.graphics.moveTo(0, 0);
				_lineMemMax.graphics.lineTo(CHARTS_WIDTH, 0);
				_lineMemMax.x = allPosX;
				_lineMemMax.y = bmp2.y + CHARTS_HEIGHT - (CHARTS_HEIGHT * (_memoryLimit / _memoryTop) );
				addChild(_lineMemMax);
				
				_tfMemMax = new TextField();
				_tfMemMax.selectable = false;
				_tfMemMax.defaultTextFormat = _tfFpsStage.defaultTextFormat;
				_tfMemMax.text = _memoryLimit + 'Mo';
				_tfMemMax.y = _lineMemMax.y - 15;
				_tfMemMax.x = allPosX;
				addChild(_tfMemMax);
				
				// Mémoire min
				_tfMemMin = new TextField();
				_tfMemMin.selectable = false;
				_tfMemMin.defaultTextFormat = _tfFpsStage.defaultTextFormat;
				//_memMin.text = _memoryBase.toFixed(3) + 'Mo';
				_tfMemMin.text = '0Mo';
				_tfMemMin.x = allPosX;
				_tfMemMin.y = bmp2.y + CHARTS_HEIGHT;
				addChild(_tfMemMin);
			
				graphics.beginFill(TEXT_CHARTS);
				graphics.drawRect(bmp.x, bmp.y - 1, bmp.width, bmp.height + 2);
				graphics.drawRect(bmp2.x, bmp2.y - 1, bmp2.width, bmp2.height + 2);
							
				var formMask : Shape = new Shape();
				formMask.graphics.beginFill(TEXT_CHARTS);
				formMask.graphics.drawRect(0, 0, width, 20);
				addChild(formMask);
				mask = formMask;
				
				buttonMode = true;
				mouseChildren = false;
				doubleClickEnabled = true;
			}

			EnterFrame.addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);
			//stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);

			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0, true);
			addEventListener(MouseEvent.DOUBLE_CLICK, _onDblClick, false, 0, true);
			
			_flushed = false;
		}

		
		/**
		 * 
		 * Supprime tous les objets crées par le FPSCounter.<br />
		 * Libère la mémoire utilisée.
		 * 
		 * @return void
		 *  
		 */
		public function flush(...args) : void {
			
			if(!_flushed) {
				removeEventListener(Event.REMOVED_FROM_STAGE, flush, false);
				removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false);
				removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false);
				removeEventListener(MouseEvent.DOUBLE_CLICK, _onDblClick, false);
			
				EnterFrame.removeEventListener(Event.ENTER_FRAME, _onEnterFrame, false);
				//stage.removeEventListener(Event.ENTER_FRAME, _onEnterFrame, false);

				_memoryValues = null;
			
				_fpsChart.dispose();
				_memChart.dispose();
				
				_flushed = true;
			}
		}

		
		//----------------------------------
		//			INTERACTIVITY
		//----------------------------------
		private function _onDblClick(e : MouseEvent) : void {
			
			_showCharts = !_showCharts;

			var formMask : Shape = mask as Shape;
			formMask.graphics.clear();
			formMask.graphics.beginFill(0xFFFFFF);
			
			mask = null;
			
			if(_showCharts)
				formMask.graphics.drawRect(0, 0, width, height);
			else
				formMask.graphics.drawRect(0, 0, width, 20);
	
			mask = formMask;
		}

		
		private function _onMouseDown(e : MouseEvent) : void {
			startDrag();
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false);
			addEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false, 0, true);
		}

		
		private function _onMouseUp(e : MouseEvent) : void {
			stopDrag();
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false);
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 0, true);
		}

		
		//----------------------------------
		//			UPDATE
		//----------------------------------
		private function _onEnterFrame(e : Event) : void {
			
			_countFrames++;
					
			// S'il est écoulé au moins une seconde, on update les infos

			if(getTimer() - 1000 >= _lastTime) {
				/*
				 * FRAMERATE
				 */

				_frameRate = UMath.boundaryRestrict(_countFrames / ((getTimer() - _lastTime) / 1000), 0, stage.frameRate);
				//_frameRate = Math.min(_countFrames / ((getTimer() - _lastTime) / 1000), stage.frameRate);
				_lastTime = getTimer();
				_countFrames = 0;

				/*
				 * MEMOIRE
				 */
				_memory = System.totalMemory / 1048576; 
				 
				if(_memoryValues == null)
					_memoryValues = [];
				
				if(_memoryValues.length > Math.floor(CHARTS_WIDTH * .5))
					_memoryValues.shift();
					
				_memoryValues.push(_memory);	
				
				// Si le graphique ne devient plus lisible
				// on change d'échelle
				if(_memory > _memoryTop * .95) {
					// Réinit
					_memoryTop = int(_memory * 1.25);
										
					_lastPixelXmem = -1;
					_lastPixelYmem = 0;
					
					_memChart.lock();
					
					_memChart.fillRect(new Rectangle(0, 0, CHARTS_WIDTH, CHARTS_HEIGHT), 0xFFFFFFFF);
					
					
					var i : int = 0;
					
					while(i < _memoryValues.length - 1) {
						_memory = _memoryValues[i];
						_drawMem();
						i++;
					}
					_memory = _memoryValues[_memoryValues.length - 1];
					
					_memChart.unlock();
					
					// Mise à jour affichage
					_tfMemTop.text = _memoryTop + 'Mo';
					_lineMemMax.y = 33 + CHARTS_HEIGHT - (CHARTS_HEIGHT * (_memoryLimit / _memoryTop) );
					_tfMemMax.y = _lineMemMax.y - 15;
				}
					
				// Mise à jour affichage
				_updateDisplay();
			}
		}

		
		//----------------------------------
		//			AFFICHAGE STATS
		//----------------------------------
		private function _updateDisplay() : void {

			_tfGeneralInfo.htmlText = '<b>FRAMERATE</b>:' + _frameRate + 'fps (' + stage.frameRate + ')';
			_tfGeneralInfo.htmlText += '<b> <font color="#6f9500">&</font> MEMORY</b>:' + _memory.toFixed(3) + 'Mo';
			
			_drawFps();
					
			_memChart.lock();
			_drawMem();		
			_memChart.unlock();
		}

		
		private function _drawFps() : void {
			
			
			var indFps : Number = _frameRate / stage.frameRate;
			var zoneX : int = CHARTS_WIDTH - 1;
			var zoneY : int = CHARTS_HEIGHT - 1;
			var pX : int = Math.min(_lastPixelXfps + 2, zoneX);
			var pY : int = zoneY + 1 - ( indFps * zoneY );
						
			var color : uint = indFps < (_criticFrameRate / stage.frameRate) ? LINE_CHARTS_ERROR : LINE_CHARTS;
								
			_fpsChart.lock();
			
			// On décale l'image de deux pixels	
			if(_lastPixelXfps == zoneX) {
				_fpsChart.scroll(-2, 0);
				_fpsChart.setPixel(_lastPixelXfps, _lastPixelYfps, 0xFFFFFF);
					
				var i : int = 0;
					
				while(i <= zoneY) {
					_fpsChart.setPixel(_lastPixelXfps - 1, i, 0xFFFFFF);
					i++;	
				}					
			}
				
				
			// Si on a plus d'un pixel d'écart en y, on dessine verticalement
			if( (_lastPixelYfps - pY > 1 || _lastPixelYfps - pY < -1) && _lastPixelXfps > -1) {
				var vectY : int = pY - _lastPixelYfps;
				var middle : int = vectY > 0 ? vectY - 1 : vectY + 1;
				var j : int = vectY;
										
				while(j != 0) {
						
					if(Math.abs(j) > Math.abs(middle)) {
						_fpsChart.setPixel(pX, _lastPixelYfps + j, color);	
					} else {
						_fpsChart.setPixel(pX - 1, _lastPixelYfps + j, color);
					}
							
					vectY > 0 ? j-- : j++;
				}
			} else {
				_fpsChart.setPixel(pX - 1, pY, color);
				_fpsChart.setPixel(pX, pY, color);
			}
			
			_fpsChart.unlock();
														
			_lastPixelXfps = pX;
			_lastPixelYfps = pY;
		}

		
		private function _drawMem() : void {
			
			
			var indMemory : Number = _memory / _memoryTop;
			var zoneX : int = CHARTS_WIDTH - 1;
			var zoneY : int = CHARTS_HEIGHT - 1;
			var pX : int = Math.min(_lastPixelXmem + 2, zoneX);
			var pY : int = zoneY - ( indMemory * zoneY );
							
			var color : uint = _memory > _memoryLimit ? LINE_CHARTS_ERROR : LINE_CHARTS;
			
			// On décale l'image de deux pixels	
			if(_lastPixelXmem == zoneX) {
				_memChart.scroll(-2, 0);
				
				_memChart.setPixel(_lastPixelXmem, _lastPixelYmem, 0xFFFFFF);
							
				var i : int = 0;
					
				while(i <= zoneY) {
					_memChart.setPixel(_lastPixelXmem - 1, i, 0xFFFFFF);
					i++;	
				}
			}
				
				
			// Si on a plus d'un pixel d'écart en y, on dessine verticalement
			if( (_lastPixelYmem - pY > 1 || _lastPixelYmem - pY < -1) && _lastPixelXmem > -1) {

				
				var vectY : int = pY - _lastPixelYmem;
				var middle : int = vectY > 0 ? vectY - 1 : vectY + 1;
				var j : int = vectY;
					
				//trace(vectY);	

				while(j != 0) {
						
					if(Math.abs(j) > Math.abs(middle)) {
						_memChart.setPixel(pX, _lastPixelYmem + j, color);	
					} else {
						_memChart.setPixel(pX - 1, _lastPixelYmem + j, color);
					}
							
					vectY > 0 ? j-- : j++;
				}
			} else {
				_memChart.setPixel(pX - 1, pY, color);
				_memChart.setPixel(pX, pY, color);
			}
												
			_lastPixelXmem = pX;
			_lastPixelYmem = pY;
		}

		
		//--------------------------------------
		//					CONTEXT MENU
		//--------------------------------------

		private function _addContextMenu() : void {
			var menu : ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			var menuClose : ContextMenuItem = new ContextMenuItem("close");
			menuClose.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _hide, false, 0, true);	
			menu.customItems.push(menuClose);
			contextMenu = menu;
		}

		
		private function _hide(e : ContextMenuEvent) : void {
			visible = false;
		}

		
		
		
		//--------------------------------------
		//					STATIC
		//--------------------------------------
		/**
		 * Méthode statique permettant de définir le stage<br />
		 * L'objet va désormais écouter les actions touches suivantes :
		 * <ul> 
		 * 		<li>Combo CTRL + ALT + D</li>
		 * 		<li>Séquence D , E , B , U , G , G</li>
		 * </ul> 
		 * Lorsque la combo/séquence est réalisée, le FPSCounter s'affiche/disparait.<br />
		 * Il faut que la variable StageReference.stage soit au préalable définie.
		 * 
		 * @return void
		 * 
		 * @example
		 * <listing version="3.0" >
		 * <pre class="prettyprint">
		 * 		StageReference.stage = stage;
		 * 		FPSCounter.addToStage();
		 * 	</pre>
		 * </listing>
		 * 
		 */
		public static function addToStage() : void {
			
			//si un fpscounter exsite deja on ne fait rien
			if (_fpsCounter)
				return;
			
			
			_keyCombo = new KeyCombo([KeyCode.CONTROL, KeyCode.ALT, KeyCode.D]);
			_keySeqDebug = new KeySequence([KeyCode.D, KeyCode.E, KeyCode.B, KeyCode.U, KeyCode.G, KeyCode.G]);
			
			
			KeyManager.addKeyCombo(_keyCombo);
			KeyManager.addKeySequence(_keySeqDebug);
			
			
			KeyManager.addEventListener(KeyManagerEvent.COMBO_DOWN, _onComboDown);
			KeyManager.addEventListener(KeyManagerEvent.SEQUENCE_PERFORMED, _onSequencePerformed);
		}

		
		private static function _onSequencePerformed(event : KeyManagerEvent) : void {
			switch (event.keySequence) {
				case _keySeqDebug:
					showHide();
					break;
			}
		}

		
		private static function _onComboDown(event : KeyManagerEvent = null) : void {
			
			if (event.keyCombo != _keyCombo)
				return;
			
			showHide();
		}

		
		/**
		 * Affiche / Masque l'objet en cours
		 * 
		 * @return void
		 */
		public static function showHide() : void {
			if (!_fpsCounter) {
				_fpsCounter = new FPSCounter(100);
				StageReference.stage.addChild(_fpsCounter);
			} else {
				_fpsCounter.visible = !_fpsCounter.visible;
			}
		}
	}
}
