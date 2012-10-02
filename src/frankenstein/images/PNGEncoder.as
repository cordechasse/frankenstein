/*
 * Copyright © CorDeChasse 1999-2011
 */
 
 package frankenstein.images {
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	/**
	 * Évènement diffusé lorsque l'encodage asynchrone est terminé.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Évènement diffusé lorsque l'encodage aSync est en cours.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]

	/**
	 * 	 
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> NicoBush<br />
	 * 		<b>Date </b> 10 août 2010<br />
	 * 		<b>Version </b> 1.1.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>v1.0.0 by Adobe</li>
	 * 				<li>v1.1.0 by NicoBush : gros update perfo + ajout de la méthode encodeAsync</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * Classe qui convertit un BitmapData en PNG valide.
	 * 
	 */	
	public class PNGEncoder extends EventDispatcher {

		private var _crcTable : Array;
		private var _IDAT : ByteArray;
		private var _sourceBitmapData : BitmapData;
		
		private var _transparent : Boolean;
		private var _width : int;
		private var _height : int;
		private var _y : int;
		private var _png : ByteArray;
		
		private var _timerASync : Timer;
		private var _blocksPerIteration : int = 20;

		
		 /**
		 * Crée un PNGEncoder.
		 */
		public function PNGEncoder() {
			super();
			_initializeCRCTable();
		}
		
		
		private function _initializeCRCTable() : void {
			_crcTable = [];
       
			var n : uint;
			var c : uint;
			var k : uint;
       		
			while (n < 256) {
				c = n;
				k = 0;
				while (k < 8) {
					if (c & 1)
                          c = uint(uint(0xedb88320) ^ uint(c >>> 1));
                      else
                          c = uint(c >>> 1);
					k++;
				}
				_crcTable[n] = c;
				n++;
			}
		}

		/**
		 * Encode le BitmapData au format PNG.
		 *
		 * @param bitmapData
		 * Le BitmapData qui sera convertit au format PNG.
		 * 
		 * @return
		 * Un ByteArray représentant l'image au format PNG.
		 * 
		 */	
		public function encode(bitmapData : BitmapData) : ByteArray {
			_internalEncode(bitmapData.clone(), false);
			return _png;
		}
		
		
		/**
		 * Encode le BitmapData en mode asynchrone empèchant le système de "friser".<br />
		 * Attention, l'appel de script pour sauvegarder l'image, 
		 * ne pourra pas se faire sur l'évènement COMPLETE : une sécurité
		 * de Flash oblige un évènement utilisateur pour accepter l'envoi (Click par ex).
		 * 
		 * @param bitmapData
		 * Le BitmapData qui sera convertit au format PNG.
		 * 
		 * @return
		 * Un ByteArray représentant l'image au format PNG.
		 * 
		 */	
		public function encodeAsync(bitmapData : BitmapData) : void {
			_internalEncode(bitmapData.clone(), true);
		}
		
		
		private function _internalEncode(source : Object, aSync : Boolean) : void {

			// The source is either a BitmapData or a ByteArray.
			_sourceBitmapData = source as BitmapData;
			_sourceBitmapData.lock();
			
			_transparent = source.transparent;
			_width = source.width;
			_height = source.height;

			// Create output byte array
			_png = new ByteArray();

			// Write PNG signature
			_png.writeUnsignedInt(0x89504E47);
			_png.writeUnsignedInt(0x0D0A1A0A);

			// Build IHDR chunk
			var IHDR : ByteArray = new ByteArray();
			IHDR.writeInt(_width);
			IHDR.writeInt(_height);
			IHDR.writeByte(8); // bit depth per channel
			IHDR.writeByte(6); // color type: RGBA
			IHDR.writeByte(0); // compression method
			IHDR.writeByte(0); // filter method
			IHDR.writeByte(0); // interlace method
			_writeChunk(_png, 0x49484452, IHDR);

			// Build IDAT chunk
			_IDAT = new ByteArray();
			_y = 0;

			
			if (aSync){
				_startASync();
			}
			else {
				 _start();
			}
		}
		
		

		
		//--------------------------------------
		//					ASYNC
		//--------------------------------------
		private function _startASync() : void {
			
			_killTimer();
			
			_timerASync = new Timer(10);
			_timerASync.addEventListener(TimerEvent.TIMER, _generateBlock);
			_timerASync.start();
			
			_generateBlock();
		}
		
		
		private function _killTimer() : void {
			if (_timerASync){
				_timerASync.stop();
				_timerASync.removeEventListener(TimerEvent.TIMER, _generateBlock);
				_timerASync = null;
			}
		}

		
		
		private function _generateBlock(event : TimerEvent = null) : void {
			var i : uint;
			while (i < _blocksPerIteration){
				writeRow();
				_y++;

				if(_y >= _height) {
					_killTimer();
					_sourceBitmapData.unlock();
					_sourceBitmapData.dispose();
					_sourceBitmapData = null;
					
					_completeWrite();
					dispatchEvent(new Event(Event.COMPLETE));
					break;
				}
			
				i++;
			}
		}
		
		
		//--------------------------------------
		//					NORMAL
		//--------------------------------------
		
		private function _start() : void {
			while (_y < _height){
				writeRow();
				_y++;
			}
			_completeWrite();
			
				
			_sourceBitmapData.unlock();
			_sourceBitmapData.dispose();
			_sourceBitmapData = null;	
		}

		
		private function _completeWrite() : void {
			_IDAT.compress();
			_writeChunk(_png, 0x49444154, _IDAT);

			// Build IEND chunk
			_writeChunk(_png, 0x49454E44, null);
			// return PNG
			_png.position = 0;
		}

		
		
		private function writeRow() : void {
			_IDAT.writeByte(0); // no filter
			
			var x : int;
			var pixel : uint;

			if (!_transparent) {
				while (x < _width) {
					pixel = _sourceBitmapData.getPixel(x, _y);
                	
					_IDAT.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) | 0xFF));
					x++;
				}
			} else {
				
				while (x < _width) {
					pixel = _sourceBitmapData.getPixel32(x, _y);
					
					_IDAT.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) | (pixel >>> 24)));
					x++;
				}
			}

			var e : ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			e.bytesLoaded = _y;
			e.bytesTotal = _height;
			dispatchEvent(e);
		}

		
		private function _writeChunk(png : ByteArray, type : uint, data : ByteArray) : void {
			// Write length of data.
			var len : uint = 0;
			if (data)
                  len = data.length;

			png.writeUnsignedInt(len);
 
			// Write chunk type.
			var typePos : uint = png.position;
			png.writeUnsignedInt(type);

			// Write data.
			if (data)
                  png.writeBytes(data);

			// Write CRC of chunk type and data.
			var crcPos : uint = png.position;
			png.position = typePos;
			var crc : uint = 0xFFFFFFFF;


			var i : uint = typePos;
			while (i < crcPos){
				crc = uint(_crcTable[(crc ^ png.readUnsignedByte()) & uint(0xFF)] ^ uint(crc >>> 8));
				i++;
			}
			
			crc = uint(crc ^ uint(0xFFFFFFFF));
			png.position = crcPos;
			png.writeUnsignedInt(crc);
		}
		
		//--------------------------------------
		//					GETTER
		//--------------------------------------
		/**
		 * Retourne le ByteArray de l'image encodé.
		 */	
		public function get encodedImageData() : ByteArray {
			return _png;
		}
		
		//--------------------------------------
		//					BLOCKS / ITERATION
		//--------------------------------------
		
		/**
		 * Définit le nombre blocks à faire toutes les 10ms (Nombre entre 1 et 256)
		 * 
		 * @default 20
		 */
		public function get blocksPerIteration() : int {
			return _blocksPerIteration;
		}
		
		
		public function set blocksPerIteration(val : int) : void {
			_blocksPerIteration = Math.min(val, 256);
		}
		
		
		
		//--------------------------------------
		//					FLUSH
		//--------------------------------------
		
		/**
		 * Libère la mémoire utilisée par le PNGEncoder
		 */
		public function flush():void{
			_killTimer();
			_sourceBitmapData.dispose();
		}
		
		
	}
}
