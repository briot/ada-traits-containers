pragma Ada_2012;
with Conts.Maps.Generics;

generic
   Test_Name : String;
   with package Maps is new Conts.Maps.Generics (<>);
   with function Image_Element
      (Self : Maps.Elements.Element_Type) return String;
   with function Nth_Key (Index : Natural) return Maps.Keys.Element_Type;
   with function Nth_Element
      (Index : Natural) return Maps.Elements.Element_Type;
   with function "=" (L, R : Maps.Elements.Element_Type) return Boolean is <>;

package Support_Maps is

   procedure Test (M : in out Maps.Map);

end Support_Maps;
