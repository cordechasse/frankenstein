/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 22 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour les Objects.
	 * </p>
	 */
	public class UObject {

		/**
		 * Définit si un classe hérite d'une autre.
		 * 
		 * @param childClass
		 * La classe à tester.
		 * 
		 * @param parentClass
		 * La classe héritée.
		 * 
		 * @return
		 * Un booléen.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		//affiche si la classe AButton hérite de Sprite
		 * 		trace(UObject.isSubClassOf(AButton, Sprite)); //affiche true
		 * 	</pre>
		 * </listing>
		 * 
		 */
		public static function isSubClassOf(childClass : Class, parentClass : Class) : Boolean {
			return describeType(childClass).factory.extendsClass.(@type == getQualifiedClassName(parentClass)).length() > 0;
		}

		
		/**
		 * Retourne la classe d'un objet.
		 * 
		 * @param obj
		 * L'objet à tester.
		 * 
		 * @return
		 * La classe dont l'objet est une instanciation.
		 * 
		 */
		public static function getClass(obj : Object) : Class {
			if (obj == null)
				return null;
			
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}

		
		/**
		 * Retourne les propriétés d'un objet recursivement. Equivalent a ObjectDumper en AS2.
		 * 
		 * @param obj
		 * L'objet à "dumper".
		 * 
		 * @return
		 * Un String représentant l'objet, toutes ses propriétés et ses sous-propriétés sous un 
		 * format pseudo JSON : <br />
		 * <ul>
		 * 	<li>String : ""</li>
		 * 	<li>Object : {}</li>
		 * 	<li>Array : []</li>
		 * 	<li>Shape : --shape--</li>
		 * </ul>		  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var o : Object = {};
		 * 		o.aze = ["A", 5, {b : 32}];
		 * 		o.qsd = {xml: new XML("&lt;root&gt;&lt;a&gt;pouf&lt;/a&gt;&lt;/root&gt;"), idx: 53};
		 * 		o.wxc = "pif";
		 * 		
		 * 		//trace normal
		 * 		//affiche [object Object]
		 * 		trace(o); 
		 * 		
		 * 		//trace dump
		 * 		//affiche {aze:["A", 5, {b:32}], qsd:{xml:&lt;root&gt;&lt;a&gt;pouf&lt;/a&gt;&lt;/root&gt;, idx:53}, wxc:"pif"}
		 * 		trace(UObject.dump(o)); 
		 * 	</pre>
		 * </listing>
		 */
		public static function dump(obj : Object) : String {
			return _recursiveDump(obj);
		}

		
		private static function _recursiveDump(obj : Object) : String {
			var s : String = "";
			switch (typeof obj) {
				case "string":
					s = "\"" + obj.toString() + "\"";
					break;
				case "boolean":
				case "number":
				case "xml":
					s = obj.toString();
					break;
				case "object":
					if (obj is Array) {
						s = "[";
						for (var i : uint = 0;i < obj.length; i++) {
							s += _recursiveDump(obj[i]) + ", ";
						}
						s = (s.length > 1 ) ? s.substr(0, -2) : s;
						s += "]";
					}
					else if (isSubClassOf(getClass(obj), Sprite)) {
						s = "{";
						for (var k : uint = 0;k < obj.numChildren; k++) {
							s += obj.getChildAt(k).name + ":" + _recursiveDump(obj.getChildAt(k)) + ", ";
						}
						s = (s.length > 1 ) ? s.substr(0, -2) : s;
						s += "}";
					}
					else if (obj is Shape) {
						s = "--shape--";
					} else {
						s = "{";
						for (var j : Object in obj) {
							s += j + ":" + _recursiveDump(obj[j]) + ", ";
						}
						s = (s.length > 1 ) ? s.substr(0, -2) : s;
						s += "}";
					}
					break;
			}
			
			return s;
		}
	}
}
