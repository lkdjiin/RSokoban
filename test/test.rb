#!/usr/bin/env ruby

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require "rsokoban"

require "test/unit"

require "../test/tc_level"
require "../test/tc_set_loader"
require "../test/tc_level_set"
require "../test/tc_raw_level"
require "../test/tc_position"
require "../test/tc_moveable"
require "../test/tc_man"
require "../test/tc_move_recorder"
require "../test/tc_map"
require "../test/ui/tc_console"
require "../test/ui/tc_player_action"
require "../test/tc_extensions"
require "../test/tc_move_result"
require "../test/tc_game"
require "../test/tc_game_ui"
require "../test/tc_game_gui"
require "../test/tc_game_factory"
require "../test/tc_layered_map"
require "../test/tc_record"
require "../test/tc_install"
