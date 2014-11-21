%
%% e2qc erlang cache
%%
%% Copyright (c) 2014 Basho Technologies, Inc.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.

-module(basho_bench_driver_e2qc).

-export([new/1,
         run/4]).

-define(CACHE, basho_bench).

%% TODO:
%%
%% * Add support for additional Erlang wrappers and NIFs directly
%% * Add support for multiple caches simultaneously?

new(Id) ->
    if Id == 1 ->
            Size = basho_bench_config:get(e2qc_size, 16*1024*1024),
            Ratio = basho_bench_config:get(e2qc_ratio, 0.4),
            ok = e2qc:setup(?CACHE, [{size, Size}, {ratio, Ratio}]);
       true ->
            ok
    end,
    {ok, ?CACHE}.

run(cache, KeyGen, ValueGen, CacheName) ->
    Key = KeyGen(),
    case e2qc:cache(CacheName, Key, ValueGen) of
        _X when is_binary(_X) ->
            {ok, CacheName}
    end.
