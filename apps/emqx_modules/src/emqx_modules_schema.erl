%%--------------------------------------------------------------------
%% Copyright (c) 2020-2021 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_modules_schema).

-include_lib("typerefl/include/types.hrl").

-behaviour(hocon_schema).

-export([ structs/0
        , fields/1]).

structs() ->
    ["delayed",
     "recon",
     "telemetry",
     "event_message",
     "rewrite",
     "topic_metrics"].

fields(Name) when Name =:= "recon";
                  Name =:= "telemetry" ->
    [ {enable, emqx_schema:t(boolean(), undefined, false)}
    ];

fields("delayed") ->
    [ {enable, emqx_schema:t(boolean(), undefined, false)}
    , {max_delayed_messages, emqx_schema:t(integer())}
    ];

fields("rewrite") ->
    [ {rules, hoconsc:array(hoconsc:ref(?MODULE, "rules"))}
    ];


fields("event_message") ->
    [ {"$event/client_connected", emqx_schema:t(boolean(), undefined, false)}
    , {"$event/client_disconnected", emqx_schema:t(boolean(), undefined, false)}
    , {"$event/client_subscribed", emqx_schema:t(boolean(), undefined, false)}
    , {"$event/client_unsubscribed", emqx_schema:t(boolean(), undefined, false)}
    , {"$event/message_delivered", emqx_schema:t(boolean(), undefined, false)}
    , {"$event/message_acked", emqx_schema:t(boolean(), undefined, false)}
    , {"$event/message_dropped", emqx_schema:t(boolean(), undefined, false)}
    ];

fields("topic_metrics") ->
    [ {topics, hoconsc:array(binary())}
    ];

fields("rules") ->
    [ {action, hoconsc:enum([publish, subscribe])}
    , {source_topic, emqx_schema:t(binary())}
    , {re, emqx_schema:t(binary())}
    , {dest_topic, emqx_schema:t(binary())}
    ].

