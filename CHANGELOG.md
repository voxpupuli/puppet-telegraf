# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v5.4.0](https://github.com/voxpupuli/puppet-telegraf/tree/v5.4.0) (2024-02-28)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v5.3.0...v5.4.0)

**Implemented enhancements:**

- Bump default version to 1.29.4 [\#227](https://github.com/voxpupuli/puppet-telegraf/pull/227) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Remove legacy top-scope syntax [\#224](https://github.com/voxpupuli/puppet-telegraf/pull/224) ([smortex](https://github.com/smortex))

## [v5.3.0](https://github.com/voxpupuli/puppet-telegraf/tree/v5.3.0) (2023-10-31)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v5.2.0...v5.3.0)

**Implemented enhancements:**

- Add OracleLinux 9 support [\#222](https://github.com/voxpupuli/puppet-telegraf/pull/222) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian 12 support [\#221](https://github.com/voxpupuli/puppet-telegraf/pull/221) ([bastelfreak](https://github.com/bastelfreak))

## [v5.2.0](https://github.com/voxpupuli/puppet-telegraf/tree/v5.2.0) (2023-09-19)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v5.1.0...v5.2.0)

**Implemented enhancements:**

- Add Puppet 8 support [\#214](https://github.com/voxpupuli/puppet-telegraf/pull/214) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Installs from influxdata repo can use stable repos [\#198](https://github.com/voxpupuli/puppet-telegraf/issues/198)

**Merged pull requests:**

- Always install from the stable release class on Debian and Ubuntu [\#217](https://github.com/voxpupuli/puppet-telegraf/pull/217) ([mj](https://github.com/mj))

## [v5.1.0](https://github.com/voxpupuli/puppet-telegraf/tree/v5.1.0) (2023-07-03)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v5.0.0...v5.1.0)

**Implemented enhancements:**

- Make log rotation configurable [\#211](https://github.com/voxpupuli/puppet-telegraf/pull/211) ([AndrewLest](https://github.com/AndrewLest))

## [v5.0.0](https://github.com/voxpupuli/puppet-telegraf/tree/v5.0.0) (2023-06-14)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v4.3.1...v5.0.0)

**Breaking changes:**

- use stdlib::to\_toml instead of toml gem [\#207](https://github.com/voxpupuli/puppet-telegraf/pull/207) ([bastelfreak](https://github.com/bastelfreak))
- Drop Puppet 6, Debian 9, Ubuntu 16.04 support [\#203](https://github.com/voxpupuli/puppet-telegraf/pull/203) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Ubuntu 20.04/22.04 support [\#209](https://github.com/voxpupuli/puppet-telegraf/pull/209) ([bastelfreak](https://github.com/bastelfreak))
- Add Rocky/AlmaLinux/EL9 support [\#208](https://github.com/voxpupuli/puppet-telegraf/pull/208) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Add creates param to all archive resources [\#206](https://github.com/voxpupuli/puppet-telegraf/pull/206) ([m0dular](https://github.com/m0dular))

**Closed issues:**

- Add creates parameter to all archive resources [\#205](https://github.com/voxpupuli/puppet-telegraf/issues/205)

## [v4.3.1](https://github.com/voxpupuli/puppet-telegraf/tree/v4.3.1) (2023-01-27)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v4.3.0...v4.3.1)

**Merged pull requests:**

- chore: update influxdata repo gpg key [\#197](https://github.com/voxpupuli/puppet-telegraf/pull/197) ([powersj](https://github.com/powersj))
- Update APT dependancy [\#194](https://github.com/voxpupuli/puppet-telegraf/pull/194) ([MartyEwings](https://github.com/MartyEwings))

## [v4.3.0](https://github.com/voxpupuli/puppet-telegraf/tree/v4.3.0) (2022-10-02)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v4.2.0...v4.3.0)

**Implemented enhancements:**

- Add support for archive install on EL [\#190](https://github.com/voxpupuli/puppet-telegraf/pull/190) ([m0dular](https://github.com/m0dular))
- Configure processors via Hiera [\#183](https://github.com/voxpupuli/puppet-telegraf/pull/183) ([deric](https://github.com/deric))

**Merged pull requests:**

- install apt-transport-https in acceptance tests [\#191](https://github.com/voxpupuli/puppet-telegraf/pull/191) ([bastelfreak](https://github.com/bastelfreak))

## [v4.2.0](https://github.com/voxpupuli/puppet-telegraf/tree/v4.2.0) (2022-05-13)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v4.1.0...v4.2.0)

**Implemented enhancements:**

- Add FreeBSD support, using telegraf as installed by pkg\(8\) [\#185](https://github.com/voxpupuli/puppet-telegraf/pull/185) ([rvstaveren](https://github.com/rvstaveren))
- Add support for Debian 11 [\#181](https://github.com/voxpupuli/puppet-telegraf/pull/181) ([ZloeSabo](https://github.com/ZloeSabo))
- Allow recent dependencies [\#178](https://github.com/voxpupuli/puppet-telegraf/pull/178) ([smortex](https://github.com/smortex))

**Merged pull requests:**

- Remove nodesets [\#187](https://github.com/voxpupuli/puppet-telegraf/pull/187) ([ekohl](https://github.com/ekohl))
- cleanup .fixtures.yml [\#182](https://github.com/voxpupuli/puppet-telegraf/pull/182) ([bastelfreak](https://github.com/bastelfreak))

## [v4.1.0](https://github.com/voxpupuli/puppet-telegraf/tree/v4.1.0) (2021-07-15)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- allow latest stdlib/apt modules [\#175](https://github.com/voxpupuli/puppet-telegraf/pull/175) ([bastelfreak](https://github.com/bastelfreak))
- puppet/archive: allow 5.x [\#166](https://github.com/voxpupuli/puppet-telegraf/pull/166) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- make sure the ensure absent works with package install [\#169](https://github.com/voxpupuli/puppet-telegraf/pull/169) ([fe80](https://github.com/fe80))
- move relationship between package and repo into code block where repo is managed [\#160](https://github.com/voxpupuli/puppet-telegraf/pull/160) ([lukebigum](https://github.com/lukebigum))

**Closed issues:**

- No longer possible to configure tagpass and tagdrop [\#170](https://github.com/voxpupuli/puppet-telegraf/issues/170)

**Merged pull requests:**

- Fix README example 3 + cosmetic updates [\#171](https://github.com/voxpupuli/puppet-telegraf/pull/171) ([thias](https://github.com/thias))
- Refactor manage\_repo install tests for consistency. [\#165](https://github.com/voxpupuli/puppet-telegraf/pull/165) ([gcoxmoz](https://github.com/gcoxmoz))

## [v4.0.0](https://github.com/voxpupuli/puppet-telegraf/tree/v4.0.0) (2021-02-18)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v3.1.0...v4.0.0)

**Breaking changes:**

- Drop EoL windows server 2008, drop EoL Puppet 5, add Puppet 7 [\#162](https://github.com/voxpupuli/puppet-telegraf/pull/162) ([genebean](https://github.com/genebean))
- Drop EOL EL6 support [\#159](https://github.com/voxpupuli/puppet-telegraf/pull/159) ([ekohl](https://github.com/ekohl))
- modulesync 3.0.0 & puppet-lint updates / Drop Debian/Raspbian 8 [\#147](https://github.com/voxpupuli/puppet-telegraf/pull/147) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add support for Darwin [\#161](https://github.com/voxpupuli/puppet-telegraf/pull/161) ([yachub](https://github.com/yachub))

**Fixed bugs:**

- Changed Assign repo-\>package even when manage\_repo=false on Debian+Re… [\#148](https://github.com/voxpupuli/puppet-telegraf/pull/148) ([danielsreichenbach](https://github.com/danielsreichenbach))

**Closed issues:**

- Cannot install telegraf on Windows server because config\_file\_mode and config\_folder\_mode is undefined [\#155](https://github.com/voxpupuli/puppet-telegraf/issues/155)
- Minor: Please fix the \(\>=5.0.0 \< 7.0.0\) to \(\>= 5.0.0 \< 7.0.0\) in the metadata for dependencies [\#153](https://github.com/voxpupuli/puppet-telegraf/issues/153)

**Merged pull requests:**

- Add Optional to config\_file\_mode and config\_folder\_mode params on windows [\#156](https://github.com/voxpupuli/puppet-telegraf/pull/156) ([jkkitakita](https://github.com/jkkitakita))
- identical syntax of version range [\#154](https://github.com/voxpupuli/puppet-telegraf/pull/154) ([tuxmea](https://github.com/tuxmea))

## [v3.1.0](https://github.com/voxpupuli/puppet-telegraf/tree/v3.1.0) (2020-08-22)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- SLES support [\#150](https://github.com/voxpupuli/puppet-telegraf/pull/150) ([tuxmea](https://github.com/tuxmea))
- Added support for Raspbian [\#145](https://github.com/voxpupuli/puppet-telegraf/pull/145) ([mattqm](https://github.com/mattqm))
- Add support for Debian 9/10, Ubuntu 18.04, CentOS 8 [\#144](https://github.com/voxpupuli/puppet-telegraf/pull/144) ([dhoppe](https://github.com/dhoppe))

**Closed issues:**

- Re-enable acceptance tests [\#112](https://github.com/voxpupuli/puppet-telegraf/issues/112)

**Merged pull requests:**

- Fixing support for 5.5 agents on Debian [\#146](https://github.com/voxpupuli/puppet-telegraf/pull/146) ([mattqm](https://github.com/mattqm))
- Use voxpupuli-acceptance [\#142](https://github.com/voxpupuli/puppet-telegraf/pull/142) ([ekohl](https://github.com/ekohl))

## [v3.0.0](https://github.com/voxpupuli/puppet-telegraf/tree/v3.0.0) (2020-01-02)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/v2.1.0...v3.0.0)

**Breaking changes:**

- drop Ubuntu 14.04 support [\#130](https://github.com/voxpupuli/puppet-telegraf/pull/130) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 2.7.0 and drop puppet 4 [\#121](https://github.com/voxpupuli/puppet-telegraf/pull/121) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Move lookup\_options to hiera [\#134](https://github.com/voxpupuli/puppet-telegraf/pull/134) ([alexjfisher](https://github.com/alexjfisher))
- Add defined type for telegraf::processor to define processors [\#123](https://github.com/voxpupuli/puppet-telegraf/pull/123) ([philomory](https://github.com/philomory))
- Notify service if package is changed [\#117](https://github.com/voxpupuli/puppet-telegraf/pull/117) ([theosotr](https://github.com/theosotr))
- add variable for config\_file\_mode und config\_folder\_mode [\#108](https://github.com/voxpupuli/puppet-telegraf/pull/108) ([SimonHoenscheid](https://github.com/SimonHoenscheid))

**Closed issues:**

- Is there a way to set up multiple discreet influxdb outputs? [\#129](https://github.com/voxpupuli/puppet-telegraf/issues/129)
- Please update package dependencies [\#118](https://github.com/voxpupuli/puppet-telegraf/issues/118)
- Merge problem: "^telegraf::outputs\(.\*\)$": merge: strategy: first [\#106](https://github.com/voxpupuli/puppet-telegraf/issues/106)

**Merged pull requests:**

- Add missing dependency to .fixtures.yml [\#131](https://github.com/voxpupuli/puppet-telegraf/pull/131) ([dhoppe](https://github.com/dhoppe))
- Update puppetlabs-stdlib dependency to allow 6.x [\#127](https://github.com/voxpupuli/puppet-telegraf/pull/127) ([Sharpie](https://github.com/Sharpie))
- Allow puppetlabs/apt 7.x [\#122](https://github.com/voxpupuli/puppet-telegraf/pull/122) ([dhoppe](https://github.com/dhoppe))

## [v2.1.0](https://github.com/voxpupuli/puppet-telegraf/tree/v2.1.0) (2018-12-29)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/2.0.0...v2.1.0)

**Closed issues:**

- multiple procstat sections failing [\#96](https://github.com/voxpupuli/puppet-telegraf/issues/96)
- New array format for input/output definition in hiera requires polluting configs [\#94](https://github.com/voxpupuli/puppet-telegraf/issues/94)
- Dependency on toml-rb bumps ruby version requirement [\#91](https://github.com/voxpupuli/puppet-telegraf/issues/91)
- Telegraf installation not going through. [\#72](https://github.com/voxpupuli/puppet-telegraf/issues/72)
- First voxpopuli release, deprecate yankcrime module on the forge [\#107](https://github.com/voxpupuli/puppet-telegraf/issues/107)

**Merged pull requests:**

- release 2.1.0 [\#116](https://github.com/voxpupuli/puppet-telegraf/pull/116) ([bastelfreak](https://github.com/bastelfreak))
- Allow newest deps and mark compatible with Puppet 4, 5 and 6 [\#115](https://github.com/voxpupuli/puppet-telegraf/pull/115) ([ekohl](https://github.com/ekohl))
- Various tidying and refactoring [\#113](https://github.com/voxpupuli/puppet-telegraf/pull/113) ([alexjfisher](https://github.com/alexjfisher))
- Modulesync, use rspec-puppet-facts and fix tests [\#111](https://github.com/voxpupuli/puppet-telegraf/pull/111) ([alexjfisher](https://github.com/alexjfisher))
- Rubocop autofixes [\#110](https://github.com/voxpupuli/puppet-telegraf/pull/110) ([alexjfisher](https://github.com/alexjfisher))
- Some basic Vox Pupuli migration changes [\#109](https://github.com/voxpupuli/puppet-telegraf/pull/109) ([alexjfisher](https://github.com/alexjfisher))
- Use Ruby 2.4 [\#102](https://github.com/voxpupuli/puppet-telegraf/pull/102) ([strongoose](https://github.com/strongoose))
- Add workaround for Amazon Linux repo location issue [\#101](https://github.com/voxpupuli/puppet-telegraf/pull/101) ([strongoose](https://github.com/strongoose))
- remove plugin\_type [\#93](https://github.com/voxpupuli/puppet-telegraf/pull/93) ([nrdmn](https://github.com/nrdmn))

## [2.0.0](https://github.com/voxpupuli/puppet-telegraf/tree/2.0.0) (2018-01-19)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.5.0...2.0.0)

**Closed issues:**

- Upgrading telegraf version does not trigger telegraf service restart [\#86](https://github.com/voxpupuli/puppet-telegraf/issues/86)
- Ability to handle duplicate sections [\#85](https://github.com/voxpupuli/puppet-telegraf/issues/85)
- Hiera hash: telegraf inputs with no parameters [\#81](https://github.com/voxpupuli/puppet-telegraf/issues/81)
- Agent configuration options [\#71](https://github.com/voxpupuli/puppet-telegraf/issues/71)
- Sections and win\_perf\_counters [\#68](https://github.com/voxpupuli/puppet-telegraf/issues/68)
- Bump to 1.5.0 [\#67](https://github.com/voxpupuli/puppet-telegraf/issues/67)
- update hiera\_xxx\(\) to lookup\(\) for hiera v5 [\#65](https://github.com/voxpupuli/puppet-telegraf/issues/65)
- Support repeated input types [\#42](https://github.com/voxpupuli/puppet-telegraf/issues/42)
- Usage of `sections` in telegraf::input [\#41](https://github.com/voxpupuli/puppet-telegraf/issues/41)
- Unable to use nested configuration [\#38](https://github.com/voxpupuli/puppet-telegraf/issues/38)
- Cannot differentiate string and numeric options [\#32](https://github.com/voxpupuli/puppet-telegraf/issues/32)

**Merged pull requests:**

- Updates for version 2.0 of this module [\#92](https://github.com/voxpupuli/puppet-telegraf/pull/92) ([yankcrime](https://github.com/yankcrime))
- migrate from stdlib validation to puppet datatypes [\#90](https://github.com/voxpupuli/puppet-telegraf/pull/90) ([lobeck](https://github.com/lobeck))
- Adding support for custom repo location url. [\#89](https://github.com/voxpupuli/puppet-telegraf/pull/89) ([tardoe](https://github.com/tardoe))
- Replace deprecated hiera\_hash function with lookup function [\#82](https://github.com/voxpupuli/puppet-telegraf/pull/82) ([sandra-thieme](https://github.com/sandra-thieme))
- replace toml templates with toml-rb gem [\#80](https://github.com/voxpupuli/puppet-telegraf/pull/80) ([nrdmn](https://github.com/nrdmn))

## [1.5.0](https://github.com/voxpupuli/puppet-telegraf/tree/1.5.0) (2017-08-04)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.4.0...1.5.0)

**Closed issues:**

- File mode on inputs [\#64](https://github.com/voxpupuli/puppet-telegraf/issues/64)
- Install doesn't work with puppetlabs-apt 4.1.0 \(puppet 4\) [\#62](https://github.com/voxpupuli/puppet-telegraf/issues/62)
- Logfile parameter error [\#58](https://github.com/voxpupuli/puppet-telegraf/issues/58)
- "logfile" parameter not supported [\#52](https://github.com/voxpupuli/puppet-telegraf/issues/52)

**Merged pull requests:**

- Bump module release version to 1.5.0 [\#75](https://github.com/voxpupuli/puppet-telegraf/pull/75) ([yankcrime](https://github.com/yankcrime))
- Agent configuration - update and removal of certain options [\#74](https://github.com/voxpupuli/puppet-telegraf/pull/74) ([yankcrime](https://github.com/yankcrime))
- fix Puppetlint format string [\#73](https://github.com/voxpupuli/puppet-telegraf/pull/73) ([mxjessie](https://github.com/mxjessie))
- fix chmod on config-directory [\#66](https://github.com/voxpupuli/puppet-telegraf/pull/66) ([maximedevalland](https://github.com/maximedevalland))
- make package work with newer puppetlabs-apt, add support for metric batch size, and update buffer limit default to current telegraf default [\#63](https://github.com/voxpupuli/puppet-telegraf/pull/63) ([htj](https://github.com/htj))
- Add single\_section to input plugins \(\#41\) [\#60](https://github.com/voxpupuli/puppet-telegraf/pull/60) ([mxjessie](https://github.com/mxjessie))
- Fix typo in logfile parameter [\#59](https://github.com/voxpupuli/puppet-telegraf/pull/59) ([yankcrime](https://github.com/yankcrime))
- Support multiple output plugins of the same type [\#57](https://github.com/voxpupuli/puppet-telegraf/pull/57) ([KarolisL](https://github.com/KarolisL))
- Add logfile option. Fixes \#52 [\#56](https://github.com/voxpupuli/puppet-telegraf/pull/56) ([kkzinger](https://github.com/kkzinger))
- Provide the ability to add install options [\#55](https://github.com/voxpupuli/puppet-telegraf/pull/55) ([snahelou](https://github.com/snahelou))

## [1.4.0](https://github.com/voxpupuli/puppet-telegraf/tree/1.4.0) (2017-03-22)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.3.0...1.4.0)

**Closed issues:**

- Purge unmanaged files from `/etc/telegraf/telegraf.d` [\#39](https://github.com/voxpupuli/puppet-telegraf/issues/39)
- Allow setting groups for the `telegraph` user [\#26](https://github.com/voxpupuli/puppet-telegraf/issues/26)

**Merged pull requests:**

- Bump to version 1.4.0 [\#54](https://github.com/voxpupuli/puppet-telegraf/pull/54) ([yankcrime](https://github.com/yankcrime))
- Adding explicit support for OEL. [\#53](https://github.com/voxpupuli/puppet-telegraf/pull/53) ([jglenn9k](https://github.com/jglenn9k))
- Provide the ability to change the package name. [\#51](https://github.com/voxpupuli/puppet-telegraf/pull/51) ([snahelou](https://github.com/snahelou))
- Update repo url in install.pp for rhel machines. [\#50](https://github.com/voxpupuli/puppet-telegraf/pull/50) ([Joshua-Snapp](https://github.com/Joshua-Snapp))
- Provide the ability to disable or stop the telegraf service. [\#49](https://github.com/voxpupuli/puppet-telegraf/pull/49) ([Joshua-Snapp](https://github.com/Joshua-Snapp))
- add repo name for el systems [\#48](https://github.com/voxpupuli/puppet-telegraf/pull/48) ([ghost](https://github.com/ghost))
- Normalize Repository file for RHEL and CentOS [\#45](https://github.com/voxpupuli/puppet-telegraf/pull/45) ([doomnuggets](https://github.com/doomnuggets))
- Fix failing specs [\#44](https://github.com/voxpupuli/puppet-telegraf/pull/44) ([cosmopetrich](https://github.com/cosmopetrich))
- Add support for purging unmanaged config fragments [\#43](https://github.com/voxpupuli/puppet-telegraf/pull/43) ([cosmopetrich](https://github.com/cosmopetrich))
- Add windows support [\#40](https://github.com/voxpupuli/puppet-telegraf/pull/40) ([ripclawffb](https://github.com/ripclawffb))
- Handle testing with Puppet 4 and Ubuntu 16.04 [\#37](https://github.com/voxpupuli/puppet-telegraf/pull/37) ([yankcrime](https://github.com/yankcrime))
- add support for omit\_hostname agent parameter [\#36](https://github.com/voxpupuli/puppet-telegraf/pull/36) ([shamil](https://github.com/shamil))
- Documentation fix [\#34](https://github.com/voxpupuli/puppet-telegraf/pull/34) ([mnaser](https://github.com/mnaser))
- Fix Debian Installer [\#33](https://github.com/voxpupuli/puppet-telegraf/pull/33) ([spjmurray](https://github.com/spjmurray))
- allow selection unstable, nightly, etc repo type [\#31](https://github.com/voxpupuli/puppet-telegraf/pull/31) ([mmckinst](https://github.com/mmckinst))

## [1.3.0](https://github.com/voxpupuli/puppet-telegraf/tree/1.3.0) (2016-06-02)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.2.1...1.3.0)

**Closed issues:**

- Optionally use `hiera_hash` on `telegraf::inputs` and `telegraf::outputs` [\#27](https://github.com/voxpupuli/puppet-telegraf/issues/27)
- Allow input def without options defined [\#24](https://github.com/voxpupuli/puppet-telegraf/issues/24)

**Merged pull requests:**

- Housekeeping - typos, bump version to 1.3 [\#30](https://github.com/voxpupuli/puppet-telegraf/pull/30) ([yankcrime](https://github.com/yankcrime))
- Fix telegraf::input template options variable lookup [\#29](https://github.com/voxpupuli/puppet-telegraf/pull/29) ([yankcrime](https://github.com/yankcrime))
- Fix hiera\_merge behavior [\#28](https://github.com/voxpupuli/puppet-telegraf/pull/28) ([joshuaspence](https://github.com/joshuaspence))
- Support merging configuration from multiple files [\#25](https://github.com/voxpupuli/puppet-telegraf/pull/25) ([deric](https://github.com/deric))
- Update input.pp to use the $name variable [\#23](https://github.com/voxpupuli/puppet-telegraf/pull/23) ([lswith](https://github.com/lswith))
- Update input.conf.erb to handle more than strings [\#22](https://github.com/voxpupuli/puppet-telegraf/pull/22) ([lswith](https://github.com/lswith))

## [1.2.1](https://github.com/voxpupuli/puppet-telegraf/tree/1.2.1) (2016-04-19)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.2.0...1.2.1)

**Closed issues:**

- Package dependancy issues [\#19](https://github.com/voxpupuli/puppet-telegraf/issues/19)

**Merged pull requests:**

- Fix broken package deps [\#20](https://github.com/voxpupuli/puppet-telegraf/pull/20) ([yankcrime](https://github.com/yankcrime))

## [1.2.0](https://github.com/voxpupuli/puppet-telegraf/tree/1.2.0) (2016-04-16)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.1.3...1.2.0)

**Merged pull requests:**

- ensure apt-transport-https is installed on Debian [\#16](https://github.com/voxpupuli/puppet-telegraf/pull/16) ([deric](https://github.com/deric))
- acceptance tests on docker [\#14](https://github.com/voxpupuli/puppet-telegraf/pull/14) ([deric](https://github.com/deric))
- Add a new define telegraf::input [\#13](https://github.com/voxpupuli/puppet-telegraf/pull/13) ([stuartbfox](https://github.com/stuartbfox))
- Change validate\_array\($global\_tags\) to validate\_hash\($global\_tags\) [\#10](https://github.com/voxpupuli/puppet-telegraf/pull/10) ([stuartbfox](https://github.com/stuartbfox))

## [1.1.3](https://github.com/voxpupuli/puppet-telegraf/tree/1.1.3) (2016-03-18)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.1.2...1.1.3)

**Merged pull requests:**

- Validate parameter data types [\#9](https://github.com/voxpupuli/puppet-telegraf/pull/9) ([yankcrime](https://github.com/yankcrime))

## [1.1.2](https://github.com/voxpupuli/puppet-telegraf/tree/1.1.2) (2016-03-11)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.1.1...1.1.2)

**Closed issues:**

- Don't require a specific repo name when manage\_repo = false [\#7](https://github.com/voxpupuli/puppet-telegraf/issues/7)
- Configuration updates / changes should trigger a reload [\#4](https://github.com/voxpupuli/puppet-telegraf/issues/4)

**Merged pull requests:**

- Refactor install class to handle manage\_repo being set to false [\#8](https://github.com/voxpupuli/puppet-telegraf/pull/8) ([yankcrime](https://github.com/yankcrime))
- SIGHUP the telegraf process on configuration change [\#5](https://github.com/voxpupuli/puppet-telegraf/pull/5) ([yankcrime](https://github.com/yankcrime))
- Now sorting hashes so they don't jumble on every puppet run + properly printing arrays [\#3](https://github.com/voxpupuli/puppet-telegraf/pull/3) ([AshtonDavis](https://github.com/AshtonDavis))

## [1.1.1](https://github.com/voxpupuli/puppet-telegraf/tree/1.1.1) (2016-03-08)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.1.0...1.1.1)

**Merged pull requests:**

- Add some basic acceptance tests [\#2](https://github.com/voxpupuli/puppet-telegraf/pull/2) ([yankcrime](https://github.com/yankcrime))

## [1.1.0](https://github.com/voxpupuli/puppet-telegraf/tree/1.1.0) (2016-03-06)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/1.0.0...1.1.0)

## [1.0.0](https://github.com/voxpupuli/puppet-telegraf/tree/1.0.0) (2016-03-04)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/0.0.5...1.0.0)

## [0.0.5](https://github.com/voxpupuli/puppet-telegraf/tree/0.0.5) (2016-03-02)

[Full Changelog](https://github.com/voxpupuli/puppet-telegraf/compare/2f5049c5b4ceee8180fce771a1a0a7d977ced76b...0.0.5)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
