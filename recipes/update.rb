#
# Cookbook:: windows_update
# Recipe:: update
#
# Copyright:: 2018, Nghiem Ba Hieu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

powershell_script 'install windows update' do
  code <<-UPDATE
  #Define update criteria.

  $Criteria = "IsInstalled=0"

  #Search for relevant updates.

  $Searcher = New-Object -ComObject Microsoft.Update.Searcher

  $SearchResult = $Searcher.Search($Criteria).Updates

  #Download updates.

  $Session = New-Object -ComObject Microsoft.Update.Session

  $Downloader = $Session.CreateUpdateDownloader()

  $Downloader.Updates = $SearchResult

  $Downloader.Download()

  $Installer = New-Object -ComObject Microsoft.Update.Installer

  $Installer.Updates = $SearchResult

  $Result = $Installer.Install()

  If ($Result.rebootRequired) { shutdown.exe /t 0 /r }
  UPDATE
  action :run
end
