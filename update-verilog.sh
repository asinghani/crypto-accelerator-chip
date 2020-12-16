#!/bin/sh
# SPDX-FileCopyrightText: 2020 Anish Singhani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

DATETIME=$(date '+%m/%d/%Y %H:%M %Z')
AES_IDENT="AES128/256 Core by Anish Singhani ($DATETIME)"
SHA_IDENT="SHA256 Core by Anish Singhani ($DATETIME)"

echo "Building and updating verilog source from crypto-accelerator..."
make --always-make -C crypto-accelerator build/top.v AES_IDENT="\"$AES_IDENT\"" SHA_IDENT="\"$SHA_IDENT\""
echo "// This file is auto-generated and should not be edited by hand" | cat - crypto-accelerator/build/top.v > verilog/rtl/accelerator/crypto_accelerator.v 
echo "Done"

