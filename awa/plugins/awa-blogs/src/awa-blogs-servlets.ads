-----------------------------------------------------------------------
--  awa-blogs-servlets -- Serve files saved in the storage service
--  Copyright (C) 2017, 2019, 2022 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--  SPDX-License-Identifier: Apache-2.0
-----------------------------------------------------------------------
with Ada.Strings.Unbounded;
with Ada.Calendar;

with ADO;

with ASF.Requests;
with AWA.Storages.Servlets;
package AWA.Blogs.Servlets is

   --  The <b>Storage_Servlet</b> represents the component that will handle
   --  an HTTP request received by the server.
   type Image_Servlet is new AWA.Storages.Servlets.Storage_Servlet with private;

   --  Load the data content that correspond to the GET request and get the name as well
   --  as mime-type and date.
   overriding
   procedure Load (Server   : in Image_Servlet;
                   Request  : in out ASF.Requests.Request'Class;
                   Name     : out Ada.Strings.Unbounded.Unbounded_String;
                   Mime     : out Ada.Strings.Unbounded.Unbounded_String;
                   Date     : out Ada.Calendar.Time;
                   Data     : out ADO.Blob_Ref);

   --  Get the expected return mode (content disposition for download or inline).
   overriding
   function Get_Format (Server   : in Image_Servlet;
                        Request  : in ASF.Requests.Request'Class)
                        return AWA.Storages.Servlets.Get_Type;

private

   type Image_Servlet is new AWA.Storages.Servlets.Storage_Servlet with null record;

end AWA.Blogs.Servlets;
