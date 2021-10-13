pragma Ada_2012;
with Conts.Maps.Generics;
with Report;

generic
   Category       : String;  --  which table we want to show results in
   Container_Name : String;  --  which column
   with package Maps is new Conts.Maps.Generics (<>);
   with function Image_Element
      (Self : Maps.Elements.Element_Type) return String;
   with function Nth_Key (Index : Natural) return Maps.Keys.Element_Type;
   with function Nth_Element
      (Index : Natural) return Maps.Elements.Element_Type;
   with function Nth_Perf_Element
      (Index : Natural) return Maps.Elements.Element_Type;
   with function "=" (L, R : Maps.Elements.Element_Type) return Boolean is <>;
   with function Check_Element (E : Maps.Elements.Element_Type) return Boolean;

package Support_Maps is

   procedure Test (M1, M2 : in out Maps.Map);

   procedure Test_Perf
      (Results  : in out Report.Output'Class;
       M1, M2   : in out Maps.Map;
       Favorite : Boolean);
end Support_Maps;
