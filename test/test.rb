#!/usr/bin/env ruby

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require "rsokoban"

require "test/unit"

require "../test/tc_level"
require "../test/tc_level_loader"
require "../test/tc_level_set"
require "../test/tc_raw_level"
require "../test/tc_position"
require "../test/tc_moveable"
require "../test/tc_man"
require "../test/ui/tc_console"
require "../test/tc_move_recorder"
