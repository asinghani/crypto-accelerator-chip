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
#
# SPDX-License-Identifier: Apache-2.0

.PHONY: rtl
rtl: clean
	cd aes && make SIM=RTL > verify.log 2>/dev/null && grep Res verify.log && cd ..
	cd sha256 && make SIM=RTL > verify.log 2>/dev/null && grep Res verify.log && cd ..

.PHONY: gl
gl: clean
	cd aes && make SIM=GL > verify.log 2>/dev/null && grep Res verify.log && cd ..
	cd sha256 && make SIM=GL > verify.log 2>/dev/null && grep Res verify.log && cd ..

clean:
	cd aes && make clean && cd ..
	cd sha256 && make clean && cd ..
