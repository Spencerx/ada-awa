-----------------------------------------------------------------------
--  awa-mail-clients-files -- Mail client dump/file implementation
--  Copyright (C) 2012, 2014, 2020 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--  SPDX-License-Identifier: Apache-2.0
-----------------------------------------------------------------------

with Ada.Strings.Unbounded;

with Util.Properties;
with Util.Concurrent.Counters;

--  The <b>AWA.Mail.Clients.Files</b> package provides a dump implementation of the
--  mail client interfaces on top of raw system files.
package AWA.Mail.Clients.Files is

   NAME : constant String := "file";

   --  ------------------------------
   --  Mail Message
   --  ------------------------------
   --  The <b>File_Mail_Message</b> represents a mail message that is written on a file in
   --  in specific directory.
   type File_Mail_Message is new Mail_Message with private;
   type File_Mail_Message_Access is access all File_Mail_Message'Class;

   --  Set the <tt>From</tt> part of the message.
   overriding
   procedure Set_From (Message : in out File_Mail_Message;
                       Name    : in String;
                       Address : in String);

   --  Add a recipient for the message.
   overriding
   procedure Add_Recipient (Message : in out File_Mail_Message;
                            Kind    : in Recipient_Type;
                            Name    : in String;
                            Address : in String);

   --  Set the subject of the message.
   overriding
   procedure Set_Subject (Message : in out File_Mail_Message;
                          Subject : in String);

   --  Set the body of the message.
   overriding
   procedure Set_Body (Message      : in out File_Mail_Message;
                       Content      : in Unbounded_String;
                       Alternative  : in Unbounded_String;
                       Content_Type : in String);

   --  Add an attachment with the given content.
   overriding
   procedure Add_Attachment (Message      : in out File_Mail_Message;
                             Content      : in Unbounded_String;
                             Content_Id   : in String;
                             Content_Type : in String);

   overriding
   procedure Add_File_Attachment (Message      : in out File_Mail_Message;
                                  Filename     : in String;
                                  Content_Id   : in String;
                                  Content_Type : in String);

   --  Send the email message.
   overriding
   procedure Send (Message : in out File_Mail_Message);

   --  ------------------------------
   --  Mail Manager
   --  ------------------------------
   --  The <b>Mail_Manager</b> is the entry point to create a new mail message
   --  and be able to send it.
   type File_Mail_Manager is limited new Mail_Manager with private;
   type File_Mail_Manager_Access is access all File_Mail_Manager'Class;

   --  Create a file based mail manager and configure it according to the properties.
   function Create_Manager (Props : in Util.Properties.Manager'Class) return Mail_Manager_Access;

   --  Create a new mail message.
   overriding
   function Create_Message (Manager : in File_Mail_Manager) return Mail_Message_Access;

private

   type File_Mail_Message is new Mail_Message with record
      Manager : File_Mail_Manager_Access;
      From    : Ada.Strings.Unbounded.Unbounded_String;
      To      : Ada.Strings.Unbounded.Unbounded_String;
      Cc      : Ada.Strings.Unbounded.Unbounded_String;
      Bcc     : Ada.Strings.Unbounded.Unbounded_String;
      Subject : Ada.Strings.Unbounded.Unbounded_String;
      Message : Ada.Strings.Unbounded.Unbounded_String;
      Html    : Ada.Strings.Unbounded.Unbounded_String;
      Attachments : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   type File_Mail_Manager is limited new Mail_Manager with record
      Self    : File_Mail_Manager_Access;
      Path    : Ada.Strings.Unbounded.Unbounded_String;
      Index   : Util.Concurrent.Counters.Counter;
   end record;

end AWA.Mail.Clients.Files;
