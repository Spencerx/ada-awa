-----------------------------------------------------------------------
--  awa-events-configs -- Event configuration
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

with Util.Serialize.Mappers.Record_Mapper;

with AWA.Services.Contexts;
with AWA.Events.Queues.Fifos;
package body AWA.Events.Configs is

   use AWA.Events.Queues;

   --  ------------------------------
   --  Set the configuration value identified by <b>Value</b> after having parsed
   --  the element identified by <b>Field</b>.
   --  ------------------------------
   procedure Set_Member (Into  : in out Controller_Config;
                         Field : in Config_Fields;
                         Value : in Util.Beans.Objects.Object) is
   begin
      case Field is
         when FIELD_NAME =>
            Into.Name := Value;

         when FIELD_QUEUE_NAME =>
            declare
               Name : constant String := Util.Beans.Objects.To_String (Value);
            begin
               Into.Queue := Into.Manager.Find_Queue (Name);
            end;

         when FIELD_TYPE =>
            declare
               Name : constant String := Util.Beans.Objects.To_String (Value);
            begin
               if Name = FIFO_QUEUE_TYPE then
                  Into.Create := AWA.Events.Queues.Fifos.Create_Queue'Access;
               else
                  raise Util.Serialize.Mappers.Field_Error with "Invalid queue type: " & Name;
               end if;
            end;

         when FIELD_ACTION =>
            declare
               Expr : constant String := Util.Beans.Objects.To_String (Value);
            begin
               Into.Action := EL.Expressions.Create_Expression (Expr, Into.Context.all);

            exception
               when others =>
                  raise Util.Serialize.Mappers.Field_Error with "Invalid entity type: " & Expr;
            end;

         when FIELD_PROPERTY_NAME =>
            Into.Prop_Name := Value;

         when FIELD_PROPERTY_VALUE =>
            if Util.Beans.Objects.Is_Null (Into.Prop_Name) then
               raise Util.Serialize.Mappers.Field_Error with "Missing property name";
            end if;

            --  Add the new property.
            declare
               Name : constant String := Util.Beans.Objects.To_String (Into.Prop_Name);
               Expr : constant String := Util.Beans.Objects.To_String (Value);
            begin
               EL.Beans.Add_Parameter (Container => Into.Params,
                                       Name      => Name,
                                       Value     => Expr,
                                       Context   => Into.Context.all);
            end;
            Into.Prop_Name := Util.Beans.Objects.Null_Object;

         when FIELD_ON_EVENT =>
            if Util.Beans.Objects.Is_Null (Into.Name) then
               raise Util.Serialize.Mappers.Field_Error with "Missing event name";
            end if;
            if Into.Queue = null then
               raise Util.Serialize.Mappers.Field_Error with "Missing or invalid event queue";
            end if;

            declare
               Name  : constant String := Util.Beans.Objects.To_String (Into.Name);
            begin
               Into.Manager.Add_Action (Event  => Name,
                                        Queue  => Into.Queue,
                                        Action => Into.Action,
                                        Params => Into.Params);
            end;

         when FIELD_QUEUE =>
            if Into.Create = null then
               raise Util.Serialize.Mappers.Field_Error with "Missing a valid queue type";
            end if;

            --  Create the queue with the given name and properties and add it to the manager.
            declare
               Name  : constant String := Util.Beans.Objects.To_String (Into.Name);
               Queue : constant Queue_Access := Into.Create (Name    => Name,
                                                             Props   => Into.Params,
                                                             Context => Into.Context.all);
            begin
               Into.Manager.Add_Queue (Queue);
            end;

            Into.Create := null;
            Into.Name := Util.Beans.Objects.Null_Object;
            Into.Params.Clear;

      end case;
   end Set_Member;

   package Config_Mapper is
     new Util.Serialize.Mappers.Record_Mapper (Element_Type        => Controller_Config,
                                               Element_Type_Access => Controller_Config_Access,
                                               Fields              => Config_Fields,
                                               Set_Member          => Set_Member);

   Mapper : aliased Config_Mapper.Mapper;

   --  Setup the XML parser to read the <b>queue</b> and <b>on-event</b> description.
   --  For example:
   --
   --  <queue name="async" type="fifo">
   --     <property name="size">254</property>
   --  </queue>
   --
   --  <on-event name="create-user" queue="async">
   --     <action>#{mail.send}</action>
   --     <property name="user">#{event.name}</property>
   --     <property name="template">mail/welcome.xhtml</property>
   --  </on-event>
   --
   --  This defines an event action called when the <b>create-user</b> event is posted.
   --  The Ada bean <b>mail</b> is created and is populated with the <b>user</b> and
   --  <b>template</b> properties.  The Ada bean action method <b>send</b> is called.
   package body Reader_Config is
   begin
      Reader.Add_Mapping ("module", Mapper'Access);
      Config.Manager := Manager;
      Config.Context := Context;
      Config.Session := AWA.Services.Contexts.Get_Session (AWA.Services.Contexts.Current);
      Config_Mapper.Set_Context (Reader, Config'Unchecked_Access);
   end Reader_Config;

begin
   Mapper.Add_Mapping ("queue", FIELD_QUEUE);
   Mapper.Add_Mapping ("queue/@name", FIELD_NAME);
   Mapper.Add_Mapping ("queue/@type", FIELD_TYPE);
   Mapper.Add_Mapping ("queue/property/@name", FIELD_PROPERTY_NAME);
   Mapper.Add_Mapping ("queue/property", FIELD_PROPERTY_VALUE);
   Mapper.Add_Mapping ("on-event", FIELD_ON_EVENT);
   Mapper.Add_Mapping ("on-event/@name", FIELD_NAME);
   Mapper.Add_Mapping ("on-event/@queue", FIELD_QUEUE_NAME);
   Mapper.Add_Mapping ("on-event/property/@name", FIELD_PROPERTY_NAME);
   Mapper.Add_Mapping ("on-event/property", FIELD_PROPERTY_VALUE);
   Mapper.Add_Mapping ("on-event/action", FIELD_ACTION);
end AWA.Events.Configs;
