-----------------------------------------------------------------------
--  security-auth-fake -- A fake OAuth provider for unit tests
--  Copyright (C) 2020 Stephane Carrez
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

package Security.Auth.Fake is

   type Manager is new Security.Auth.Manager with private;

   --  Initialize the OpenID authentication realm.  Get the <tt>openid.realm</tt>
   --  and <tt>openid.callback_url</tt> parameters to configure the realm.
   overriding
   procedure Initialize (Realm  : in out Manager;
                         Params : in Parameters'Class;
                         Name   : in String := PROVIDER_OPENID);

   --  Discover the OpenID provider that must be used to authenticate the user.
   --  The <b>Name</b> can be an URL or an alias that identifies the provider.
   --  A cached OpenID provider can be returned.
   --  Read the XRDS document from the URI and initialize the OpenID provider end point.
   --  (See OpenID Section 7.3 Discovery)
   overriding
   procedure Discover (Realm  : in out Manager;
                       Name   : in String;
                       Result : out End_Point);

   --  Associate the application (relying party) with the OpenID provider.
   --  The association can be cached.
   --  (See OpenID Section 8 Establishing Associations)
   overriding
   procedure Associate (Realm  : in out Manager;
                        OP     : in End_Point;
                        Result : out Association);

   --  Get the authentication URL to which the user must be redirected for authentication
   --  by the authentication server.
   overriding
   function Get_Authentication_URL (Realm : in Manager;
                                    OP    : in End_Point;
                                    Assoc : in Association) return String;

   --  Verify the authentication result
   overriding
   procedure Verify (Realm   : in out Manager;
                     Assoc   : in Association;
                     Request : in Parameters'Class;
                     Result  : out Authentication);

private

   type Manager is new Security.Auth.Manager with record
      Return_To : Unbounded_String;
      Realm     : Unbounded_String;
   end record;

end Security.Auth.Fake;
