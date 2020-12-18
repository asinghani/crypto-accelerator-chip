#SPDX-FileCopyrightText: 2020 Anish Singhani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
package require openlane
set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag user_project_wrapper -overwrite
set save_path $script_dir/../..

verilog_elaborate

init_floorplan

place_io_ol

set ::env(FP_DEF_TEMPATE) $script_dir/../../def/user_project_wrapper_empty.def

apply_def_template

add_macro_placement mprj 775 875 N

manual_macro_placement f
exec -ignorestderr openroad -exit $script_dir/gen_pdn.tcl
set_def $::env(pdn_tmp_file_tag).def

global_routing_or
detailed_routing

run_magic
run_magic_spice_export

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(tritonRoute_result_file_tag).def \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)

run_magic_drc

run_lvs; # requires run_magic_spice_export

run_antenna_check

