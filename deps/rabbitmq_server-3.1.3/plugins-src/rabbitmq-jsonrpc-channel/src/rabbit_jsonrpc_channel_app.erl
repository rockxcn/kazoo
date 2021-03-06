%% The contents of this file are subject to the Mozilla Public License
%% Version 1.1 (the "License"); you may not use this file except in
%% compliance with the License. You may obtain a copy of the License
%% at http://www.mozilla.org/MPL/
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and
%% limitations under the License.
%%
%% The Original Code is RabbitMQ.
%%
%% The Initial Developer of the Original Code is VMware, Inc.
%% Copyright (c) 2007-2013 VMware, Inc.  All rights reserved.
%%

-module(rabbit_jsonrpc_channel_app).

-behaviour(application).
-export([start/2,stop/1]).

start(_Type, _StartArgs) ->
    ContextRoot = case application:get_env(rabbitmq_jsonrpc_channel, js_root) of
        {ok, Root} -> Root;
        undefined  -> "rabbitmq_lib"
    end,
    rabbit_web_dispatch:register_static_context(jsonrpc_lib,
                                            rabbit_jsonrpc:listener(),
                                            ContextRoot, ?MODULE, "priv/www",
                                            "JSON-RPC: JavaScript library"),
    rabbit_jsonrpc_channel_app_sup:start_link().

stop(_State) ->
    rabbit_web_dispatch:unregister_context(jsonrpc_lib),
    ok.
