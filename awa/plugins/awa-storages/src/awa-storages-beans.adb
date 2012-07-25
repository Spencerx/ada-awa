-----------------------------------------------------------------------
--  awa-storages-beans -- Storage Ada Beans
--  Copyright (C) 2012 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
-----------------------------------------------------------------------

with ASF.Parts;
with ASF.Parts.Upload_Method;
with ASF.Events.Faces.Actions;

with AWA.Storages.Services;
package body AWA.Storages.Beans is

   package Upload_Binding is
     new ASF.Events.Faces.Actions.Action_Method.Bind (Bean   => Upload_Bean,
                                                      Method => Upload,
                                                      Name   => "upload");

   package Save_Part_Binding is
      new ASF.Parts.Upload_Method.Bind (Name   => "save",
                                        Bean   => Upload_Bean,
                                        Method => Save_Part);

   Upload_Bean_Binding : aliased constant Util.Beans.Methods.Method_Binding_Array
     := (1 => Upload_Binding.Proxy'Access,
         2 => Save_Part_Binding.Proxy'Access);

   --  ------------------------------
   --  Get the value identified by the name.
   --  ------------------------------
   overriding
   function Get_Value (From : in Upload_Bean;
                       Name : in String) return Util.Beans.Objects.Object is
   begin
      return AWA.Storages.Models.Storage_Ref (From).Get_Value (Name);
   end Get_Value;

   --  ------------------------------
   --  Set the value identified by the name.
   --  ------------------------------
   overriding
   procedure Set_Value (From  : in out Upload_Bean;
                        Name  : in String;
                        Value : in Util.Beans.Objects.Object) is
   begin
      null;
   end Set_Value;

   --  ------------------------------
   --  This bean provides some methods that can be used in a Method_Expression
   --  ------------------------------
   overriding
   function Get_Method_Bindings (From : in Upload_Bean)
                                 return Util.Beans.Methods.Method_Binding_Array_Access is
      pragma Unreferenced (From);
   begin
      return Upload_Bean_Binding'Access;
   end Get_Method_Bindings;

   --  ------------------------------
   --  Save the uploaded file in the storage service.
   --  ------------------------------
   procedure Save_Part (Bean : in out Upload_Bean;
                        Part : in ASF.Parts.Part'Class) is
      Manager : AWA.Storages.Services.Storage_Service_Access := Bean.Module.Get_Storage_Manager;
   begin
      Bean.Set_Name (Part.Get_Name);
      Bean.Set_Mime_Type (Part.Get_Content_Type);
      Bean.Set_File_Size (Part.Get_Size);
      Manager.Save (Bean, Part, AWA.Storages.Models.DATABASE);
   end Save_Part;

   --  Upload the file.
   procedure Upload (Bean    : in out Upload_Bean;
                     Outcome : in out Ada.Strings.Unbounded.Unbounded_String) is

   begin
      null;
   end Upload;

   --  ------------------------------
   --  Create the Upload_Bean bean instance.
   --  ------------------------------
   function Create_Upload_Bean (Module : in AWA.Storages.Modules.Storage_Module_Access)
                                return Util.Beans.Basic.Readonly_Bean_Access is
      Result : constant Upload_Bean_Access := new Upload_Bean;
   begin
      Result.Module := Module;
      return Result.all'Access;
   end Create_Upload_Bean;

end AWA.Storages.Beans;
